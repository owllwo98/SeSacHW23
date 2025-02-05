//
//  PhotoCollectionViewCell.swift
//  SeSacHW23
//
//  Created by 변정훈 on 2/4/25.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let id = "PhotoCollectionViewCell"
    
    let photoImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureUI()
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureHierarchy() {
        contentView.addSubview(photoImage)
    }
    
    private func configureLayout() {
        photoImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureUI() {
        
    }
    
    func configureData(image: UIImage) {
        photoImage.image = image
    }
    
}
