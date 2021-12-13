//
//  ProfileViewModelProtocol.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/3/21.
//

import Foundation
import Signals

protocol ProfileViewModel {
         
    func updateUserProfile(updateProfileRequest: Dictionary<String, Any>)
    
    func uploadProfileImage(data: Data,  completion : @escaping Handler)
    
    func getUserProfileById(userId : String, completion : @escaping Handler)
    
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
    
    var profileUpdated: Signal<(Bool, String?)> { get }
}
