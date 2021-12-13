//
//  HttpProtocol.swift
//  Waya PayChat 2.0
//
//  Created by Toju on 14/01/2021.
//

import Foundation

protocol HttpProtocol {
    func getRequest( url: String, completion: @escaping (Result<Data, Error>) -> ())
    func postRequest(param: [String: Any], url: String, completion: @escaping (Result<Data, Error>) -> ())
    func putRequest(param: [String: Any], url: String, completion: @escaping (Result<Data, Error>) -> ())
    func deleteRequest(url: String, completion: @escaping (Result<Data, Error>) -> ())
    func getRequestNoAuth( url: String, completion: @escaping (Result<Data, Error>) -> ())
    func postRequestNoAuth(param: [String: Any], url: String, completion: @escaping (Result<Data, Error>) -> ())
    func putRequestNoAuth(param: [String: Any], url: String, completion: @escaping (Result<Data, Error>) -> ())
    func deleteRequestNoAuth(url: String, completion: @escaping (Result<Data, Error>) -> ())

}
