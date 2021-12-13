//
//  NetworkService.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 03/06/2021.
//

import Foundation
import Alamofire

typealias Handler = (Swift.Result<Any?, APIError>)-> Void

protocol NetworkService {
    func fetch<T: Codable>(_ request: NetworkRequest, completion: @escaping (NetworkResponse, _ data: T?) -> Void)
    func push<T: Codable>(_ request: NetworkRequest, completion: @escaping (NetworkResponse, _ data: T?) -> Void)
}


struct NetworkRequest {
    var endpoint: WayaClient
    var method: HTTPMethod
    var encoding: Encoding
    var body: Dictionary<String, Any>
    var files: Dictionary<String, Data> = [:]
    
    init(endpoint: WayaClient, method: HTTPMethod, encoding: Encoding, body: Dictionary<String, Any>) {
        self.endpoint = endpoint
        self.method = method
        self.body = body
        self.encoding = encoding
    }
}

enum NetworkResponse {
    case success
    case failed(NetworkError)
    
    var localizedDescription: String {
        switch self {
        case .success:
            return "successful"
        case .failed(let error):
            return error.localizedDescription
        }
    }
}

enum NetworkError: Error {
    case api_error(String)
    case unauthenticated
    case unauthorized
    case not_found
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .api_error(let error):
            return error
        case .unauthenticated, .unauthorized:
            return "Request authorization failed, please login"
        case .not_found:
            return "Requested URL was not found"
        case .unknown(let error):
            return error
        }
    }
}

extension NetworkError: Comparable {
    static func < (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return false
    }
    
    static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
