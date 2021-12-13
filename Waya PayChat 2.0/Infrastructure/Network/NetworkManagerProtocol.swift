//
//  NetworkManagerProtocol.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/20/21.
//

import Foundation


protocol NetworkMangerProtocol {
    
    func initialGETRequest<ResponseType: Codable>(url: URL, responseType: ResponseType.Type, completion: @escaping ( ResponseType?, Error?) -> ()) -> URLSessionDataTask
    
    func initPOSTRequest<RequestType: Encodable, ResponseType: Codable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> ())
    
    func initPUTRequest<RequestType : Encodable, ResponseType : Codable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> ())
    
    func initDELETERequest<RequestType: Encodable, ResponseType: Codable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> ())
    
    func initDELETE<ResponseType: Codable>(url: URL,  responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> ())
}

public protocol NetworkCancellable {
    func cancel()
}
