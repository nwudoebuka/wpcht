//
//  WayagramRepository.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/9/21.
//

import Foundation

protocol WayagramRepository {
    
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
    
    //GROUP 
    
    func createGroup(createGroupRequest: CreateGroupRequest, completion: @escaping Handler)
    
    func updateGroup(createGroupRequest: CreateGroupRequest, completion: @escaping Handler)
    
    func getAllGroup(pageNumber: String, completion: @escaping Handler)
    
    func viewGroupInfo(groupId: String, completion: @escaping Handler)

    func joinGroup(joinGroupRequest: GroupRequest ,completion: @escaping Handler)
    
    func inviteOtherToGroup(inviteToGroupRequest: InviteToGroupRequest ,completion: @escaping Handler)

    func responseToInvite(respondToInviteRequest: RespondToInviteRequest ,completion: @escaping Handler)
    
    func seeAllGroupMembers(grouoId: String ,completion: @escaping Handler)
    
    func muteGroupFromUserEnd(groupRequest: GroupRequest ,completion: @escaping Handler)
    
    func reportMember(reportMemberRequest: ReportMemberRequest ,completion: @escaping Handler)

    func leaveGroupAndDelete(groupRequest: GroupRequest ,completion: @escaping Handler)
    
    //PAGE
    
    func createPage(createPageRequest: CreatePageRequest, completion: @escaping Handler)
    
    func getAllUserPage(userId : String, completion: @escaping Handler)
    
    func getAllUserPageById(userId : String, pageId : String,  completion: @escaping Handler)
    
    func updatePage(createPageRequest: CreatePageRequest, completion: @escaping Handler)

    func getAllPage(isPublic : String, pageNumber : String, completion: @escaping Handler)

    func sendAdminInvite( inviteToPageRequest: InviteToPageRequest,  completion: @escaping Handler)
    
    func getAllAdminInvite(userId : String ,  completion: @escaping Handler)
    
    func reportAdminInvite(respondToAdminInvite: RespondToAdminInvite,completion: @escaping Handler)
    
    func adminDeletepage(adminDeletePageReuest :AdminDeletePageReuest, completion: @escaping Handler)
    
    func followPage(followPageRequest :FollowPageRequest, completion: @escaping Handler)
    
    func unFollowPage(followPageRequest :FollowPageRequest, completion: @escaping Handler)  
    
    func inviteToPage(inviteToPageRequest :InviteToPageRequest, completion: @escaping Handler)

    
    func respondToFriendPageInvite(respondToFriendPageInvite :RespondToFriendPageInvite, completion: @escaping Handler)
    
    func getAllPageFollowers(userId : String, pageId: String, completion: @escaping Handler)
        
    func reportPage( pageReportRequest: PageReportRequest,completion: @escaping Handler)

    func getAllPageReport(userId : String, pageId: String, completion: @escaping Handler)

    func getWayagramProfileByUserId(userId: String, completion: @escaping Handler)
    
    func getWayagramProfileByUsername(username : String, completion: @escaping Handler)
    
    func likePost(likePostRequest: LikePostRequest, completion: @escaping Handler)
    
    func updateWayagramProfile( updateWayagramProfile: UpdateWayagramProfile, completion: @escaping Handler)
    
    func getWayagramProfileByQuery(query : String, profileId : String,completion: @escaping Handler)
    // Interests (graph service)
    func getUserNewInterests(profileId: String, completion: @escaping Handler)
    func saveUserInterest(interest: String, callback: @escaping Handler)
    func getSuggestedFollows(completion: @escaping Handler)
    func followUser(username: String, follow: Bool,  completion: @escaping Handler)
    func autoFollowWaya()
}  
