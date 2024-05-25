//
//  CategorizedImageCell.swift
//  PhotoOrganizerSampleApp
//
//  Created by 박준홍 on 5/23/24.
//

import UIKit
import SnapKit

final class CategorizedImageCell: UICollectionViewCell {
    
    private let imgView: UIImageView = .init()
    private let categoryView: UITextView = .init()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
        imgView.contentMode = .scaleAspectFit
    }
    
    func configure(with photo: OrganizedPhoto) {
        imgView.image = photo.image.image
        categoryView.text = photo.tag
            .sorted(by: { $0.value > $1.value })
            .map { "\($0.key): \($0.value)" }
            .joined(separator: "\n")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.width.height.equalTo(200)
            make.top.leading.equalToSuperview().offset(10)
        }
        
        self.contentView.addSubview(categoryView)
        categoryView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(imgView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
        
    }
}
