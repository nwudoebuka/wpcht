//
//  WayaPayResponse.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/20/21.
//

import Foundation

enum APIError: Error{
    case custom(message: String)
    var localizedDescription: String {
        switch self {
        case .custom(let error):
            return error
        }
    }
}


// TODO: Prune all of these

struct WayaPayHttpResponse<T> : Codable where T: Codable {
    
    let timeStamp : String?
    let status : Bool?
    let message : String
    let data: T?        
    let code : Int?
}

struct WayaPayHttpResponseIntTime<T> : Codable where T: Codable {
    let timeStamp : Int?
    let status: Bool?
    let message: String?
    let data: T? 
}

struct Wt<T> : Codable where T : Codable{
    let timestamp : String
    let status : Int
    let message : String
    let data: T? 
    let path : String?
}

struct WayaPayHttpResp<T> : Codable where T: Codable {
    
    let status : Bool?
    let message : String?
    let data: T?        
    let code : Int?
}

//socials 
struct WayaPayHttptResp<T> : Codable where T: Codable{
    
    let status : Bool?
    let message : String
    let data: T?       
    let timestamp : String?
}

struct WayaPayHttptRespStatus<T> : Codable where T: Codable{
    
    let status : Bool
    let data : T?
    let message : String
    let timeStamp : String?
}

struct WayaPayHttptResp2<T> : Codable where T: Codable{
    
    let status : Bool?
    let message : String
    let data: T?       
    let timestamp : Int?
}


//For certain endpoints like transfer 
struct WayaPayHttptResp3: Codable {
    let status: Bool
    let message: String
    let code: Int
}
    
extension WayaPayHttpResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
extension WayaPayHttpResponseIntTime: LocalizedError {
    var errorDescription: String? {
        return message
    }
}

extension WayaPayHttptResp: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
