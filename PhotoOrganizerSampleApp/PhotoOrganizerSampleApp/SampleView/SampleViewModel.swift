//
//  SampleViewModel.swift
//  PhotoOrganizerSampleApp
//
//  Created by 박준홍 on 5/21/24.
//

import PhotoOrganizer
import DownpourRx
import Photos
import UIKit

final class SampleViewModel {
    private let photoOrganizer: PhotoOrganizer
    private let categories: [String]
    
    var organizedPhotoManager: SafeOrganizedPhotosChunk = .init()
    var encodersLoadingDuration: Double = 0
    
    let isLoadingRelay: BehaviorRelay<Bool> = .init(value: false)
    
    let isCategorizingRelay: BehaviorRelay<Bool> = .init(value: false)
    
    let didLoadDataRelay: PublishRelay<Void> = .init()
    
    private(set) var unsafeOrganizedPhotoManager: UnSafeOrganizedPhotosChunk?
    
    init(
        photoOrganizer: PhotoOrganizer,
        categories: [String]
    ) {
        self.photoOrganizer = photoOrganizer
        self.categories = categories
    }
    
    func loadPhotoOrganizer() {
        print("Start Loading Encoders ...")
        
        organizedPhotoManager = .init()
        
        Task {
            let start = DispatchTime.now()
            
            self.isLoadingRelay.accept(true)
            await self.photoOrganizer.loadEncoders()
            self.isLoadingRelay.accept(false)
            
            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000
            print("loadPhotoOrganizer took \(timeInterval) seconds.")
            encodersLoadingDuration = timeInterval
        }
        
    }
    
    func getPhotoAndOrganizeImage() async {
        requestPhotoLibraryAuthorization { [weak self] hasAuth in
            guard let self = self else { return }
            Task {
                if hasAuth {
                    let images = await self.fetchRecentPhotos()
                        .map { DayPicPhoto(image: $0) }
                    await self.organizePhoto(images: images)
        
                } else {
                    print("Cannot access to Photo Library: Access Denied")
                    return
                }
            }
        }
    }
    
    private func organizePhoto(images: [DayPicPhoto]) async {
        let start = DispatchTime.now()
        
        organizedPhotoManager = .init()
        
        self.isCategorizingRelay.accept(true)
        for batch in stride(from: 0, to: images.count, by: 10) {
            let end = min(batch + 10, images.count)
            let batchImages = Array(images[batch..<end])
            
            await withTaskGroup(of: Void.self) { group in
                for idx in 0..<batchImages.count {
                    let image = batchImages[idx]
                    group.addTask {
                        let tag = await self.getCategorySimilarity(image: image)
                        await self.organizedPhotoManager.appendPhoto(batch + idx, image, tag)
                    }
                }
            }
        }
        
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print("test for \(images.count) images and \(categories.count) categories took \(timeInterval) seconds.")
        
        await updatePhotos(duration: timeInterval)
        self.didLoadDataRelay.accept(())
        
        self.isCategorizingRelay.accept(false)
    }
    
    private func updatePhotos(duration: Double) async {
        let photos = await organizedPhotoManager.photos.sorted { $0.index < $1.index }
        
        unsafeOrganizedPhotoManager = .init(
            photos: photos,
            updatedDate: Date(),
            encodersLoadingDuration: encodersLoadingDuration,
            organizeringDuration: duration
        )
    }
}

extension SampleViewModel {
    private func getCategorySimilarity(image: DayPicPhoto) async -> [String: Float] {
        let start = DispatchTime.now()
        
        let res = await self.photoOrganizer.computeSimilarity(
            image: image.image,
            categories: categories
        )
        
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print("getSimilarityWith took \(timeInterval) seconds. \n \(res) \n\n")
        
        return res
    }
    
    private func requestPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            completion(true)
        case .denied, .restricted, .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
            
        @unknown default:
            completion(false)
        }
    }
    
    private func fetchRecentPhotos(limit: Int = 100) async -> [UIImage] {
        var images: [UIImage] = []

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = limit

        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let imageManager = PHImageManager.default()

        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat

        for i in 0..<fetchResult.count {
            let asset = fetchResult.object(at: i)
            let size = CGSize(width: 224, height: 224)
            
            await withCheckedContinuation { continuation in
                imageManager.requestImage(
                    for: asset,
                    targetSize: size,
                    contentMode: .aspectFit,
                    options: options
                ) { (image, _) in
                    if let image = image {
                        images.append(image)
                    }
                    continuation.resume()
                }
            }
        }

        return images
    }
}
