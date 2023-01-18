//
//  JSONHelper.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 18.01.2023.
//

import Foundation

class JsonHelper {
    static let shared = JsonHelper()
    private lazy var decoder: JSONDecoder = {
       let decoder = JSONDecoder()
        return decoder
    }()
    
    func decode<T:Codable>(type: T.Type, data: Data)->T? {
        do {
            let content = try decoder.decode(T.self, from: data)
            return content
        }
        
        catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
}
