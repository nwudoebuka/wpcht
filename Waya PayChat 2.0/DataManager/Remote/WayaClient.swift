//
//  WayaClient.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/20/21.
//
import Foundation
import Alamofire

protocol Microservice {
    var url: URL? { get }
    var stringValue: String { get }
}

enum WayaClient {
    
    static let base = "http://46.101.41.187:8059/"
    static let profileBase = "http://46.101.41.187:8080/profile-service/"
    static let kycBase = "http://46.101.41.187:8070/kyc-service/"
    static let cardBase = "http://157.230.223.54:3020/card-service/api/"
    static let wayagramBase = "http://157.245.84.14:1000/"
    static let friendBase = "http://157.245.84.14:1200"
    static let postBase = "http://157.245.84.14:1000/all-posts/"
    static let newBase = " http://68.183.60.114:8051/"
    static let momentBase = "http://157.245.84.14:5002"
    static let commentBase = "http://157.245.84.14:5200"
    static let groupBase = "http://157.245.84.14:6001/"
    static let interestBase = "http://157.245.84.14:5000/"
    static let pageBase = "http://157.245.84.14:6002/"
    static let wayagramProfileBase = "http://157.245.84.14:1000/main/"
    static let walletBase = "http://157.230.223.54:9009/api/v1/"
    static let likeBase = "http://157.245.84.14:4200/"
    static let contactBase = "http://46.101.41.187:8065/contact-service/"
    static let accountsBase = "http://46.101.41.187:7090/account-creation-service/api/"
    static let notificationBase = "http://68.183.60.114:8085/"
    static let withdrawalBase = "http://157.230.223.54:2237/waya-withdrawal-service/"
    
    case auth(Auth)
    case profile(ProfileService)
    case card(CardService)
    case wallet(WalletService)
    case contact(ContactService)
    case accounts(AccountService)
    case notification(NotificationService)
    case kyc(KYCService)
    case withdrawal(WithdrawalService)
    case wayagram(WayagramService)
    
    var stringValue: String {
        switch self {
        case .auth(let route):
            return route.stringValue
        case .profile(let route):
            return route.stringValue
        case .card(let route):
            return route.stringValue
        case .wallet(let route):
            return route.stringValue
        case .contact(let route):
            return route.stringValue
        case .accounts(let route):
            return route.stringValue
        case .notification(let route):
            return route.stringValue
        case .kyc(let route):
            return route.stringValue
        case .withdrawal(let route):
            return route.stringValue
        case .wayagram(let route):
            return route.stringValue
        }
    }
    
    var url : URL? {
        guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return nil
        }
        return _url
    }
