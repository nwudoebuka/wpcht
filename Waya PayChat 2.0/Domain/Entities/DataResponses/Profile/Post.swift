//
//  Post.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/10/21.
//

import Foundation
import SwiftUI

struct Post_ : Identifiable {
    let id = UUID()
    var commentCount : Int = 0
    var likeCount : Int = 0
    var repostCount : Int = 0
    var shareCount : Int = 0
    var time : String = ""
    var username : String = ""
    var fullname : String = ""
    var image : UIImage = UIImage(named: "profile-placeholder") ?? UIImage()
    var description = ""
}
