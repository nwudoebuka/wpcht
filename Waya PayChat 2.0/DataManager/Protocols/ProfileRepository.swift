//
//  ProfileRepository.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/2/21.
//

import Foundation

protocol ProfileRepository{
    
    func updateUserProfile(userid: String, updateUserProfileRequest: Dictionary<String, Any>, completion: @escaping Handler)
   
    func getUserProfile(userId: String, completion: @escaping Handler)
   
    func searchUserByEmail(email: String, completion: @escaping Handler)
   
    func searchUserByPhone(phoneNumber : String, completion: @escaping Handler)
    
    func searchUserByName(name : String, completion: @escaping Handler)
   
    func uploadProfileImage(data: Data, completion: @escaping Handler)
   
    func getFriends(page : Int, completion: @escaping Handler)
   
    func getFriendSuggestions(completion: @escaping Handler)
    func getAllFriendsRequest(page: Int, completion: @escaping Handler)
    func followUsers(followRequest: FollowUserRequest, completion: @escaping Handler)
    func unFollowUsers(followRequest: FollowUserRequest, completion: @escaping Handler)
    func blockUser(followRequest: FollowUserRequest, completion: @escaping Handler)
    func unBlockUser(followRequest: FollowUserRequest, completion: @escaping Handler)
    func acceptRequest(followRequest: FollowUserRequest, completion: @escaping Handler)
    func declineRequest(followRequest: FollowUserRequest, completion: @escaping Handler)
    func getReferralCode(completion: @escaping Handler)
    func getFollowers(pageNumber : Int, completion: @escaping Handler)
    func getFollowing(pageNumber : Int, completion: @escaping Handler)
    func getFriends(pageNumber : Int, completion: @escaping Handler)
    func getOtherDetailsForCorporate(id: String, completion: @escaping Handler)

}
