//
//  WayagramRepositoryImpl.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/9/21.
//

import Foundation
import Alamofire

class WayagramRepositoryImpl {
    static let shared : WayagramRepository = WayagramRepositoryImpl()
    
    private init(){}
}

extension WayagramRepositoryImpl : WayagramRepository{
   
    
    func getPostById(postId: String, completion: @escaping Handler) {
        
//        guard let url: WayaClient = .getPostById(postId: postId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to  pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttptResp<PostResponse>.self) { (response, error) in
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
    
    func getPostByQuery(query: String, completion: @escaping Handler) {
//        guard let url = WayaClient.getPostByQuery(query: query).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<String>.self) { (response, error) in
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
    
    func getPostBySingleUser(profileId: String, completion: @escaping Handler) {
//        guard let url = WayaClient.getPostCreatedBySingleUser(profileId: profileId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to fetch post").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest2(url: url, responseType: WayaPayHttptResp<[PostResponse]>.self) { (response, error) in
//            print("post response \(response)")
//            print("post error \(error)")
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                   print("The post data is sent")
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
    
    func createPost(createPostRequest: CreatePostRequest, completion: @escaping Handler) {
        
        
//        guard let url = WayaClient.createPost.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResponse<CreatePostResponse>.self, body: createPostRequest) { (response, error) in
//
//            print("Authrepositoty : create account , response \(response)")
//            print("Authrepositoty : create account, response \(error)")
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "")))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//
//        }
    }
    
