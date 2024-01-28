//
//  SearchResult.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/20/24.
//

import UIKit

struct SearchResult: Codable {
    let total: Int
    let start: Int
    let display: Int
    let items: [ResultItem]
}

struct ResultItem: Codable {
    let title: String
    let image: String
    let lprice: String
    let mallName: String
    let productId: String
    
    var removeTagTitle: String {
        title
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
    }
}
