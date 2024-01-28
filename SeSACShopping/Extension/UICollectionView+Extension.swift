//
//  UICollectionView+Extension.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/22/24.
//

import UIKit

extension UICollectionView {
    
    var type: CollectionViewType {
        get { return CollectionViewType(rawValue: self.tag) ?? .tagCollectionView }
        set { self.tag = newValue.rawValue }
    }
    
}
