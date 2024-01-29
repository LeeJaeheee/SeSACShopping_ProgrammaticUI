//
//  MainButton.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/29/24.
//

import UIKit

class MainButton: UIButton {
    
    init(title: String) {
        super.init(frame: .zero)
        
        configureLayout()
        configureView(title: title)
    }
    
    func configureView(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        backgroundColor = .accent
        tintColor = .white
        
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    func configureLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
