//
//  ProfileImageCollectionViewCell.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/19/24.
//

import UIKit

class ProfileImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        imageView.setRound()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.layer.borderWidth = 0
    }

}
