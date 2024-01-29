//
//  EmptyView.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/28/24.
//

import UIKit

class EmptyView: UIView {
    
    let emptyImageView = UIImageView()
    let emptyLabel = UILabel()

    convenience init(text: String) {
        self.init(frame: .zero)
        
        addSubview(emptyImageView)
        addSubview(emptyLabel)
        
        backgroundColor = .systemBackground
        
        emptyImageView.image = .empty
        
        emptyLabel.text = text
        emptyLabel.font = .boldSystemFont(ofSize: 18)
        
        emptyImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.9)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(emptyImageView.snp.width).multipliedBy(236.0/327.0)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emptyImageView.snp.bottom).offset(24)
            make.leading.greaterThanOrEqualToSuperview().offset(50)
            make.trailing.lessThanOrEqualToSuperview().offset(-50)
            make.height.equalTo(28)
        }
    }
    
}
