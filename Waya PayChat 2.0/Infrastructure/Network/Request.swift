//
//  Request.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 08/06/2021.
//

import Foundation
//import Reachability


class Request {
    static let shared = Request(service: RequestHandler())
    var service: NetworkService!
//    var connected: Bool!
//    let reachability: Reachability!
    init(service: NetworkService) {
        self.service = service
//        self.connected = false
        
//        self.reachability = try! Reachability()
//        reachability.whenReachable = { reachability in
//            if reachability.connection == .wifi || reachability.connection == .cellular {
//                self.connected = true
//            } else {
//                self.connected = false
//            }
//        }
//        reachability.whenUnreachable = { _ in
//            self.connected = false
//        }
//
//        do {
//            try reachability.startNotifier()
////            reachability.
//        } catch(let error) {
//            print("Unable to start notifier: \(error)")
//        }
    }
    
    func fetch<T>(_ request: NetworkRequest, completion: @escaping (NetworkResponse, T?) -> Void) where T : Decodable, T : Encodable {
        self.service.fetch(request) { (status, _ response: T?) in
            completion(status, response)
        }
    }
    
    func push<T>(_ request: NetworkRequest, completion: @escaping (NetworkResponse, T?) -> Void) where T : Decodable, T : Encodable {
        self.service.push(request) { (status, _ response: T?) in
            completion(status, response)
        }
    }
}
