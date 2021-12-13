//
//  Http.swift
//  Waya PayChat 2.0
//
//  Created by Toju on 14/01/2021.
//

import Foundation

class Http: HttpProtocol {
    
    let baseUrl = "https://api.foo.com/"
    let token = "Bearer 123456789"
    
    //Singleton
    static let instance = Http()
    
    
    func getRequest(url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: "\(baseUrl)\(url)") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(data!))
                
            }
        }.resume()
    }
    
    
    func postRequest(param: [String : Any], url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: "\(baseUrl)\(url)")
            else { fatalError("Invalid URL") }
        let body = try! JSONSerialization.data(withJSONObject: param)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
               if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(data!))
            }
        }.resume()
    }
    
    func putRequest(param: [String : Any], url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: "\(baseUrl)\(url)")
            else { fatalError("Invalid URL") }
        let body = try! JSONSerialization.data(withJSONObject: param)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = body
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
               if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(data!))
            }
        }.resume()
    }
    
    func deleteRequest(url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: "\(baseUrl)\(url)") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(data!))
                
            }
        }.resume()
    }
    
    func getRequestNoAuth(url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: "\(baseUrl)\(url)") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(data!))
                
            }
        }.resume()
    }
    
    func postRequestNoAuth(param: [String : Any], url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: "\(baseUrl)\(url)")
            else { fatalError("Invalid URL") }
        let body = try! JSONSerialization.data(withJSONObject: param)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
               if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(data!))
            }
        }.resume()
    }
    
    func putRequestNoAuth(param: [String : Any], url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: "\(baseUrl)\(url)")
            else { fatalError("Invalid URL") }
        let body = try! JSONSerialization.data(withJSONObject: param)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
               if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(data!))
            }
        }.resume()
    }
    
    func deleteRequestNoAuth(url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: "\(baseUrl)\(url)") else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(data!))
                
            }
        }.resume()
    }
    
    
    
    
}
