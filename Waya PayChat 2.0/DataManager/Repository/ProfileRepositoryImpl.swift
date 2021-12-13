//
//  ProfileRepositoryImpl.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/2/21.
//

import Foundation

class ProfileRepositoryImpl: ProfileRepository {
    var userId: String? {
        guard let data = auth.data else {
            return nil
        }
        
        return String(data.userId!)
    }
  
    func updateUserProfile(userid: String, updateUserProfileRequest: Dictionary<String, Any>, completion: @escaping Handler) {
       
        let request = NetworkRequest(
            endpoint: .auth(.updateUserProfile(userId: userid, type: auth.data.profile!.accountType)),
            method: .put,
            encoding: .json,
            body: updateUserProfileRequest
        )
        
        Request.shared.fetch(request) { (status, _ response: Response<UserProfile>?) in
            switch status {
            case .success:
                if let response = response {
                    if response.status == true{
                        completion(.success(response.message))
                    } else {
                        completion(.failure(.custom(message: response.message!)))
                    }
                } else {
                    completion(.success("Updated successfully"))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getUserProfile(userId: String, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .auth(.getUserPersonalProfile(userId: userId)), method: .get, encoding: .urlJson, body: [:])
        
        Request.shared.fetch(request) { (status, _ response: Response<UserProfile>?) in
            switch status {
            case .success:
                if let response = response {
                    if response.status == true{
                        completion(.success(response.data!))
                    } else {
                        completion(.failure(.custom(message: response.message!)))
                    }
                } else {
                    completion(.success(nil))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getOtherDetailsForCorporate(id: String, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .profile(.getProfile(id: id)), method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<ProfileResponse>?) in
            switch status {
            case .success:
                guard let details = response?.data else {
                    completion(.failure(.custom(message: "could not fetch profile details")))
                    return
                }
                completion(.success(details))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func searchUserByEmail(email: String, completion: @escaping Handler) {
//        guard let url: WayaClient = .searchProfileByEmail(email: email).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to update profile").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<UserProfile>.self) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//        }
    }
    
    func searchUserByPhone(phoneNumber: String, completion: @escaping Handler) {
//        guard let url = WayaClient.searchProfileByPhoneNumber(phoneNumber: phoneNumber).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to update profile").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<UserProfile>.self) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//        }
    }
    
    func searchUserByName(name: String, completion: @escaping Handler) {
//        guard let url = WayaClient.searchProfileByName(name: name).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to update profile").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<UserProfile>.self) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//        }
        
    }

    func uploadProfileImage(data: Data, completion: @escaping Handler) {
        var request = NetworkRequest(endpoint: .profile(.updatePersonalProfileImage(profileId: userId!)), method: .post, encoding: .upload, body: [:])
        request.files = ["file" : data]
            
        Request.shared.push(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.success(nil))
                    return
                }
                if response.status == true {
                    completion(.success(response.message!))
                } else { return completion(.failure(.custom(message: response.message!)))}
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getFriends(page : Int, completion: @escaping Handler){
//        let userId = UserDefaults.standard.string(forKey: "UserId") ?? ""
//        guard let url = WayaClient.getFriends(userId: userId, page: page).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to update profile").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<UserProfile>.self) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//        }
        
    }
    func getFriendSuggestions(completion: @escaping Handler){
//        let userId = UserDefaults.standard.string(forKey: "UserId") ?? ""
//        guard let url = WayaClient.getFriendSuggestion(userId: userId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to update profile").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<String>.self) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//        }
    }
    func getAllFriendsRequest(page: Int, completion: @escaping Handler){
//        let userId = UserDefaults.standard.string(forKey: "UserId") ?? ""
//        guard let url = WayaClient.getFriendRequests(userId: userId, page: page).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to update profile").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<String>.self) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//        }
    }
    func followUsers(followRequest: FollowUserRequest, completion: @escaping Handler){
//        guard let url = WayaClient.followUser.url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResp<String>.self, body: followRequest) { (response, error) in
//
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "Error Fetching")))
//                }
//            } else {
//                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//            }
//
//        }
    }
    func unFollowUsers(followRequest: FollowUserRequest, completion: @escaping Handler){
//        guard let url = WayaClient.unFollowUser.url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResp<String>.self, body: followRequest) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "Error Fetching")))
//                }
//            } else {
//                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//            }
//
//        }
    }
    
    func blockUser(followRequest: FollowUserRequest, completion: @escaping Handler){
//        guard let url = WayaClient.blockUser.url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResp<String>.self, body: followRequest) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "Error Fetching")))
//                }
//            } else {
//                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//            }
//
//        }
    }
    func unBlockUser(followRequest: FollowUserRequest, completion: @escaping Handler){
//        guard let url = WayaClient.unblockUser.url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResp<String>.self, body: followRequest) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "Error Fetching")))
//                }
//            } else {
//                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//            }
//
//        }
    }
    func acceptRequest(followRequest: FollowUserRequest, completion: @escaping Handler){
//        guard let url = WayaClient.acceptFriendRequest.url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResp<String>.self, body: followRequest) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "Error Fetching")))
//                }
//            } else {
//                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//            }
//
//        }
    }
    func declineRequest(followRequest: FollowUserRequest, completion: @escaping Handler){
//        guard let url = WayaClient.declineFriendrequest.url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResp<String>.self, body: followRequest) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "Error Fetching")))
//                }
//            } else {
//                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//            }
//
//        }
    }
    
    func getReferralCode(completion: @escaping Handler){
//        guard let url = WayaClient.getReferralCode(userId: userId).url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttptResp<ReferralCodeResponse>.self) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//        }
    }

    func getFollowers(pageNumber : Int, completion: @escaping Handler){
//        guard let url = WayaClient.getUserFollower(userId: userId, page: pageNumber).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to  pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttptResp<FollowResponse>.self) { (response, error) in
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//        }
    }
    
    func getFollowing(pageNumber : Int, completion: @escaping Handler){
//        guard let url = WayaClient.getUserFollowing(userId: userId, page: pageNumber).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to  pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttptResp<FollowResponse>.self) { (response, error) in
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//        }
    }
    
    func getFriends(pageNumber : Int, completion: @escaping Handler){
//        guard let url = WayaClient.getFriends(userId: userId, page: pageNumber).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to  pin").message)))
//            return
//        }
//        
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttptResp<FollowResponse>.self) { (response, error) in
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }      
//            }
//        }
    }

    
}