//
//
//    case addCard
//    case adminDeletePage
//    case acceptFriendRequest
//    case blockUser
//
//    case chargeWalletCard
//    case 
//    
//    case createComment
//    case createGroup
//    case createMoment
//    case createPage
//    case createPost
//
//
//    case createUserInterest(userId : String)
//    case declineFriendrequest
//
//
//    case deleteComment
//    case deleteMoment(id: String)
//    case deletePost
//    case deleteContact(id: String)
//    case deleteUserInterest
//
//
//    case followPage
//    case followUser
//    case joinGroup
//    case getAllAdminInvite(userId: String)
//    case getAllGroup(pageNumber: String)
//    case getAllUser
//    case getAllUserPage(userId: String)
//    case getAllMoments(page: String, pageSize: String)
//    case getAllPage(isPublic: Bool, pageNumber: String)
//    case getAllPageFollowers(userId : String, pageId: String)
//    case getAllPageReport(userId: String, pageId: String)
//    case getChildComments(commentId: String)
//    case getCommentById(commentId : String)
//    case getPostComment(postId : String)
//    case getPostCreatedBySingleUser(profileId: String)
//    case getPostById(postId : String)
//    case getPostByQuery(query : String)
//    case getAllBanks
//    case getContactByPhoneNumber(phoneNumber: String)
//    case getFeedsForUser
//    case getFriends(userId: String, page: Int)
//    case getFriendSuggestion(userId: String)
//    case getFriendRequests(userId: String, page: Int)
//    case getReferralCode(userId: String)
//
//
//    case getUserMoment(userId: String)
//    case getUserDetailAndRoleByID(id : String)
//    case getUserDetailAndRoleByEmail(email: String)
//    case getUserFollower(userId: String, page: Int)
//    case getUserFollowing(userId: String, page: Int)
//    case getUserFriend(userId: String, page: Int)
//    
//    case getUserInterest(userId: String)
//
//    case getUserPageById(userId: String, pageId: String)
//
//
//    case getUserLoginHistroy(userId: String)
//    case getUserLastLoginHistory(userId: String)
//    case getWayagramProfileByUserId(userId : String)
//    case getWayagramProfileByUserProfileId
//    case getWayagramProfileByUsername(username : String)
//    case getWayagramProfileByQuery(query : String, profileId : String)
//    case getSelfUserInfo
//    case inviteOtherToGroup
//    case inviteToPage
//    case isBvnLinked(String)
//    case linkBvnToAccount
//    case muteGroupForUser
//    case leaveGroupAndDelete
//    case likePost
//    case login
//    case resendAuthOTP(String)
//
//    case resetPassword
//
    
//    case respondToGroupInvite
//    case reportGroup
//    case repportPage
//    case respondToAdminInvite
//    case respondToPageInvite
//    case saveUser
//
//    case seeAllMembersInGroup(groupId: String)
//    case searchProfileByEmail(email: String)
//    case searchProfileByName(name: String)
//    case searchProfileByPhoneNumber(phoneNumber: String)
//    case sendAdminInvite
//    case setDefaultWalletAccount
//
//
//
//    case updateGroup
//    case unblockUser
//    case unFollowUser
//    case unFollowPage
//    case updateComment
//    case updatePersonalProfileImage(profileId : String)
//    case updatePost
//
//    case updateUserPage
//    case updateWayagramProfile
//
//

//
//
//
//    case verifyBvn(bvn: String)
//    case verifyPhoneOrEmail(ForgotOTPChannel)
//    case verifyOtp
//    case viewGroupInfo(groupId : String)
//    case getBusinessTypes
//
//
//
//
//
//
//    case tokenValidate
//
//    case withdrawToBank
//
//    var stringValue: String {
//        switch self {
//            case .createAccount(let type):






//            case .getAllUser:
//                return WayaClient.authBase + "auth/user"
//            case .saveUser:
//                return WayaClient.authBase + "auth/user"
//            case .getUserDetailAndRoleByID(let id) :
//                return WayaClient.base + "api/auth/user/\(id)"
//            case .getUserDetailAndRoleByEmail(let email):
//                return WayaClient.base + "api/auth/user/\(email)"
//            case .getSelfUserInfo:
//                return WayaClient.base + "api/auth/user/myinfo"




//            case .updatePersonalProfileImage(let profileId):
//                return WayaClient.profileBase + "update-profile-image/\(profileId)"
            

//            case .searchProfileByEmail(let email):
//                return WayaClient.profileBase + "search-profile-email/\(email)"
//            case .searchProfileByName(let name):
//                return WayaClient.profileBase + "search-profile-name/\(name)"
//            case .searchProfileByPhoneNumber(let phoneNumber):
//                return WayaClient.profileBase + "search-profile-phoneNumber/\(phoneNumber)"
//
//
//
//
//
//                return WayaClient.cardBase +



