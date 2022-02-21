//
//  EndPointProtocol.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 21/02/2022.
//

import Foundation


protocol BaseEndPoint{
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any]? { get }
}

extension BaseEndPoint{
    
    public var urlRequest: URLRequest {
        guard let url = self.url else {
            fatalError("URL could not be built")
        }
        print(url.absoluteString)
        return URLRequest(url: url)
    }

    private var url: URL? {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = path
        guard let parameters = parameters as? [String: String] else {
            fatalError("parameters for GET http method must conform to [String: String]")
        }
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        return urlComponents?.url
    }
}
