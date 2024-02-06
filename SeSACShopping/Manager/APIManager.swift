//
//  APIManager.swift
//  SeSACShopping
//
//  Created by 이재희 on 1/20/24.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
    
    var errorMessage: String {
        switch self {
        case .failedRequest:
            return "네트워크 통신이 실패했습니다."
        case .noData:
            return "전달받은 데이터가 없습니다."
        case .invalidResponse:
            return "유효한 응답이 아닙니다."
        case .invalidData:
            return "유효한 데이터가 아닙니다."
        }
    }
}

struct APIManager {
    
    func callRequest(queryString: QueryString, completionHandler: @escaping (SearchResult?, NetworkError?) -> Void) {
        let query = queryString.query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var component = URLComponents()
        component.scheme = "https"
        component.host = "openapi.naver.com"
        component.path = "/v1/search/shop.json"
        component.queryItems = [URLQueryItem(name: "query", value: query),
                                URLQueryItem(name: "display", value: "\(queryString.display)"),
                                URLQueryItem(name: "start", value: "\(queryString.start)"),
                                URLQueryItem(name: "sort", value: queryString.sort)]
        
        guard let url = component.url else { print("URL 옵셔널 바인딩 실패"); return }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(APIKey.NaverClientID, forHTTPHeaderField: "X-Naver-Client-Id")
        urlRequest.addValue(APIKey.NaverClientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    completionHandler(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completionHandler(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    completionHandler(nil, .invalidData)
                    return
                }
                
                do {
                    let data = try JSONDecoder().decode(SearchResult.self, from: data)
                    completionHandler(data, nil)
                } catch {
                    completionHandler(nil, .invalidData)
                }
            }
        }.resume()

    }
    
}
