//
//  ApiService.swift
//  CarMisr
//
//  Created by Muhammad Abumandour on 15/02/2022.
//

import Foundation


public class ApiService : ApiProtocol {
            
    public func fetchItem<T:Codable>(urlRequest: URLRequest) async -> Result<T,ApiError> {
        let urlSessionConfiguration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: urlSessionConfiguration)
        do{
            let (data, response)  = try await urlSession.data(for: urlRequest, delegate: nil)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.InvaildHttpResponse)
            }
            guard httpResponse.statusCode == 200 else {
                return .failure(.InvaildStatusCode(httpResponse.statusCode))
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                return .success(result)
            } catch let error{
                print(error)
                return .failure(.SerializeError(error))
            }
        } catch let error {
            return .failure(.InvaildData(error))
        }
    }
        
}
