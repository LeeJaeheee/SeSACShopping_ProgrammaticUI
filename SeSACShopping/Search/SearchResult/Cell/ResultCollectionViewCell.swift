//
//  ResultCollectionViewCell.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/20/24.
//

import UIKit
import Kingfisher

class ResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var mallNameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var lpriceLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    var productId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeButton.backgroundColor = .white
        likeButton.tintColor = .black
        likeButton.setBorder(color: .placeholderText, width: 1)

        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        imageView.setCornerRadius(12)
        imageView.contentMode = .scaleAspectFill
        
        mallNameLabel.font = .systemFont(ofSize: 11)
        mallNameLabel.textColor = .systemGray
        
        titleLabel.font = .systemFont(ofSize: 12)
        
        lpriceLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    override func draw(_ rect: CGRect) {
        likeButton.layer.cornerRadius = likeButton.frame.width / 2
    }
    
    @objc func likeButtonTapped() {
        likeButton.configureLikeButtonImage(
            isLiked: UserDefaultsManager.shared.updateLike(productId: productId))
    }
    
    func configureCell(data: ResultItem) {
        imageView.kf.setImage(with: URL(string: data.image))
        
        mallNameLabel.text = data.mallName
        
        titleLabel.text = data.removeTagTitle
        
        let numString = Int(data.lprice)?.formatted()
        lpriceLabel.text = numString
        
        productId = data.productId
        
        likeButton.configureLikeButtonImage(
            isLiked: UserDefaultsManager.shared.isLiked(productId: data.productId))
    }

}
