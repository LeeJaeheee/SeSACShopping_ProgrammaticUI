//
//  UIViewController+Extension.swift
//  SeSACShopping
//
//  Created by 이재희 on 2/6/24.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, okTitle: String = "확인", showCancelButton: Bool = false, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            handler?()
        }
        alert.addAction(okAction)
        
        if showCancelButton {
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        }
        
        present(alert, animated: true)
    }
    
}
