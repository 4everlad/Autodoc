//
//  NetworkClient.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 18.01.2023.
//

import Foundation

enum Method: String {
    case get = "GET"
}

class NetworkClient {
    private let config = NetworkConfiguration()
    
    private lazy var urlSession: URLSession? = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 60
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    func requestAsync<T:Codable>(path: String, method: Method = .get) async -> Result<T,Error> {
        
        guard let urlRequest = getUrlRequest(path: path, method: method) else {
            return .failure(CustomError(message: "Wrong url request"))
        }
        
        let content = try? await urlSession?.data(for: urlRequest, delegate: nil)
        if let content = content {
            let data = content.0
            let response = content.1
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(CustomError(message: "No response"))
            }
            
            guard httpResponse.statusCode == 200 else {
                if let json = String(data: data, encoding: .utf8) {
                    return .failure(CustomError(message: json))
                } else {
                    return .failure(CustomError(message: "Error code \(httpResponse.statusCode)"))
                }
            }
            
            guard let decoded = JsonHelper.shared.decode(type: T.self, data: data) else {
                return .failure(CustomError(message: "Decoding error"))
            }
            
            return .success(decoded)
            
        }
        return .failure(CustomError(message: "No response"))
    }
    
    func getUrlRequest(path: String, method: Method) -> URLRequest? {
        let baseUrl = config.getBaseUrl()
        
        guard let urlComponents = URLComponents(string: "\(baseUrl)\(path)") else {
            return nil
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}

class CustomError : Error {
    var message: String = ""
    
    init(message: String) {
        self.message = message
    }
}

class NetworkConfiguration {
    private let apiUrl = "https://webapi.autodoc.ru/api/"
    
    func getBaseUrl() -> String {
        return apiUrl
    }
}
