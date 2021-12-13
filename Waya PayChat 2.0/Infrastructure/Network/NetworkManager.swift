//
//  NetworkManager.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/20/21.
//

import Foundation
import SwiftUI

struct NetworkManager{
    
    static let instance  = NetworkManager()
//    var token: String = ""
    
    private init(){}

} 

extension NetworkManager : NetworkMangerProtocol{
  
    func initialGETRequest<ResponseType: Codable>(url: URL, responseType: ResponseType.Type, completion: @escaping ( ResponseType?, Error?) -> ()) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("The post request to \(url) sent \(request.httpBody)")
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if  let json =   String(data: data, encoding: String.Encoding.utf8){
                print(json)
            }
        
    
            print("The data from the post is \(data) and response \(response)")
            //comment or remove to here
            let decoder = JSONDecoder()
            do {
                print("trying to decode data ...")
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    print("The decoder \(responseObject)")
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(WayaPayHttpResponseIntTime<ResponseType>.self, from: data) as Error
                    DispatchQueue.main.async {
                        print("The decoder failed \(errorResponse)")
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("The decder failed again \(error)")

                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    func initialGETRequest2<ResponseType: Codable>(url: URL, responseType: ResponseType.Type, completion: @escaping ( ResponseType?, Error?) -> ()) -> URLSessionDataTask {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("The post request to \(url) sent \(request.httpBody)")
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if  let json =   String(data: data, encoding: String.Encoding.utf8){
                print(json)
            }
            
            
            print("The data from the post is \(data) and response \(response)")
            //comment or remove to here
            let decoder = JSONDecoder()
            do {
                print("trying to decode data ...")
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    print("The decoder \(responseObject)")
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(WayaPayHttptResp<ResponseType>.self, from: data) as Error
                    DispatchQueue.main.async {
                        print("The decoder failed \(errorResponse)")
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("The decder failed again \(error)")
                        
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    func initPOSTRequest<RequestType : Encodable, ResponseType : Codable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> ())    {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let json = request.httpBody {
            let json =   String(data: json, encoding: String.Encoding.utf8)
            debugPrint("The payload data is \(String(describing: json))")
            print("The payload data is \(json!))")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            print("The post request to \(url) sent \(request.httpBody?.debugDescription)")
            print("The post request body is \(url) sent \(body)")

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            //This is for debuging on production remember to remove/comment this line 
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    print("The json of the data is  \(jsonArray)") // use the json here     
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            if let string = String(bytes: data, encoding: .utf8) {
                print("The string value of data is \(string)")
            } else {
                print("not a valid UTF-8 sequence")
            }
            print("The data from the post is \(data) and response \(response)")
            //comment or remove to here
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(WayaPayHttpResponse<ResponseType>.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func initPOSTRequestWithToken<RequestType : Encodable, ResponseType : Codable>(url: URL, responseType: ResponseType.Type, body: RequestType, headers: [String:String]? = nil, completion: @escaping (ResponseType?, Error?) -> ())    {
        let token = UserDefaults.standard.string(forKey: "Token") ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue(token, forHTTPHeaderField: "authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        headers?.forEach({
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        })
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("The post request to \(url) sent \(request)")

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            //This is for debuging on production remember to remove/comment this line 
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    print("The json of the data is  \(jsonArray)") // use the json here     
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            print("The post request to \(url) sent \(String(describing: request.httpBody))")
            if let string = String(bytes: data, encoding: .utf8) {
                print("The string value of data is \(string)")
            } else {
                print("not a valid UTF-8 sequence")
            }
            print("The data from the post is \(data) and response \(response)")
            //comment or remove to here
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(WayaPayHttpResponse<ResponseType>.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    func initPUTRequest<RequestType : Encodable, ResponseType : Codable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> ()){
        
        let token = UserDefaults.standard.string(forKey: "Token") ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
     //   request.addValue(token, forHTTPHeaderField: "authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("The put request  for update to \(url) sent \(request)")
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            //This is for debuging on production remember to remove/comment this line 
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    print("The json of the data is  \(jsonArray)") // use the json here     
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            print("The data from the post is \(data) and response \(response)")
            //comment or remove to here
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(WayaPayHttpResponse<ResponseType>.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func initDELETERequest<RequestType: Encodable, ResponseType: Codable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> ()) {
        let token = UserDefaults.standard.string(forKey: "Token") ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = try! JSONEncoder().encode(body)
        //   request.addValue(token, forHTTPHeaderField: "authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("The put request  for update to \(url) sent \(request)")
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            //This is for debuging on production remember to remove/comment this line 
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    print("The json of the data is  \(jsonArray)") // use the json here     
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            print("The data from the post is \(data) and response \(response)")
            //comment or remove to here
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(WayaPayHttpResponse<ResponseType>.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
    } 

    func initDELETE<ResponseType: Codable>(url: URL,  responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> ()){
        let token = UserDefaults.standard.string(forKey: "Token") ?? ""
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        //   request.addValue(token, forHTTPHeaderField: "authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("The put request  for update to \(url) sent \(request)")
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            //This is for debuging on production remember to remove/comment this line 
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    print("The json of the data is  \(jsonArray)") // use the json here     
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            print("The data from the post is \(data) and response \(response)")
            //comment or remove to here
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(WayaPayHttpResponse<ResponseType>.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func postApiDataWithMultipartForm<T:Decodable>(requestUrl: URL, data: Data, resultType: T.Type, completionHandler:@escaping(_ result: T?, Error?)-> Void)
    {
        guard let requesr = URL(string: "https://api.imgur.com/3/upload") else{
            return
        }
        
        var request = URLRequest(url: requestUrl)
 
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"file\"\r\n")
        body.appendString("Content-Type: image/jpg\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        request.httpMethod = "PUT"
        request.httpBody = body as Data
        
        if  let json =   String(data: request.httpBody!, encoding: String.Encoding.utf8){
            print("here")
            print(json)
        } else{
            print("no data 1")
        }
        // let multipartStr = String(decoding: requestData, as: UTF8.self) //to view the multipart form string
        URLSession.shared.dataTask(with: request) { (data, httpUrlResponse, error) in
            // handle the response here
            if  let json =   String(data: data!, encoding: String.Encoding.utf8){
                print(json)
            } else{
                print("no data")
            }
            print("upload response  data \(data)")
            print("upload response  error \(error)")
            print("upload response  http respo \(httpUrlResponse)")
            //This is for debuging on production remember to remove/comment this line 
            guard let data = data else {
                return
            }
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    print("The json of the data is  \(jsonArray)") // use the json here     
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            if let string = String(bytes: data, encoding: .utf8) {
                print("The string value of data is \(string)")
            } else {
                print("not a valid UTF-8 sequence")
            }
            print("The data from the post is \(data) ")
            
            if(error == nil && data != nil && data.count != 0)
            {
                // let dataStr = String(decoding: requestData, as: UTF8.self) //to view the data you receive from the API
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    print("upload response from here  \(response)")
                    _=completionHandler(response, nil)
                }
                catch let decodingError as NSError {
                    debugPrint(decodingError)
                    completionHandler(nil, decodingError)
                }
            }else{
                completionHandler(nil, error) 
            }
            
        }.resume()
        
    }
    
    func postMultipartForm<T:Decodable>(requestUrl: URL, data: Data, resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void)
    {
        
        var request = URLRequest(url: requestUrl)
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"file\"\r\n")
        body.appendString("Content-Type: image/jpg\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--".appending(boundary.appending("--")))
        request.httpMethod = "POST"
        request.httpBody = body as Data
        
        if  let json =   String(data: request.httpBody!, encoding: String.Encoding.utf8){
            print("here")
            print(json)
        } else{
            print("no data 1")
        }
        // let multipartStr = String(decoding: requestData, as: UTF8.self) //to view the multipart form string
        URLSession.shared.dataTask(with: request) { (data, httpUrlResponse, error) in
            // handle the response here
            if  let json =   String(data: data!, encoding: String.Encoding.utf8){
                print(json)
            } else{
                print("no data")
            }
            print("upload response  data \(data)")
            print("upload response  error \(error)")
            print("upload response  http respo \(httpUrlResponse)")
            //This is for debuging on production remember to remove/comment this line 
            guard let data = data else {
                return
            }
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    print("The json of the data is  \(jsonArray)") // use the json here     
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            if let string = String(bytes: data, encoding: .utf8) {
                print("The string value of data is \(string)")
            } else {
                print("not a valid UTF-8 sequence")
            }
            print("The data from the post is \(data) ")
            
            if(error == nil && data != nil && data.count != 0)
            {
                // let dataStr = String(decoding: requestData, as: UTF8.self) //to view the data you receive from the API
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    print("upload response from here  \(response)")
                    _=completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
            
        }.resume()
        
    }
    
    func newJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
    
    func newJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        }
        return encoder
    }
    
    func createBodyWithParametersForPost(parameters: Dictionary<String, Any>,boundary: String) -> NSData {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters {
                
                if (key as! String == "amount" || key as! String == "voteLimit"){
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendInt(value as? Int ?? 0)
                    body.appendString("\r\n")
                    print("The type of amount 2 is \(type(of: value))")

                    print("The value of int is s\(key) \(value)")
                }
                else if(value is String || value is NSString ){
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString("\(value)\r\n")
                    print("The value of string is s\(key) \(value)")

                } else if (value is Bool){
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendBool(value as? Bool ?? false)
                    body.appendString("\r\n")
                    print("The value of bool is s\(key) \(value)")

                } else if (value is Int || value is NSInteger ){
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendInt(value as? Int ?? 0)
                    body.appendString("\r\n")
                    print("The value of int is s\(key) \(value)")
                } else if (value is [String] || value is [NSString]){
                    for string in value as! [String]{
                        body.appendString("--\(boundary)\r\n")
                        body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                        body.appendString("\(string)\r\n") 
                        print("The value of [string] is s\(key) \(value)")

                    }
                }
                else if(value is [UIImage]){
                    var i = 0;
                    for image in value as! [UIImage]{
                        let filename = "image\(i).jpg"
                        let data = image.jpegData(compressionQuality: 0.3);
                        let mimetype = "image/jpg"
                        
                        body.appendString("--\(boundary)\r\n")
                        body.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(filename)\"\r\n")
                        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                        body.append(data!)
                        body.appendString("\r\n")
                        i += 1;
                        print("The value of [string] is s\(key) \(value)")

                    }                    
                }
                else if(value is UIImage){
                    var i = 0;
                    let filename = "\(key).jpg"
                    let image = value as! UIImage
                    let data = image.jpegData(compressionQuality: 0.3);
                    let mimetype = "image/jpg"
                    
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                    body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                    body.append(data!)
                    body.appendString("\r\n")
                    i += 1;
                    print("The value of [string] is s\(key) \(value)")                    
                }

            } 
        }
        body.appendString("--\(boundary)--\r\n")
        print("The body is givenas  \(body)")
        return body
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
        
    }
    
    func initPostRequestWithImages<ResponseType: Codable>(param : Dictionary<String, Any> , responseType: ResponseType.Type, requestUrl : URL, completion: @escaping ( ResponseType?, Error?) -> ()) -> URLSessionDataTask {
        
        let boundary = generateBoundaryString()
        
        var request = URLRequest(url: requestUrl)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = createBodyWithParametersForPost(parameters: param, boundary: boundary) as Data
        
        if  let json =   String(data: request.httpBody!, encoding: String.Encoding.utf8){
            print("here")
            print(json)
        } else{
            print("post text and data \(request.httpBody )")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            print("The post request to \(requestUrl) sent \(request.httpBody)")
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if  let json =   String(data: data, encoding: String.Encoding.utf8){
                print(json)
            }
            
            
            print("The data from the post is \(data) and response \(response)")
            //comment or remove to here
            let decoder = JSONDecoder()
            do {
                print("trying to decode data ...")
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    print("The decoder \(responseObject)")
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(WayaPayHttptResp<ResponseType>.self, from: data) as Error
                    DispatchQueue.main.async {
                        print("The decoder failed \(errorResponse)")
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("The decder failed again \(error)")
                        
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
        
    }
    
    func initPUTRequestWithImages<ResponseType: Codable>(param : Dictionary<String, Any> , responseType: ResponseType.Type, requestUrl : URL, completion: @escaping ( ResponseType?, Error?) -> ()) -> URLSessionDataTask {
        
        let boundary = generateBoundaryString()
        
        var request = URLRequest(url: requestUrl)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = createBodyWithParametersForPost(parameters: param, boundary: boundary) as Data
        
        if  let json =   String(data: request.httpBody!, encoding: String.Encoding.utf8){
            print("here")
            print(json)
        } else{
            print("post text and data \(request.httpBody )")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            
            print("The post request to \(requestUrl) sent \(request.httpBody)")
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            if  let json =   String(data: data, encoding: String.Encoding.utf8){
                print(json)
            }
            
            
            print("The data from the post is \(data) and response \(response)")
            //comment or remove to here
            let decoder = JSONDecoder()
            do {
                print("trying to decode data ...")
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    print("The decoder \(responseObject)")
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(WayaPayHttptResp<ResponseType>.self, from: data) as Error
                    DispatchQueue.main.async {
                        print("The decoder failed \(errorResponse)")
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("The decder failed again \(error)")
                        
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
        
    }

 
    
    func initPOSTRequestWithImage<RequestType : Encodable, ResponseType : Codable>(url: URL, data: Data, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> ())    {
        let token = UserDefaults.standard.string(forKey: "Token") ?? ""
        var request = URLRequest(url: url)

        
        let body2 = NSMutableData()
        let boundary = "Boundary-\(UUID().uuidString)"

        let boundaryPrefix = "--\(boundary)\r\n"
        
        body2.appendString(boundaryPrefix)
        body2.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"file\"\r\n")
        body2.appendString("Content-Type: image/jpg\r\n\r\n")
        body2.append(data)
        body2.appendString("\r\n")
        body2.appendString("--".appending(boundary.appending("--")))
        body2.append(try! JSONEncoder().encode(body))
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
 
        request.httpMethod = "POST"
        //request.httpBody = try! JSONEncoder().encode(body)
        request.httpBody = body2 as Data
       // request.addValue(token, forHTTPHeaderField: "authorization")
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if  let json =   String(data: request.httpBody!, encoding: String.Encoding.utf8){
            print("here")
            print(json)
        } else{
            print(request.httpBody)

            print("no data 1")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("The post request to \(url) sent \(request)")
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            //This is for debuging on production remember to remove/comment this line 
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    print("The json of the data is  \(jsonArray)") // use the json here     
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            print("The data from the post is \(data) and response \(response)")
            //comment or remove to here
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(WayaPayHttpResponse<ResponseType>.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }

}


extension URLSessionTask: NetworkCancellable { }
