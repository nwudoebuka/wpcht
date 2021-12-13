//
//  CreateAccountMapper.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/25/21.
//

import Foundation

class EntityMapper{
    
    
    static func createWayagramProfileMapper(wayagramProfile : WayagramProfileResponse, imageGroup : DispatchGroup) -> FollowerViewModelItem?{
        imageGroup.enter()
//        var itemImage =  UIImage(named: "profile-placeholder")
//        if wayagramProfile.user.profileImage != nil || wayagramProfile.user.profileImage != ""{
//            ImageLoader.loadImageData(urlString: wayagramProfile.user.profileImage!) {(result) in
//                if let image = result{
//                    itemImage = image
//                }
//                imageGroup.leave()
//            }
//        } else{
//            imageGroup.leave()
//        }
//        let followerViewModelMapper = FollowerViewModelItem(wayagramProfileId: wayagramProfile.id, headerLabel: wayagramProfile.user.firstName, subHeaderLabel: wayagramProfile.username, image: itemImage!, userProfileid: String(wayagramProfile.user.userId), userIDInt: wayagramProfile.user.userId)
//        return followerViewModelMapper
        
        return nil // remove
    }
}
