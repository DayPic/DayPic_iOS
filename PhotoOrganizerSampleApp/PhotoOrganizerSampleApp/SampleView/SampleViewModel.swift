//
//  SampleViewModel.swift
//  PhotoOrganizerSampleApp
//
//  Created by 박준홍 on 5/21/24.
//

import PhotoOrganizer
import DownpourRx
import UIKit

final class SampleViewModel {
    private let photoOrganizer: PhotoOrganizer
    private let categories: [String]
    
    let isLoadingRelay: BehaviorRelay<Bool> = .init(value: false)
    
    init(
        photoOrganizer: PhotoOrganizer
    ) {
        self.photoOrganizer = photoOrganizer
        self.categories = ["food", "scene", "human", "animal", "nature", "city", "product", "exercise"]
    }
    
    func loadPhotoOrganizer() {
        print("Start Loading Encoders ...")
        
        Task {
            let start = DispatchTime.now()
            
            self.isLoadingRelay.accept(true)
            await self.photoOrganizer.loadEncoders()
            self.isLoadingRelay.accept(false)
            
            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000
            print("loadPhotoOrganizer took \(timeInterval) seconds.")
        }
        
    }
    
    func getCategorySimilarity(image: UIImage) async -> [String: Float] {
        let start = DispatchTime.now()
        
        let res = await self.photoOrganizer.computeSimilarity(
            image: image,
            categories: categories
        )
        
        let end = DispatchTime.now()
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        print("getSimilarityWith took \(timeInterval) seconds. \n \(res) \n\n")
        
        return res
    }
    
}
