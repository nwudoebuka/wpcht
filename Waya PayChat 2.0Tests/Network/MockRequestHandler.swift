//
//  MockRequestHandler.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 07/06/2021.
//
@testable import Waya_PayChat_2_0
import Foundation
//import SQLite

class MockNetworkHandler: NetworkService {

    var db: [String: Any]!
    
    init() {
        if let path = Bundle.main.path(forResource: "db", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: [.mutableLeaves])
                if let jsonResult = json as? [String: Any] {
                    self.db = jsonResult
                } else {
                    print("could not cast json")
                }
            } catch {
                return
            }
        } else {
            print("could not load json")
        }
        
    }
    
    func fetch<T>(_ request: NetworkRequest, completion: @escaping (NetworkError, T?) -> Void) where T : Decodable, T : Encodable {
        let url = WayaTestClient(endpoint: request.endpoint)
        let part = url.stringValue.components(separatedBy: "/")

        guard let service = db["\(part[0])"] as? Dictionary<String, Any> else {
            print("failed to parse")
            return
        }

        guard let route = service["\(part[1])"] as? [String: Any] else {
//            print("no route found")
            return
        }
        
        guard let correct_output = route["correct_output"]! as? [String: Any] else {
            return
        }
     
        guard let incorrect_output = route["incorrect_output"]! as? [String: Any] else {
            completion(.failed("incorrect response page not found"), nil)
            return
        }
//        
        let responseDict: [String: Any] = [
            "correct_output" : correct_output,
            "incorrect_output" : incorrect_output
        ]
        guard let responseData = try? JSONSerialization.data(withJSONObject: responseDict, options: [.prettyPrinted, .fragmentsAllowed]) else {
            completion(.failed("response data could not be constructed"), nil)
            return
        }
//
        guard let correct = try? JSONDecoder().decode(T.self, from: responseData) else {
//            print("able to create correct")
            completion(.failed("unable to construct response"), nil)
            return
        }
        completion(.success, correct)
    }
}
