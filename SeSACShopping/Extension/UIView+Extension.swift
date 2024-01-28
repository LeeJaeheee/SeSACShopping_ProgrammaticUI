//
//  UIView+Extension.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/20/24.
//

import UIKit

extension UIView {
    
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
    func setBorder(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
}
