//
//  WayagramViewModel.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/9/21.
//

import Foundation


protocol WayagramViewModel {
    
    func getCommentById(commentId : String, completion: @escaping Handler)
    
    //all comments under post
    func getPostComment(postId : String, completion : @escaping Handler)
    
    // get all comment under comments
    func getChildComment(commentId : String, completion : @escaping Handler)
    
    func createComment(createCommentRequest : CreateCommentRequest, completion : @escaping Handler)
    
    func updateComment(updateCommentRequest: UpdateCommentRequest,  completion : @escaping Handler)
    
    func deleteComment(commentId : String, completion : @escaping Handler)
    
    func getPostById(postId : String,  completion : @escaping Handler)
    
    func getPostByQuery(query: String,  completion : @escaping Handler)
    
    func getPostBySingleUser(profileId : String, completion : @escaping Handler)
    
    func createPost(createPostRequest: CreatePostRequest,  completion : @escaping Handler)
    
    func updatePost(createPostRequest: UpdatePostRequest,completion: @escaping Handler) 
    
    func deletePost(deletePostRequest: DeletePostRequest, completion: @escaping Handler) 
    
    func getUserMoments(completion: @escaping Handler)  
        
    func createImageMoments(data: [UIImage], completion: @escaping Handler)
    
    func deleteMomentsById(momentId : String, completion: @escaping Handler)
    
    func getAllMoments(completion: @escaping Handler)
    
    func createPostWithImages(createPostRequest: CreatePostRequestWithImage, completion: @escaping Handler)
    
    func getFeedForUser(completion: @escaping Handler)
    

    func createPage(createPageRequest: CreatePageRequest, completion: @escaping Handler)
    
    func getAllUserPage( completion: @escaping Handler)
    
    func getAllUserPageById( pageId : String,  completion: @escaping Handler)
    
    func updatePage(createPageRequest: CreatePageRequest, completion: @escaping Handler)
    
    func getAllPage(isPublic : String, pageNumber : String, completion: @escaping Handler)
    
    func sendAdminInvite( inviteToPageRequest: InviteToPageRequest,  completion: @escaping Handler)
    
    func getAllAdminInvite( completion: @escaping Handler)
    
    func reportAdminInvite(respondToAdminInvite: RespondToAdminInvite,completion: @escaping Handler)
    
    func adminDeletepage(adminDeletePageReuest :AdminDeletePageReuest, completion: @escaping Handler)
    
    func followPage(followPageRequest :FollowPageRequest, completion: @escaping Handler)
    
    func unFollowPage(followPageRequest :FollowPageRequest, completion: @escaping Handler)  
    
    func inviteToPage(inviteToPageRequest :InviteToPageRequest, completion: @escaping Handler)
    
    
    func respondToFriendPageInvite(respondToFriendPageInvite :RespondToFriendPageInvite, completion: @escaping Handler)
    
    func getAllPageFollowers( pageId: String, completion: @escaping Handler)
    
    func reportPage( pageReportRequest: PageReportRequest,completion: @escaping Handler)
    
    func getAllPageReport( pageId: String, completion: @escaping Handler)
    
    func getWayagramProfileByUserId(userId: String, completion: @escaping Handler)
    
    func likePost(likePostRequest: LikePostRequest, completion: @escaping(_ success: Bool) -> ())
    
    func updateWayagramProfile( updateWayagramProfile: UpdateWayagramProfile, completion: @escaping Handler)

    func getWayagramProfileByUsername(username : String, completion: @escaping Handler)

    func getWayagramProfileByQuery(query : String, profileId : String,completion: @escaping Handler)
    
    func followWaya()

}