//
//
//
//
//            case .getWayagramProfileByUserId(let userId):
//                return WayaClient.wayagramProfileBase + "profile/get-by-user-id?user_id=\(userId)"
//            case .getWayagramProfileByUserProfileId:
//                return WayaClient.wayagramBase + "/get-by-id"
//            case .updateWayagramProfile:
//                return WayaClient.wayagramProfileBase + "update"
//            case .createPost:
//                return WayaClient.postBase + "create"
//            case .getCommentById(let commentId):
//                return WayaClient.friendBase + "/?comment_id=\(commentId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
//            case .getPostComment(let postId):
//                return WayaClient.commentBase + "/post-comments?post_id=\(postId)"
//            case .getChildComments(let commentId):
//                return WayaClient.friendBase + "/child-comments&comment_id=\(commentId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
//            case .createComment:
//                return WayaClient.commentBase + "/create"
//            case .updateComment:
//                return WayaClient.commentBase +
//                "/update"
//            case .deleteComment:
//                return WayaClient.friendBase + "/delete"
//
//            case .getPostCreatedBySingleUser(let profileId):
//                return WayaClient.postBase + "/user-posts?profile_id=\(profileId)"
//
//            case .getPostById(let postId):
//                return WayaClient.postBase + "/?post_id=\(postId)"
//            case .getPostByQuery(let query):
//                return WayaClient.postBase + "/search?query=\(query))"
//            case .updatePost:
//                return WayaClient.postBase + "/update"
//            case .deletePost:
//                return WayaClient.postBase + "/delete"
//
//            case .createMoment:
//                return WayaClient.postBase + "create-moment"
//            case .deleteMoment(id: let id):
//                return WayaClient.momentBase + "/deleteMoment?id=\(id)"
//            case .getUserMoment(userId: let userId):
//                return WayaClient.momentBase + "/getUserMoments?UserId=\(userId)"
//            case .getAllMoments(let page, let pageSize):
//                return WayaClient.momentBase + "/moments?page=\(page)&pageSize=\(pageSize)"
//            case .getFeedsForUser:
//                return WayaClient.postBase + "feed"
//            case .followUser:
//                return WayaClient.friendBase + "/follow"
//            case .unFollowUser:
//                return WayaClient.friendBase + "/unfollow"
//            case .blockUser:
//                return WayaClient.friendBase + "/block"
//
//            case .getFriends(userId: let userId, page: let page):
//                return WayaClient.friendBase + "/?user_id=\(userId)&page=\(page)"
//            case .getFriendSuggestion(userId: let userId):
//                return WayaClient.friendBase + "/suggestions?user_id=21"
//            case .getFriendRequests(userId: let userId, page: let page):
//                return WayaClient.friendBase + "/requests?user_id=\(userId)&page=\(page)"
//            case .unblockUser:
//                return WayaClient.friendBase + "/unblock"
//            case .acceptFriendRequest:
//                return WayaClient.friendBase  + "/accept-request"
//            case .declineFriendrequest:
//                return WayaClient.friendBase  + "/decline-request"
//            case .createGroup:
//                return WayaClient.groupBase + "create-group"
//            case .updateGroup:
//                return WayaClient.groupBase + "/update-group"
//            case .getAllGroup(let pageNumber):
//                return WayaClient.groupBase + "get-all-groups?pageNumber=\(pageNumber)"
//            case .viewGroupInfo(let groupId):
//                return WayaClient.groupBase + "view-group-info?groupId=\(groupId)"
//            case .joinGroup:
//                return WayaClient.groupBase + "join-group"
//            case .inviteOtherToGroup:
//                return WayaClient.groupBase + "invite-others-to-group"
//            case .respondToGroupInvite:
//                return WayaClient.groupBase + "respond-to-group-invite"
//            case .seeAllMembersInGroup(let groupId):
//                return WayaClient.groupBase + "see-all-members-in-group?groupId=\(groupId)"
//            case .muteGroupForUser:
//                return WayaClient.groupBase + "mute-group-from-user-end"
//            case .reportGroup:
//                return WayaClient.groupBase + "report"
//            case .leaveGroupAndDelete:
//                return WayaClient.groupBase + "leave-and-delete-group"
//            case .createUserInterest(let userId):
//                return WayaClient.interestBase + "postUserInterest?userId=\(userId)"
//            case .getUserInterest(let userId):
//                return WayaClient.interestBase + "userInterest?UserId=\(userId)"
//            case .deleteUserInterest:
//                return WayaClient.interestBase + "deleteUserInterest"
//            case .createPage:
//                return WayaClient.pageBase + "create-page"
//            case .getAllUserPage(let userId):
//                return WayaClient.pageBase + "get-all-user-pages?userId=\(userId)"
//            case .getUserPageById(let userId, let pageId):
//                return WayaClient.pageBase + "get-user-page-by-id?userId=\(userId)&pageId=\(pageId)"
//            case .updateUserPage:
//                return WayaClient.pageBase + "update-page"
//            case .getAllPage(let isPublic, let pageNumber):
//                return WayaClient.pageBase + "get-all-pages?isPublic=\(isPublic)&pageNumber=\(pageNumber)"
//            case .sendAdminInvite:
//                return WayaClient.pageBase + "send-admin-invite"
//            case .getAllAdminInvite(let userId):
//                return WayaClient.pageBase + "get-all-admin-invites?userId=\(userId)"
//            case .respondToAdminInvite:
//                return WayaClient.pageBase + "respond-to-admin-invite"
//            case .adminDeletePage:
//                return WayaClient.pageBase + "admin-delete-page"
//            case .followPage:
//                return WayaClient.pageBase + "follow"
//            case .unFollowPage :
//                return WayaClient.pageBase + "un-follow"
//            case .inviteToPage:
//                return WayaClient.pageBase + "invite-to-a-page"
//            case .respondToPageInvite:
//                return WayaClient.pageBase + "respond-to-friend-invite"
//            case .getAllPageFollowers(let userId, let pageId):
//                return WayaClient.pageBase + "get-all-page-followers?userId=\(userId)&pageId=\(pageId)"
//            case .repportPage:
//                return WayaClient.pageBase + "/page-report"
//            case .getAllPageReport(let userId, let pageId):
//                return WayaClient.pageBase + "get-all-page-reports?userId=\(userId)&pageId=\(pageId)"
//            case .getUserWallet(let userId):
//
//
//            case .getReferralCode(let userId):
//                return WayaClient.profileBase + "referral-code/\(userId)"
//            case .likePost:
//                return WayaClient.likeBase + "post"
            


