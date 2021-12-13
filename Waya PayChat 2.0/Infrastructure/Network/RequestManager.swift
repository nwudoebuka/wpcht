//
//  RequestManager.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 20/05/2021.
//

import Foundation
import Alamofire
import Signals

struct RequestManager {
    static let shared: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        let sessionManager = Session(configuration: configuration, delegate: SessionDelegate(), serverTrustManager: nil)
        return sessionManager
    }()
}

enum Encoding {
    case json
    case url
    case urlJson
    case upload
    
    var get: ParameterEncoding {
        switch self {
        case .json, .upload:
            return JSONEncoding.default
        case .url, .urlJson:
            return URLEncoding.default
        }
    }
    
    var contentType: (name: String, value: String) {
        switch self {
        case .json, .urlJson:
            return (name: "Content-Type", value: "application/json")
        case .url:
            return (name: "Content-Type", value: "application/x-www-form-urlencoded")
        case .upload:
            return (name: "Content-type", value: "multipart/form-data")
        }
    }
}

class RequestHandler: NetworkService {
    
    private var jobIds: [String] = [] // todo: use for network request throttling on async calls

    private func buildRequestHeaders(encoding: Encoding) -> HTTPHeaders {
        var headers: HTTPHeaders = ["Accept" : "application/json"]
        headers.add(name: encoding.contentType.name, value: encoding.contentType.value)
        
        if let token = auth.data.token {
            headers.add(name: "Authorization", value: token)
        }
        
        return headers
    }
    
    func fetch<T>(_ request: NetworkRequest, completion: @escaping (NetworkResponse, T?) -> Void) where T : Decodable, T : Encodable {
        let headers = buildRequestHeaders(encoding: request.encoding)
       
        RequestManager.shared.request(request.endpoint.url!, method: request.method, parameters: request.body, encoding: request.encoding.get, headers: headers).response { response in
            print("network response: \(response.debugDescription)")
            self.response(response) { (status, _ response: T?) in
                completion(status, response)
            }
        }
    }
    
    func push<T>(_ request: NetworkRequest, completion: @escaping (NetworkResponse, T?) -> Void) where T: Encodable, T: Decodable {
        
        let headers = buildRequestHeaders(encoding: request.encoding)
        
        let block = { (multipart: MultipartFormData) in
            if request.body.count > 0 {
                for (key, value) in request.body {
                    if let data = self.form_data(value: value) {
                        print("appending: \(key): \(value)")
                        multipart.append(data, withName: key)
                    } else {
                        print("could not append")
                    }
                }
            }
            if request.files.count > 0 {
                for (key, value) in request.files {
                    let fileName = NSUUID().uuidString
                    multipart.append(value, withName: "\(key)", fileName: "\(fileName).jpeg", mimeType: "image/jpeg")
                }
            }
        }
        
        AF.upload(multipartFormData: block, to: request.endpoint.url!, method: request.method, headers: headers).response { response in
            print("network response: \(response.debugDescription)")
            self.response(response) { (status, _ response: T?) in
                completion(status, response)
            }
        }
    }
    
    private func response<T: Codable>(_ response: AFDataResponse<Data?>,_ completion: @escaping (NetworkResponse, T?) -> Void) {
        switch(response.response?.statusCode) {
            case 200, 201:
                if let jsonData = response.data {
                    if let json = try? JSONDecoder().decode(T.self, from: jsonData) {
                        completion(.success, json)
                        return
                    }
                    
                    do {
                        let obj = try JSONSerialization.jsonObject(with: jsonData, options: [.fragmentsAllowed, .allowFragments])
                        let data = try JSONSerialization.data(withJSONObject: obj, options: [.fragmentsAllowed, .prettyPrinted])
                        
                        do {
                            let serialized = try JSONDecoder().decode(T.self, from: data)
                            print("serialized: \(serialized)")
                            completion(.success, serialized)
                        } catch(let error) {
                            completion(.success, nil)
                            print("error on serialize:  \(error)")
                        }
                    } catch {
                        print("error: \(error)")
                    }
                } else {
                    completion(.success, nil)
                }
            case 400, 401:
                guard let data = response.data else {
                    completion(.failed(.api_error("No response received")), nil)
                    return
                }
                if let server_error = try? JSONDecoder().decode(Response<String>.self, from: data) {
                    completion(.failed(.api_error(server_error.message ?? "Unknown Error")), nil)
                    return
                } else {
                    guard let server_error = try? JSONDecoder().decode(Response<[String]>.self, from: data) else {
                        completion(.failed(.unknown("Bad Request")), nil)
                        return
                    }
                    completion(.failed(.api_error(server_error.data!.first!)), nil)
                }
            case 403:
                completion(.failed(.unauthenticated), nil)
            case 404, 422:
                guard let data = response.data, let resp = try? JSONDecoder().decode(Response<String>.self, from: data) else {
                    completion(.failed(.unknown("Unable to decode errorr")), nil)
                    return
                }
                completion(.failed(.unknown(resp.message ?? "An unknown error has occured, please try again")), nil)
            default:
                RequestManager.shared.cancelAllRequests()
                completion(.failed(.unknown("Your internet connection appears to be offline")), nil)
        }
    }
    
    private func form_data(value: Any) -> Data? {
        if value is String {
            if let temp = value as? String {
                return temp.data(using: .utf8, allowLossyConversion: false)!
            }
        } else if value is Int {
            if let temp = value as? Int {
                let data = try! JSONEncoder().encode(temp)
                return data
            }
        } else if value is Bool {
            if let temp = value as? Bool {
                let boolData = try! JSONEncoder().encode(temp)
                return boolData
            }
        }
        return nil
    }
}
