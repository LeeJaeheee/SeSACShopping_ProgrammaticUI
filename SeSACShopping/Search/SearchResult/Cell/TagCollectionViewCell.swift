//
//  TagCollectionViewCell.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/20/24.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tagLabel.font = .systemFont(ofSize: 15)
        
        setCornerRadius(8)
        setBorder(color: .white, width: 1)
    }

}