    func deletePost(deletePostRequest: DeletePostRequest, completion: @escaping Handler) {
//        guard let url = WayaClient.deletePost.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//        NetworkManager.instance.initDELETERequest(url: url, responseType: WayaPayHttpResponse<String>.self, body: deletePostRequest) { (response, error) in
//            print("PostRepo : delete post  , response \(response)")
//            print("PostRepo : delete post error, response \(error)")
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "")))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//
//
//        }
//
    }
    
    func getCommentById(commentId: String, completion: @escaping Handler) {
//        guard let url = WayaClient.getCommentById(commentId: commentId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttptResp<String>.self) { (response, error) in
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
    
  
    
    func getPostComment(postId: String, completion: @escaping Handler) {
//        guard let url = WayaClient.getPostComment(postId: postId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to get comments").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttptResp<[CommentResponse]>.self) { (response, error) in
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
    
    func getChildComment(commentId: String, completion: @escaping Handler) {
//        guard let url = WayaClient.getChildComments(commentId: commentId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<String>.self) { (response, error) in
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
    
    func createComment(createCommentRequest: CreateCommentRequest, completion: @escaping Handler) {
//        guard let url = WayaClient.createComment.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttptResp<String>.self, body: createCommentRequest) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.message))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "")))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//
//        }
//
    }
    
    func updateComment(updateCommentRequest: UpdateCommentRequest, completion: @escaping Handler) {
//        guard let url = WayaClient.updateComment.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
    }
    
    func deleteComment(commentId: String, completion: @escaping Handler) {
//        guard let url = WayaClient.deleteComment.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
    }
    
    func getUserMoments(completion: @escaping Handler){
//        let userId = UserDefaults.standard.string(forKey: "UserId") ?? ""
//        guard let url = WayaClient.getUserMoment(userId: userId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<[MomentResponse]>.self) { (response, error) in
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
    
    func createImageMoments(data: [UIImage], completion: @escaping Handler){
//        var request = NetworkRequest(endpoint: .createMoment, method: .post, encoding: .upload, body: [:])
//        request.images = data
//        request.body["profile_id"] = auth.data.profile!.profile!.id
//
//        Request.shared.push(request) { (status, _ response: Response<String>?) in
//            switch status {
//            case .success:
//                completion(.success(nil))
//            case .failed(let error):
//                completion(.failure(.custom(message: error.localizedDescription)))
//            }
//        }
    }
    
    func deleteMomentsById(momentId : String, completion: @escaping Handler){
//        guard let url = WayaClient.deleteMoment(id: momentId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//        NetworkManager.instance.initDELETE(url: url, responseType: WayaPayHttpResponse<String>.self) { (response, error) in
//            print("PostRepo : delete post  , response \(response)")
//            print("PostRepo : delete post error, response \(error)")
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "")))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//
//
//        }
    }
    
    func getAllMoments(completion: @escaping Handler){
       
//        let request = NetworkRequest(endpoint: .getAllMoments(page: "1", pageSize: "100"), method: .get, encoding: .urlJson, body: [:])
//        Request.shared.fetch(request) { (status, _ response: Response<[MomentResponse]>?) in
//            switch status {
//            case .success:
//                completion(.success(response?.data))
//            case .failed(let error):
//                completion(.failure(.custom(message: error.localizedDescription)))
//            }
//        }
    } 
    
    func getFeedForUser(completion: @escaping Handler){
//        guard let userId = auth.data.profile!.profile?.id else {
//            completion(.failure(.custom(message: "No wayagram profile found")))
//            return
//        }
//        let request = NetworkRequest(endpoint: .getFeedsForUser, method: .get, encoding: .json, body: ["profile_id" : userId])
//
//        Request.shared.fetch(request) { (status, _ response: Response<[PostResponse]>?) in
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message!)))
//                }
//            } else {
//                completion(.failure(.custom(message: status.localizedDescription)))
//            }
//        }
    } 
    
    func updatePost(createPostRequest: UpdatePostRequest,completion: @escaping Handler) {
//        guard let url = WayaClient.updatePost.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//
//        var params  : Dictionary<String, Any>  = [:]
//
//        params = ["profile_id" : createPostRequest.profile_id, //*
//                  "description" : createPostRequest.description, //*
//                  "group_id" : createPostRequest.group_id, // *
//                  "page_id" : createPostRequest.page_id, //*
//                  "type" : createPostRequest.type, //*
//                  "isPoll" : createPostRequest.isPoll, //*
//                  "isPaid" : createPostRequest.isPaid, //*
//                  "amount" : createPostRequest.amount,//*
//                  "expiresIn" : createPostRequest.expiresIn,
//                  "voteLimit" : createPostRequest.voteLimit,
//                  "forceTerms" : createPostRequest.forceTerms,
//                  "terms": createPostRequest.terms,
//                  "options": createPostRequest.options,
//                  "images" : createPostRequest.images, //*
//                  "post_id" : createPostRequest.post_id, // *
//                  "deletedHashtags" : createPostRequest.deletedHashtags, //*
//                  "addedHashtags" : createPostRequest.addedHashtags, //*
//                  "deletedMentions" : createPostRequest.deletedMentions, //*
//                  "addedMentions" : createPostRequest.addedMentions, //*
//                  "deletedFiles" : createPostRequest.deletedFiles
//        ]
//        print("The params for post are \(params)")
//
//        NetworkManager.instance.initPostRequestWithImages(param: params, responseType: WayaPayHttpResponse<CreatePostResponse>.self, requestUrl: url) { (response, error) in
//            print("Authrepositoty : create account , response \(response)")
//            print("Authrepositoty : create account, response \(error)")
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "")))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//
//        }
//
        
    }
    
    func createPostWithImages(createPostRequest: CreatePostRequestWithImage, completion: @escaping Handler) {
//        let params: [String : Any] = [
//            "profile_id" : createPostRequest.profile_id,
//            "parent_id" : createPostRequest.parent_id,
//            "description" : createPostRequest.description,
//            "group_id" : createPostRequest.group_id,
//            "page_id" : createPostRequest.page_id,
//            "type" : createPostRequest.type,
//            "isPoll" : createPostRequest.isPoll,
//            "isPaid" : createPostRequest.isPaid,
//            "amount" : createPostRequest.amount,
//            "expiresIn" : createPostRequest.expiresIn,
//            "voteLimit" : createPostRequest.voteLimit,
//            "forceTerms" : createPostRequest.forceTerms,
//            "terms": createPostRequest.terms,
//            "options": createPostRequest.options,
//        ]
//        var request = NetworkRequest(endpoint: .createPost, method: .post, encoding: .upload, body: params)
//        request.images = createPostRequest.images
//        Request.shared.push(request) { (status, _ response: Response<CreatePostResponse>?) in
//            switch status {
//            case .success:
//                guard let response = response else {
//                    completion(.success("Wayagram post created"))
//                    return
//                }
//
//                if response.status == true {
//                    completion(.success(response.message!))
//                } else {
//                    completion(.success(response.message!))
//                }
//            case .failed(let error):
//                completion(.failure(.custom(message: error.localizedDescription)))
//            }
//        }
    }
    
    func updateWayagramProfile(updateWayagramProfile: UpdateWayagramProfile, completion: @escaping Handler){
        
        let endpoint: WayaClient = .wayagram(.updateProfile)
        
        var request = NetworkRequest(endpoint: endpoint, method: .put, encoding: .upload, body: [:])
        request.body["user_id"] = updateWayagramProfile.user_id
        request.body["username"] = updateWayagramProfile.username
        request.body["displayName"] = updateWayagramProfile.displayName
        request.body["notPublic"] = updateWayagramProfile.notPublic
        if let avatar = updateWayagramProfile.avatar {
            request.files["avatar"] = avatar.jpegData(compressionQuality: 0.6)
        }
        
        if let coverImage = updateWayagramProfile.coverImage {
            request.files["coverImage"] = coverImage.jpegData(compressionQuality: 0.6)
        }
        Request.shared.push(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.success(nil))
                    return
                }
                if response.status == true {
                    completion(.success(response.message!))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }

    
    
    //GROUP
    func createGroup(createGroupRequest: CreateGroupRequest, completion: @escaping Handler){
//        guard let url = WayaClient.createGroup.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create group").message)))
//            return
//        }
    }
    
    func updateGroup(createGroupRequest: CreateGroupRequest, completion: @escaping Handler){
//        guard let url = WayaClient.updateGroup.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to update group").message)))
//            return
//        }
    }
    
    func getAllGroup(pageNumber: String, completion: @escaping Handler){
//        guard let url = WayaClient.getAllGroup(pageNumber: pageNumber).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to get all group").message)))
//            return
//        }
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<[GroupResponse]>.self) { (response, error) in
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
    
    func viewGroupInfo(groupId: String, completion: @escaping Handler){
//        guard let url = WayaClient.viewGroupInfo(groupId: groupId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to get all group").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<[GroupResponse]>.self) { (response, error) in
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
    
    func joinGroup(joinGroupRequest: GroupRequest ,completion: @escaping Handler){
//        guard let url = WayaClient.joinGroup.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to get all group").message)))
//            return
//        }
//
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResp<String>.self, body: joinGroupRequest) { (response, error) in
//
//            print("Authrepositoty : create account , response \(response)")
//            print("Authrepositoty : create account, response \(error)")
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.message))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "")))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//
//        }
    }
    
    func inviteOtherToGroup(inviteToGroupRequest: InviteToGroupRequest ,completion: @escaping Handler)
    {
//        guard let url = WayaClient.inviteOtherToGroup.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to get all group").message)))
//            return
//        }
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResp<String>.self, body: inviteToGroupRequest) { (response, error) in
//
//            print("Authrepositoty : create account , response \(response)")
//            print("Authrepositoty : create account, response \(error)")
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.message))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "")))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//
//        }
    }
    
    func responseToInvite(respondToInviteRequest: RespondToInviteRequest ,completion: @escaping Handler){
//        guard let url = WayaClient.respondToGroupInvite.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to get all group").message)))
//            return
//        }  
//        NetworkManager.instance.initPUTRequest(url: url, responseType: WayaPayHttpResponse<String>.self, body: respondToInviteRequest) { (response, error) in
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
    
    func seeAllGroupMembers(grouoId: String ,completion: @escaping Handler){
//        guard let url = WayaClient.seeAllMembersInGroup(groupId: grouoId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to get all group").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<String>.self) { (response, error) in
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
    
    func muteGroupFromUserEnd(groupRequest: GroupRequest ,completion: @escaping Handler){
//        guard let url = WayaClient.muteGroupForUser.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to get all group").message)))
//            return
//        }
//
//        NetworkManager.instance.initPUTRequest(url: url, responseType: WayaPayHttpResponse<String>.self, body: groupRequest) { (response, error) in
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
    
    func reportMember(reportMemberRequest: ReportMemberRequest ,completion: @escaping Handler)
    {
//        guard let url = WayaClient.reportGroup.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResponse<CreatePostResponse>.self, body: reportMemberRequest) { (response, error) in
//
//            print("Authrepositoty : create account , response \(response)")
//            print("Authrepositoty : create account, response \(error)")
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "")))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//
//        }
    }
    
    func leaveGroupAndDelete(groupRequest: GroupRequest ,completion: @escaping Handler){
//        guard let url = WayaClient.leaveGroupAndDelete.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initPUTRequest(url: url, responseType: WayaPayHttpResponse<String>.self, body: groupRequest) { (response, error) in
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
    
    func createPage(createPageRequest: CreatePageRequest, completion: @escaping Handler) {
        
    }
    
    func getAllUserPage(userId: String, completion: @escaping Handler) {
//        guard let url = WayaClient.getAllUserPage(userId: userId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<[PageResponse]>.self) { (response, error) in
//            print("The response for get pages \(response)")
//            print("The error for get pages \(error)")
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "")))
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
    
    func getAllUserPageById(userId: String, pageId: String, completion: @escaping Handler) {
        
    }
    
    func updatePage(createPageRequest: CreatePageRequest, completion: @escaping Handler) {
        
    }
    
    func getAllPage(isPublic: String, pageNumber: String, completion: @escaping Handler) {
        
    }
    
    func sendAdminInvite(inviteToPageRequest: InviteToPageRequest, completion: @escaping Handler) {
        
    }
    
    func getAllAdminInvite(userId: String, completion: @escaping Handler) {
        
    }
    
    func reportAdminInvite(respondToAdminInvite: RespondToAdminInvite, completion: @escaping Handler) {
        
    }
    
    func adminDeletepage(adminDeletePageReuest: AdminDeletePageReuest, completion: @escaping Handler) {
        
    }
    
    func followPage(followPageRequest: FollowPageRequest, completion: @escaping Handler) {
        
    }
    
    func unFollowPage(followPageRequest: FollowPageRequest, completion: @escaping Handler) {
        
    }
    
    func inviteToPage(inviteToPageRequest: InviteToPageRequest, completion: @escaping Handler) {
        
    }
    
    func respondToFriendPageInvite(respondToFriendPageInvite: RespondToFriendPageInvite, completion: @escaping Handler) {
        
    }
    
    func getAllPageFollowers(userId: String, pageId: String, completion: @escaping Handler) {
        
    }
    
    func reportPage(pageReportRequest: PageReportRequest, completion: @escaping Handler) {
        
    }
    
    func getAllPageReport(userId: String, pageId: String, completion: @escaping Handler) {
        
    }
    
    func getWayagramProfileByUserId(userId: String, completion: @escaping Handler){
        let userId = String(auth.data.userId!)
        let endpoint = WayaClient.wayagram(.getProfileByUserId(userId: userId))
        let request = NetworkRequest(endpoint: endpoint, method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<WayagramProfile>?) in
            switch status {
            case .success:
                print("profile response: \(response)")
                guard let profile = response?.data else {
                    completion(.failure(.custom(message: "no profile found")))
                    return
                }
                completion(.success(profile))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func likePost(likePostRequest: LikePostRequest, completion: @escaping Handler){
//        guard let url = WayaClient.likePost.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttptResp<String>.self, body: likePostRequest) { (response, error) in
//
//            print("Like : post response success \(response)")
//            print("Like : post response error \(error)")
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.status))
//                } else {
//                    completion(.failure(.custom(message: response.message ?? "")))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//
//        }
    }
    
    func getWayagramProfileByUsername(username : String, completion: @escaping Handler)
    {
//        guard let url = WayaClient.getWayagramProfileByUsername(username: username).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttptResp<WayagramProfileResponse>.self) { (response, error) in
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

    func getWayagramProfileByQuery(query : String, profileId : String,completion: @escaping Handler){
//        guard let url = WayaClient.getWayagramProfileByQuery(query: query, profileId: profileId).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to create pin").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttptResp<[WayagramProfileResponse]>.self) { (response, error) in
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
    
    func getUserNewInterests(profileId: String, completion: @escaping Handler) {
        let endpoint = WayaClient.wayagram(.getNewInterests(profileId))
        
        let request = NetworkRequest(endpoint: endpoint, method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<[UserInterest]>?) in
            switch status {
            case .success:
                guard let response = response, let interests = response.data else {
                    completion(.failure(.custom(message: "Could not fetch interests")))
                    return
                }
                completion(.success(interests))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func saveUserInterest(interest: String, callback: @escaping Handler) {
        let endpoint = WayaClient.wayagram(.saveUserInterest)
        let userId = auth.data.wayagramProfile!.id
        var request = NetworkRequest(endpoint: endpoint, method: .post, encoding: .upload, body: ["profileId" : userId, "interestId" : interest])
        
        Request.shared.push(request) { (status, _ response: Response<UserInterest>?) in
            switch status {
            case .success:
                guard let response = response else {
                    callback(.failure(.custom(message: "no response received")))
                    return
                }
                if response.status == true  {
                    callback(.success(response.message!))
                } else {
                    callback(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                callback(.failure(.custom(message: error.localizedDescription)))
            }
        }
        
    }
    
    func getSuggestedFollows(completion: @escaping Handler) {
        let userId = String(auth.data.userId!)
        let endpoint: WayaClient = .wayagram(.getFriendSuggestions(userId: userId))
        let request = NetworkRequest(endpoint: endpoint, method: .get, encoding: .urlJson, body: [:])
        
        Request.shared.fetch(request) { (status, _ response: SuggestFriendResponse<[SuggestFriendProfiles]>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.success(nil))
                    return
                }
                if response.status == true {
                    completion(.success(response.Profiles))
                } else {
                    completion(.failure(.custom(message: response.message)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func followUser(username: String, follow: Bool, completion: @escaping Handler) {
        let endpoint: WayaClient = (follow == true) ? .wayagram(.followUser) : .wayagram(.unfollowUser)
        let request = NetworkRequest(endpoint: endpoint, method: .post, encoding: .json, body: ["user_id" : String(auth.data.userId!), "username" : username])
        
        Request.shared.fetch(request) { (status, _ response: FollowUserResponse?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.success(nil))
                    return
                }
                if response.status == true {
                    completion(.success(response.message))
                } else {
                    completion(.failure(.custom(message: response.message)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func autoFollowWaya() {
        let request = NetworkRequest(endpoint: .wayagram(.wayaAutoFollow), method: .post, encoding: .json, body: ["user_id" : String(auth.data.userId!)])
//        Request.shared.fetch(request) { (status, _ response: FollowUserResponse?) in
//            return
//        }
    }
}
