//
//  ProfileImageCollectionViewCell.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/19/24.
//

import UIKit

class ProfileImageCollectionViewCell: UICollectionViewCell {

    let imageView = RoundImageView(image: nil)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.layer.borderWidth = 0
    }

}
