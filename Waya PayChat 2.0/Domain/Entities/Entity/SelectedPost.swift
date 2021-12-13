//
//  SelectedPost.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/18/21.
//

/**
 position of the post in the list 
 
 action id : 
    like : 0
    unlike: 1
    repost :2
    bookmark : 3
    reportppost : 4
    block user : 5
    followuser : 6
    mute user : 7
        comment: 8
 */

import Foundation


struct SelectedPost {
    var postResponse : PostResponse = PostResponse()
    var actionId : Int  = -1
    var position: Int = -1 
    var isActive: Bool = false
}
