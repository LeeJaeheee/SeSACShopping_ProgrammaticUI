//
//  TagCollectionViewCell.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/20/24.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    let tagLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setCornerRadius(8)
        setBorder(color: .white, width: 1)
        
        contentView.addSubview(tagLabel)
        tagLabel.font = .systemFont(ofSize: 15)
        tagLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