//
//
//
            



//            case .getUserLoginHistroy(let userId):
//                return WayaClient.authBase + "history/user-history/\(userId)"
//            case .getUserLastLoginHistory(let userId):
//                return WayaClient.authBase + "history/user-last-login/\(userId)"
//            case .getWayagramProfileByUsername(let username):
//                return WayaClient.wayagramProfileBase + "?username=\(username)"
//            case .getUserFollower(let userId, let page):
//                return WayaClient.friendBase + "/followers?user_id=\(userId)&page=\(page)"
//            case .getUserFollowing(let userId, let page):
//                return WayaClient.friendBase + "/following?user_id=\(userId)&page=\(page)"
//            case .getUserFriend(let userId, let page):
//                return WayaClient.friendBase +  "/?user_id=\(userId)&page=\(page)"
//            case .getWayagramProfileByQuery(let query, let profileId):
//                return WayaClient.wayagramProfileBase + "search?query=\(query)&profile_id=\(profileId)"
//

//            case .chargeWalletCard:
//                return WayaClient.cardBase + "card/charge"
//            case .deleteContact(let id):
//                return WayaClient.contactBase + "contact/account/service/delete/contact/account/\(id)"

//            case .getContactByPhoneNumber(let phoneNumber):
//                return WayaClient.contactBase + "contact/account/service/get/contact/account/by/phone/\(phoneNumber)"
//
//

//
//

//            case .getBusinessTypes:
//                return WayaClient.authBase + "business/type/find/all"





        

//        }
//    }
//

}
