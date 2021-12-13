//
//  UserRepository.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/25/21.
//

import Foundation


protocol  UserRepository {
    func getAllUserFromRedis(completion : @escaping Handler)
//    func saveUserToRedis(saveUserRequest: SaveUserRequest, completion : @escaping Handler)
    func getUserDetailsAndRolesByID(id : String, completion : @escaping Handler)
    func getUserDetailByEmail(email: String , completion : @escaping Handler)
    func getMyUserInfo(completion : @escaping Handler)
}
