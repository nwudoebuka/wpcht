//
//  WayagramViewModelImpl.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/9/21.
//

import Foundation


final class WayagramViewModelImpl {
    
    var createPostRequest = CreatePostRequest(profile_id: "")
     var posts = [Post]()
     var userPostResponse = [PostResponse]()
     var deletePostRequest = DeletePostRequest(post_id: "")
     var userMomentResponse = [MomentResponse]()
     var allMoments = [MomentResponse]()
     var hasAddedMoment = false
     var momentBackGroundImage  =  UIImage()
     var textMoment = CreateTextMoment(content: "")
     var createPostRequestWithImages = CreatePostRequestWithImage(profile_id: "")
     var userFeedResponse = [PostResponse]()
     var selectedPost  = SelectedPost()
     var groups = [GroupResponse]()
     var userPages = [PageResponse]()
    var wayagramProfileResp: WayagramProfileResponse?
    
    var wayagramSearchedUserProfile : Observable<WayagramProfileResponse?> = Observable(nil)
    var wayagramSearchedUserProfiles : Observable<[WayagramProfileResponse]?> = Observable([])


    var latestMoment =  MomentResponse(id: "", UserId: "", type: "", content: "", isActive: false, updatedAt: "", createdAt: "", userAvatar: "", userName: "")

    var wayagramRepo: WayagramRepository
//    let userId  = String(auth.data.profile?.id ?? 00)//UserDefaults.standard.string(forKey: "UserId") ?? ""
    let wayagramUserId  = UserDefaults.standard.string(forKey: "ProfileId") ?? ""
    
    var saveObserverToken: Any?
    
    /// A closure that is run when the user asks to delete the current note
    var onDelete: (() -> Void)?
    
    init(wayagramRepository: WayagramRepository = WayagramRepositoryImpl.shared){
        self.wayagramRepo = wayagramRepository
    }
    
}

extension WayagramViewModelImpl: WayagramViewModel{
   
    func getCommentById(commentId: String, completion: @escaping Handler) {
        wayagramRepo.getCommentById(commentId: commentId) { (result) in
            switch result{
                case .success(let response):
                    print(response)
                case .failure(.custom(let message)):
                    print(message)
            }
        }
    }
    
    func getPostComment(postId: String, completion: @escaping Handler) {
        wayagramRepo.getPostComment(postId: postId) {[weak self] (result) in
            switch result{
                case .success(let response):
                    if let _postResponse = response as? [PostResponse]{
                        self?.userPostResponse = _postResponse
                        print("The viem response is \(self?.userPostResponse)")
                        completion(.success(self?.userPostResponse))
                    }else{
                        print("The viem response is \(response)")
                        completion(.success(response))
                    }
                case .failure(.custom(let message)):
                    print(message)
            }
        }
    }
    
    func getChildComment(commentId: String, completion: @escaping Handler) {
        wayagramRepo.getChildComment(commentId: commentId) { (result) in
            switch result{
                case .success(let response):
                    print(response)
                case .failure(.custom(let message)):
                    print(message)
            }
        }
    }
    
    func createComment(createCommentRequest: CreateCommentRequest, completion: @escaping Handler) {
        wayagramRepo.createComment(createCommentRequest: createCommentRequest) { (result) in
            switch result{
                case .success(let response):
                    print(response)
                case .failure(.custom(let message)):
                    print(message)
            }
        }
    }
    
    func updateComment(updateCommentRequest: UpdateCommentRequest, completion: @escaping Handler) {
        wayagramRepo.updateComment(updateCommentRequest: updateCommentRequest) { (result) in
            switch result{
                case .success(let response):
                    print(response)
                case .failure(.custom(let message)):
                    print(message)
            }
        }
    }
    
    func deleteComment(commentId: String, completion: @escaping Handler) {
        wayagramRepo.deleteComment(commentId: commentId) { (result) in
            switch result{
                case .success(let response):
                    print(response)
                case .failure(.custom(let message)):
                    print(message)
            }
        }
    }
    
