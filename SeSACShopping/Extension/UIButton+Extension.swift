//
//  UIButton+Extension.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/18/24.
//

import UIKit

extension UIButton {
    
    func setDefaultStyle(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        backgroundColor = .accent
        tintColor = .white
        
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    func setDisable() {
        isEnabled = false
        alpha = 0.8
    }
    
    func setEnable() {
        isEnabled = true
        alpha = 1
    }
    
    func configureLikeButtonImage(isLiked: Bool) {
        let imageName = isLiked ? "heart.fill" : "heart"
        setImage(UIImage(systemName: imageName), for: .normal)
    }
    
}
