//
//  UserTableViewCell.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/19/24.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    
    let udManager = UserDefaultsManager.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.setDefaultBorder()
        
        nicknameLabel.font = .boldSystemFont(ofSize: 22)
        
        likeLabel.font = .boldSystemFont(ofSize: 14)
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
