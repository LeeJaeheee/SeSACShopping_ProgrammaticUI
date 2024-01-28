//
//  UIImageView+Extension.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/18/24.
//

import UIKit

extension UIImageView {
    
    func setRound() {
        layoutIfNeeded()
        layer.cornerRadius = self.frame.width / 2
        layer.masksToBounds = true
    }
    
    func setDefaultBorder() {
        layer.borderColor = UIColor.accent.cgColor
        layer.borderWidth = 5
    }
    
}
