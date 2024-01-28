//
//  ConfigureProtocol.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/28/24.
//

import UIKit

@objc protocol ConfigureProtocol {
    func configureHierarchy()
    func configureView()
    func setupConstraints()
}

@objc protocol VCProtocol: ConfigureProtocol {
    @objc optional func configureNavigationItem()
    @objc optional func setupActions()
}

protocol CollectionViewProtocol: VCProtocol {
    func configureCollectionView()
    func configureCollectionViewLayout() -> UICollectionViewFlowLayout
}
