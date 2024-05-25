//
//  UIKit+.swift
//  PhotoOrganizerSampleApp
//
//  Created by 박준홍 on 5/25/24.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        
        return dateFormatter.string(from: self)
    }
}
