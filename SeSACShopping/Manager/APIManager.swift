//
//  APIManager.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/20/24.
//

import Foundation
import Alamofire

struct APIManager {
    
    func callRequest(queryString: QueryString, completionHandler: @escaping (SearchResult) -> Void) {
        let query = queryString.query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=\(queryString.display)&start=\(queryString.start)&sort=\(queryString.sort)"
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.NaverClientID,
            "X-Naver-Client-Secret": APIKey.NaverClientSecret
        ]
       
        AF.request(url, method: .get, headers: headers).responseDecodable(of: SearchResult.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success)
                
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
}
