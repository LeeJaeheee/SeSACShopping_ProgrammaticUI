//
//  ReusableProtocol.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/18/24.
//

import UIKit

protocol ReusableProtocol {
    
    static var identifier: String { get }
    
}

extension UIViewController: ReusableProtocol {
    
    static var identifier: String {
        String(describing: self)
    }
    
}

extension UITableViewCell: ReusableProtocol {
    
    static var identifier: String {
        String(describing: self)
    }
    
}

extension UICollectionViewCell: ReusableProtocol {
    
    static var identifier: String {
        String(describing: self)
    }
    
}
