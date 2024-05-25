//
//  OrganizedPhotosChunk.swift
//  PhotoOrganizerSampleApp
//
//  Created by 박준홍 on 5/23/24.
//

import UIKit

final class DayPicPhoto {
    let image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
}

struct OrganizedPhoto {
    let index: Int
    let image: DayPicPhoto
    let tag: [String: Float]
    
    init(_ index: Int, _ image: DayPicPhoto, _ tag: [String : Float]) {
        self.index = index
        self.image = image
        self.tag = tag
    }
}

final actor SafeOrganizedPhotosChunk {
    var photos: [OrganizedPhoto] = []
    var updatedDate: Date?
    
    
    func appendPhoto(_ photo: OrganizedPhoto) {
        self.photos.append(photo)
    }
    
    func appendPhoto(
        _ index: Int,
        _ image: DayPicPhoto,
        _ tag: [String: Float]
    ) {
        self.appendPhoto(OrganizedPhoto(index, image, tag))
    }
}

final class UnSafeOrganizedPhotosChunk {
    let photos: [OrganizedPhoto]
    let updatedDate: Date
    let encodersLoadingDuration: Double
    let organizeringDuration: Double
    
    
    init(photos: [OrganizedPhoto], updatedDate: Date, encodersLoadingDuration: Double, organizeringDuration: Double) {
        self.photos = photos
        self.updatedDate = updatedDate
        self.encodersLoadingDuration = encodersLoadingDuration
        self.organizeringDuration = organizeringDuration
    }
}