    func getPostById(postId: String, completion: @escaping Handler) {
        wayagramRepo.getPostById(postId: postId) { (result) in
            switch result{
                case .success(let response):
                    print(response)
                    completion(.success(response))
                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message: message)))
            }   
        }
    }
    
    func getPostByQuery(query: String, completion: @escaping Handler) {
        wayagramRepo.getPostByQuery(query: query) { (result) in
            switch result{
                case .success(let response):
                    completion(.success(response))
                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message: message)))

            }
        }
    }
    
    func getPostBySingleUser(profileId: String, completion: @escaping Handler) {
        wayagramRepo.getPostBySingleUser(profileId: profileId) {[weak self] (result) in
            switch result{
                case .success(let response):
                    if let _postResponse = response as? [PostResponse]{
                        self?.userPostResponse = _postResponse
                        print("The viem response is \(self?.userPostResponse)")
                        let imageGroup = DispatchGroup()
                        if _postResponse.count > 0{
                            for i in 0..._postResponse.count - 1{
                                imageGroup.enter()
                                
                                if self?.userPostResponse[i].profile.user.profileImage != "" || self?.userPostResponse[i].profile.user.profileImage != nil{
                                    ImageLoader.loadImageData(urlString: (self?.userPostResponse[i].profile.user.profileImage!)!){
                                        (result) in
                                        self?.userPostResponse[i].uiImage = result 
                                        if let count = _postResponse[i].images?.count, count > 0{
                                            ImageLoader.loadImageData(urlString:  _postResponse[i].images![0].imageURL){ (result) in
                                                self?.userPostResponse[i].postImages?.append(result ?? UIImage(named: "advert-wallet")!)
                                                imageGroup.leave()
                                            }
                                        } else {
                                            imageGroup.leave()
                                            return
                                        }
                            
                                    }
                                }   else{
                                    guard let imageURL = _postResponse[i].images?[0].imageURL else {
                                        imageGroup.leave()
                                        return
                                    }
                                    ImageLoader.loadImageData(urlString: imageURL){ (result) in
                                        self?.userPostResponse[i].postImages?.append(result ?? UIImage(named: "advert-wallet")!)
                                        imageGroup.leave()
                                    }
                                }
                            }
                        }
                        imageGroup.notify(queue: .main){
                            completion(.success(response))
                        }
                        completion(.success(self?.userPostResponse))
                    } //else{
//                        print("The viem response is \(response)")
//                        completion(.success(response))
//                    }
                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message: message)))
            }
        }
    }
    
    func createPost(createPostRequest: CreatePostRequest, completion: @escaping Handler) {
        wayagramRepo.createPost(createPostRequest: createPostRequest) { (result) in
            switch result{
                case .success(let response):
                    print(response)
                    completion(.success(response))
                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message: message)))

            }
        }
    }
    
    func createPostWithImages(createPostRequest: CreatePostRequestWithImage, completion: @escaping Handler) {
        wayagramRepo.createPostWithImages(createPostRequest: createPostRequest) { (result) in
            switch result{
                case .success(let response):
                    print(response)
                    completion(.success(response))
                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message: message)))
                    
            }
        }
    }
    
    func updatePost(createPostRequest: UpdatePostRequest,completion: @escaping Handler) {
        wayagramRepo.updatePost(createPostRequest: createPostRequest) { (result) in
            switch result{
                case .success(let response):
                    print(response)
                case .failure(.custom(let message)):
                    print(message)
            }       
        }
    }
    
    func deletePost(deletePostRequest: DeletePostRequest, completion: @escaping Handler)  {
        wayagramRepo.deletePost(deletePostRequest: deletePostRequest) { [weak self](result) in
            switch result{
                case .success(let response):
                    print(response)
                    completion(.success(response))
                    
//                    self?.userFeedResponse.removeAll{
//                        $0.id  == deletePostRequest.post_id
//                    }
                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message:message)))

            }
        }
    }
    
    func getUserMoments(completion: @escaping Handler){
        wayagramRepo.getUserMoments { [weak self](result) in
            switch result{
                case .success(let response):
                    if let response_ = response as? [MomentResponse]{
                        self?.userMomentResponse = response_.reversed()
                        print("decoded successfully")
                        if self?.userMomentResponse.count ?? 0 > 0{
                            self?.latestMoment = (self?.userMomentResponse[0])!
                            
                            guard let url = URL(string: self?.userMomentResponse[0].content ?? "") else {
                                completion(.success(response))
                                return
                            }
                            print("decoded successfully \(self?.hasAddedMoment)")
                            
                            
                            DispatchQueue.global().async { 
                                if let data = try? Data(contentsOf: url) {
                                    if let image = UIImage(data: data) {
                                        DispatchQueue.main.async {
                                            self?.momentBackGroundImage = image
                                            print("changed image successfully")
                                            self?.hasAddedMoment = true
                                            print(self?.hasAddedMoment)
                                            completion(.success(response))

                                        }
                                    }
                                }
                            }
                            
                        }
                    }   else{
                        completion(.success(response))

                    }                
                    
                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message:message)))
               
            }
        }
    }
    
    func createImageMoments(data: [UIImage], completion: @escaping Handler){
        wayagramRepo.createImageMoments(data: data) { (result) in
            switch result {
            case .success:
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func deleteMomentsById(momentId : String, completion: @escaping Handler){
        wayagramRepo.deleteMomentsById(momentId: momentId) { (result) in
            switch result{
                case .success(let response):
                    print(response)
                    completion(.success(response))
                    
                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message:message)))
                    
            }
        }
    }
    
    func getAllMoments(completion: @escaping Handler){
        wayagramRepo.getAllMoments {[weak self] (result) in
            switch result{
                case .success(let response):
                    print("The moment \(response)")
                    if let moments_ = response as? [MomentResponse]{
                        let imageGroup = DispatchGroup()
                        if moments_.count > 0{
                            self?.allMoments = moments_
                            for i in 0...moments_.count - 1{
                                imageGroup.enter()
                                
                                if moments_[i].content != "" && moments_[i].type == "image"{
                                    ImageLoader.loadImageData(urlString: moments_[i].content){
                                        (result) in
                                        self?.allMoments[i].userMomentIamge = result 
                                        ImageLoader.loadImageData(urlString: moments_[i].userAvatar) { (result) in
                                            self?.allMoments[i].userAvatarImage = result
                                            imageGroup.leave()
                                        }
                                    }
                                } 
                                else{
                                    ImageLoader.loadImageData(urlString: moments_[i].userAvatar) { (result) in
                                        self?.allMoments[i].userAvatarImage = result
                                        imageGroup.leave()
                                    }
                                }
                            }
                        }
                        imageGroup.notify(queue: .main){
                            completion(.success(response))
                        }
                    }
                    
                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message:message)))
                    
            }
        }
    }
    
    func getFeedForUser(completion: @escaping Handler){
        wayagramRepo.getFeedForUser{ [weak self](result) in
            switch result{
                case .success(let response):
                    if let userFeedResponse_ = response as? [PostResponse]{
                        self?.userFeedResponse = userFeedResponse_.reversed()
                        
                        if userFeedResponse_.count > 0{
                            let imageGroup = DispatchGroup()
                            for i in 0...userFeedResponse_.count - 1{
                                imageGroup.enter()
                                if userFeedResponse_[i].profile.user.profileImage != nil ||  userFeedResponse_[i].profile.user.profileImage != ""{
                                    guard let url = URL(string: userFeedResponse_[i].profile.user.profileImage!) else { return }
                                    let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                                        guard let data = data else { return }
                                        DispatchQueue.main.async {
                                            self?.userFeedResponse[i] = userFeedResponse_[i]
                                            let image = UIImage(data: data) ?? UIImage(named: "profile-placeholder")
                                            self?.userFeedResponse[i].uiImage = image
                                            if let images = userFeedResponse_[i].images, let count = userFeedResponse_[i].images?.count, count > 0{
                                                    guard let url = URL(string: images[0].imageURL) else { return }
                                                    let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                                                        guard let data = data else { return }
                                                        DispatchQueue.main.async {
                                                            print("The image is fetching in wayagram viewmodel ")
                                                            let image = UIImage(data: data) ?? UIImage(named: "advert-wallet")
                                                            if let image_ = image{
                                                                self?.userFeedResponse[i].postImages?.append(image_)
                                                            }
                                                            
                                                            do{
                                                                print("The image2 is done fetching in wayagram viewmodel ")
                                                                
                                                                imageGroup.leave()
                                                            }
                                                        }
                                                    }.resume()
                                            }
                                            else{
                                                imageGroup.leave() 
                                            }
                                        }
                                    }.resume()
                                    
                                
                               
                                }
                                else{
                                    self?.userFeedResponse[i] = userFeedResponse_[i]
                                    imageGroup.leave()
                                }
                            }
                            imageGroup.notify(queue: .main){
                                completion(.success(response))
                            }
                        }
                        else{
                            completion(.success(response))
                        }
                    }   else{
                        completion(.success(response))
                    }                 

                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message:message)))
                    
            }
        }
    }
    
    func reloadUserFeeds(){
        //to do reload Feeds for user 
        wayagramRepo.getFeedForUser{ [weak self](result) in
            switch result{
                case .success(let response):
                    print("The get feed for user response is \(response)")
                    
                    if let userFeedResponse_ = response as? [PostResponse]{
                        print("The get feed for user response is \(userFeedResponse_)")
                        if userFeedResponse_.count > 0{
                            let imageGroup = DispatchGroup()
                            for i in 0...userFeedResponse_.count - 1{
                                let uiImage = UIImage()
                                self?.userFeedResponse[i] = userFeedResponse_[i]
                                if userFeedResponse_[i].profile.user.profileImage != nil || userFeedResponse_[i].profile.user.profileImage != ""{
                                    guard let url = URL(string: userFeedResponse_[i].profile.user.profileImage!) else { return }

                                    let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                                        guard let data = data else { return }
                                        DispatchQueue.main.async {
                                            print("The image sis fetching in wayagram viewmodel ")
                                            let image = UIImage(data: data) ?? UIImage(named: "profile-placeholder")
                                            self?.userFeedResponse[i].uiImage = image
                                        }
                                    }
//                                    uiImage.loadImageData(urlString: userFeedResponse_[i].profile.user.profileImage!, { (uiImage) in
//                                        self?.userFeedResponse[i].uiImage = uiImage
//                                    })
                                    do{
                                        print("The image is done fetching in wayagram viewmodel ")

                                        imageGroup.leave()
                                    }
                                } else{
                                    imageGroup.leave() 
                                }
                              
                            }
                            imageGroup.notify(queue: .main){
                                self?.userFeedResponse = userFeedResponse_.reversed()
                                
                                print("The 22 get feed for user response is \(self?.userFeedResponse)")

                            }
                        }
                    }                    
                case .failure(.custom(let message)):
                    print(message)
                    
            }
        }
    }
    
    func createGroup(createGroupRequest: CreateGroupRequest, completion: @escaping Handler){}
    
    func updateGroup(createGroupRequest: CreateGroupRequest, completion: @escaping Handler){}
    
    func getAllGroup(pageNumber: String, completion: @escaping Handler){
        wayagramRepo.getAllGroup(pageNumber: pageNumber) {[weak self](result) in
            switch result{
                case .success(let response):
                    print("The get feed for user response is \(response)")
                    
                    if let groups_ = response as? [GroupResponse]{
                        print("The get group for user response is \(groups_)")
                        self?.groups = groups_
                    }                    
                    completion(.success(response))

                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message:message)))

                    
            }
        }
    }
    
    func viewGroupInfo(groupId: String, completion: @escaping Handler){}
    
    func joinGroup(joinGroupRequest: GroupRequest ,completion: @escaping Handler){}
    
    func inviteOtherToGroup(inviteToGroupRequest: InviteToGroupRequest ,completion: @escaping Handler){}
    
    func responseToInvite(respondToInviteRequest: RespondToInviteRequest ,completion: @escaping Handler){}
    
    func seeAllGroupMembers(grouoId: String ,completion: @escaping Handler){}
    
    func muteGroupFromUserEnd(groupRequest: GroupRequest ,completion: @escaping Handler){}
    
    func reportMember(reportMemberRequest: ReportMemberRequest ,completion: @escaping Handler){}
    
    func leaveGroupAndDelete(groupRequest: GroupRequest ,completion: @escaping Handler){}
    
    func createPage(createPageRequest: CreatePageRequest, completion: @escaping Handler){}
    
    func getAllUserPage( completion: @escaping Handler){
        wayagramRepo.getAllUserPage(userId: wayagramUserId) { [weak self](result) in
            switch result{
                case .success(let response):
                    print("The get user page response is \(response)")
                    
                    if let userPages_ = response as? [PageResponse]{
                        self?.userPages = userPages_
                    }                    
                    completion(.success(response))
                case .failure(.custom(let message)):
                    print(message)
                    completion(.failure(.custom(message:message)))

            }
        }
    }
    func getAllUserPageById( pageId : String,  completion: @escaping Handler){
        
    }
    
    func updatePage(createPageRequest: CreatePageRequest, completion: @escaping Handler){}
    
    func getAllPage(isPublic : String, pageNumber : String, completion: @escaping Handler){
        
    }
    
    func sendAdminInvite( inviteToPageRequest: InviteToPageRequest,  completion: @escaping Handler){}
    
    func getAllAdminInvite( completion: @escaping Handler){}
    
    func reportAdminInvite(respondToAdminInvite: RespondToAdminInvite,completion: @escaping Handler){}
    
    func adminDeletepage(adminDeletePageReuest :AdminDeletePageReuest, completion: @escaping Handler){}
    
    func followPage(followPageRequest :FollowPageRequest, completion: @escaping Handler){}
    
    func unFollowPage(followPageRequest :FollowPageRequest, completion: @escaping Handler){}  
    
    func inviteToPage(inviteToPageRequest :InviteToPageRequest, completion: @escaping Handler){}
    
    
    func respondToFriendPageInvite(respondToFriendPageInvite :RespondToFriendPageInvite, completion: @escaping Handler){}
    
    func getAllPageFollowers( pageId: String, completion: @escaping Handler){}
    
    func reportPage( pageReportRequest: PageReportRequest,completion: @escaping Handler){}
    
    func getAllPageReport( pageId: String, completion: @escaping Handler){}
    
    func getWayagramProfileByUserId(userId: String, completion: @escaping Handler){
        wayagramRepo.getWayagramProfileByUserId(userId: userId) { (result) in
            switch result {
            case .success(let profile):
                guard let profile = profile as? WayagramProfile else {
                    completion(.failure(.custom(message: "Profile is invalid")))
                    return
                }
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }

    func likePost(likePostRequest: LikePostRequest, completion: @escaping(_ success: Bool) -> ()){
        wayagramRepo.likePost(likePostRequest: likePostRequest) { (result) in
            switch result{
                case .success( _):
                    completion(true)
                case .failure(.custom( _)):    
                    completion(false)
                    
            }
        }
    }

    func updateWayagramProfile( updateWayagramProfile: UpdateWayagramProfile, completion: @escaping Handler){
        wayagramRepo.updateWayagramProfile(updateWayagramProfile: updateWayagramProfile) { (result) in
            switch result{
                case .success( let response):
                    completion(.success(response))
                case .failure(.custom( let message)):    
                    completion(.failure(.custom(message: message)))
                    
            }
        }
    }
    
    func getWayagramProfileByUsername(username : String, completion: @escaping Handler){
        wayagramRepo.getWayagramProfileByUsername(username: username) { (result) in
            switch result{
                case .success( let response):
                    completion(.success(response))
                case .failure(.custom( let message)):    
                    completion(.failure(.custom(message: message)))
                    
            }
        }
    }

    func getWayagramProfileByQuery(query : String, profileId : String,completion: @escaping Handler){
        wayagramRepo.getWayagramProfileByQuery(query: query, profileId: profileId){ (result) in
            switch result{
                case .success( let response):
                    completion(.success(response))
                case .failure(.custom( let message)):    
                    completion(.failure(.custom(message: message)))
                    
            }
        }
    }
    
    func getUserNewInterests(profileId: String, completion: @escaping Handler) {
        wayagramRepo.getUserNewInterests(profileId: profileId) { (result) in
            switch result {
            case .success(let interests):
                completion(.success(interests))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func saveUserInterests(interest: String, callback: @escaping Handler) {
        wayagramRepo.saveUserInterest(interest: interest, callback: { (result) in
            switch result {
            case .success(let message):
                callback(.success(message))
            case .failure(let error):
                callback(.failure(.custom(message: error.localizedDescription)))
            }
        })
    }
    
//    func saveUsername(username: String, completion: @escaping Handler) {
//        wayagramRepo.saveUsername(username: username) { (result) in
//            switch result {
//            case .success(_):
//                completion(.success(nil))
//            case .failure(let error):
//                completion(.failure(.custom(message: error.localizedDescription)))
//            }
//        }
//    }
    
    func getSuggestedFollows(completion: @escaping Handler) {
        wayagramRepo.getSuggestedFollows { (result) in
            switch result {
            case .success(let profiles):
                completion(.success(profiles))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    
    func followUser(username: String, follow: Bool, completion: @escaping Handler) {
        wayagramRepo.followUser(username: username, follow: follow) { (result) in
            switch result {
            case .success(let profiles):
                completion(.success(profiles))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func followWaya() {
        wayagramRepo.autoFollowWaya()
    }
}



