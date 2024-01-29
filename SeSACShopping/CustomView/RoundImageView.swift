//
//  ProfileImageView.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/29/24.
//

import UIKit

class RoundImageView: UIImageView {
    
    var drawBorder = false {
        didSet {
            layer.borderWidth = drawBorder ? 5 : 0
        }
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        layer.borderColor = UIColor.accent.cgColor
        clipsToBounds = true
        isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
