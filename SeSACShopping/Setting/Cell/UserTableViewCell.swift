//
//  UserTableViewCell.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/19/24.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let likeLabel = UILabel()
    
    let udManager = UserDefaultsManager.shared
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        profileImageView.setRound()
    }
    
    func configureCell() {
        if let image = udManager.profileImage {
            profileImageView.image = UIImage(named: image)
        }
        if let nickname = udManager.nickname {
            nicknameLabel.text = nickname
        }
        
        let firstText = NSAttributedString(string: "\(udManager.likeList.count)개의 상품", attributes: [.foregroundColor: UIColor.accent])
        let secondText = NSAttributedString(string: "을 좋아하고 있어요!")
        
        let text = NSMutableAttributedString(attributedString: firstText)
        text.append(secondText)
        
        likeLabel.attributedText = text
    }
    
}

extension UserTableViewCell: ConfigureProtocol {
    func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(likeLabel)
    }
    
    func configureView() {
        profileImageView.setDefaultBorder()
        nicknameLabel.font = .boldSystemFont(ofSize: 22)
        likeLabel.font = .boldSystemFont(ofSize: 14)
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(54)
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalTo(16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
            make.height.equalTo(25)
        }
        
        likeLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(6)
            make.leading.equalTo(nicknameLabel)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
            make.height.equalTo(16)
        }
    }
    
}
