//
//  ResultCollectionViewCell.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/20/24.
//

import UIKit
import Kingfisher

class ResultCollectionViewCell: UICollectionViewCell {

    let imageView = UIImageView()
    let mallNameLabel = UILabel()
    let titleLabel = UILabel()
    let lpriceLabel = UILabel()
    let likeButton = UIButton()
    
    var productId = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        imageView.setCornerRadius(12)
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

extension ResultCollectionViewCell: ConfigureProtocol {
    func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(mallNameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lpriceLabel)
        contentView.addSubview(likeButton)
    }
    
    func configureView() {
        likeButton.backgroundColor = .white
        likeButton.tintColor = .black
        likeButton.setBorder(color: .placeholderText, width: 1)
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        imageView.contentMode = .scaleAspectFill
        
        mallNameLabel.font = .systemFont(ofSize: 11)
        mallNameLabel.textColor = .systemGray
        
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.numberOfLines = 0
        
        lpriceLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.size.equalTo(contentView.snp.width)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(mallNameLabel)
            make.height.lessThanOrEqualTo(30)
        }
        
        lpriceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(mallNameLabel)
            make.height.equalTo(18)
            make.bottom.lessThanOrEqualToSuperview().offset(-4)
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(35)
            make.bottom.trailing.equalTo(imageView).inset(8)
        }
    }
}
