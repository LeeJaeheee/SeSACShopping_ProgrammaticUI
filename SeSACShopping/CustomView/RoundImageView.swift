//
//  ProfileImageView.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/29/24.
//

import UIKit

class RoundImageView: UIImageView {
    
    var drawBorder = false {
        didSet {
            layer.borderWidth = drawBorder ? 5 : 0
        }
    }

    init(image: UIImage?, drawBorder: Bool = false) {
        super.init(image: image)
        self.drawBorder = drawBorder
        
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
    }
    
    func configureView() {
        layer.borderWidth = drawBorder ? 5 : 0
        layer.borderColor = UIColor.accent.cgColor
        clipsToBounds = true
        isUserInteractionEnabled = true
    }

    func configureLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(self.snp.width)
        }
    }
    
}
