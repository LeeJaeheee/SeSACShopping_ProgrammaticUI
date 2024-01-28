//
//  ProductDetailViewController.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/20/24.
//

import UIKit
import WebKit

class ProductDetailViewController: UIViewController {

    @IBOutlet var webView: WKWebView!
    
    let udManager = UserDefaultsManager.shared
    
    var data: ResultItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = data else { return }

        configureNavigationItem(data: data)
        loadWebView(productId: data.productId)
    }
    
    @objc func likeButtonTapped(_ sender: UIButton) {
        sender.configureLikeButtonImage(isLiked: udManager.updateLike(productId: data!.productId))
    }

}

extension ProductDetailViewController {
    
    func configureNavigationItem(data: ResultItem) {
        navigationItem.title = data.removeTagTitle
        
        let button = UIButton(type: .system)
        button.configureLikeButtonImage(isLiked: udManager.isLiked(productId: data.productId))
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func loadWebView(productId: String) {
        let url = URLRequest(url: URL(string: "https://msearch.shopping.naver.com/product/" + productId)!)
        webView.load(url)
    }
    
}
