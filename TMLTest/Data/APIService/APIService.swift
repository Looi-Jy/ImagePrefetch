//
//  APIService.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Combine
import UIKit


protocol APIServiceType {
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType
}

final class APIService: APIServiceType {
    
    var encoding: APIEncoding = .url
    var uploadPath: String = ""
    private var baseURL: URL?
    private var baseString: String
    
    init() {
        self.baseString = "https://picsum.photos"
        self.baseURL = URL(string: self.baseString)
    }

    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType {
        
        if let pathURL = URL(string: request.path, relativeTo: self.baseURL),
           var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true),
           let url: URL = urlComponents.url {
//            var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)
            
            var urlRequest = URLRequest(url: url)
            
//            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            switch self.encoding {
            case .url:
                urlComponents.queryItems =  request.getQueryItems()
                if let url = urlComponents.url {
                    urlRequest.url = url
                }
            case .json:
                let json = try? JSONSerialization.data(withJSONObject: request.params)
                urlRequest.httpBody = json
            }

            urlRequest.httpMethod = request.method.rawValue

            
            let decorder = JSONDecoder()
            decorder.keyDecodingStrategy = .convertFromSnakeCase
            return URLSession.shared.dataTaskPublisher(for: urlRequest)
                .map { data, urlResponse in
                    
                    //Convert data
                    if let jArray = try? JSONSerialization.jsonObject(with: data) as? [Any] {
                        let jDict: [String: Any] = ["data": jArray]
                        let jData: Data? = try? JSONSerialization.data(withJSONObject: jDict)
                        return jData ?? Data()
                    }
                    return data }
                .mapError { _ in APIServiceError.responseError }
                .decode(type: Request.Response.self, decoder: decorder)
                .mapError(APIServiceError.parseError)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
        
        return Empty().eraseToAnyPublisher()
    }
}
