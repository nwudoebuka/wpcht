//
//  WayaTestClient.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 07/06/2021.
//
@testable import Waya_PayChat_2_0
import Foundation

struct WayaTestClient {
    
    var endpoint: WayaClient!
    
    init(endpoint: WayaClient) {
        self.endpoint = endpoint
    }
    
    var stringValue: String {
        switch endpoint {
        case .login:
            return "auth_service/login"
        case .validatePin(let pin):
            return "auth_service/validate_pin/\(pin)"
        case .addBankAccount:
            return ""
        case .addCard:
            return ""
        case .adminDeletePage:
            return ""
        case .acceptFriendRequest:
            return ""
        case .blockUser:
            return ""
        case .changeForgotPassword:
            return ""
        case .chargeCard:
            return ""
        case .chargeWalletCard:
            return ""
        case .createAccount(let type):
            let dir: String = (type == .corporate) ? "auth_service/register_corporate" : "auth_service/register_personal"
            return dir
        case .createAccountPin:
            return "auth_service/create_pin"
        case .createComment:
            return ""
        case .createGroup:
            return ""
        case .createMoment(let userId):
            return ""
        case .createPage:
            return ""
        case .createPost:
            return ""
        case .createWallet(let userId):
            return ""
        case .createWalletUser:
            return ""
        case .changePassword(let email):
            return ""
        case .createUserInterest(let userId):
            return ""
        case .declineFriendrequest:
            return ""
        case .deleteBankAccount(let accountNumber):
            return ""
        case .deleteBankCard(let cardNumber):
            return ""
        case .deleteComment:
            return ""
        case .deleteMoment(let id):
            return ""
        case .deletePost:
            return ""
        case .deleteContact(let id):
            return ""
        case .deleteUserInterest:
            return ""
        case .findAllContact:
            return ""
        case .filterContact:
            return ""
        case .forgotPassword(let email):
            return ""
        case .followPage:
            return ""
        case .followUser:
            return ""
        case .joinGroup:
            return ""
        case .getAllAdminInvite(let userId):
            return ""
        case .getAllGroup(let pageNumber):
            return ""
        case .getAllUser:
            return ""
        case .getAllUserPage(let userId):
            return ""
        case .getAllMoments(let page, let pageSize):
            return ""
        case .getAllPage(let isPublic, let pageNumber):
            return ""
        case .getAllPageFollowers(let userId, let pageId):
            return ""
        case .getAllPageReport(let userId, let pageId):
            return ""
        case .getChildComments(let commentId):
            return ""
        case .getCommentById(let commentId):
            return ""
        case .getPostComment(let postId):
            return ""
        case .getPostCreatedBySingleUser(let profileId):
            return ""
        case .getPostById(let postId):
            return ""
        case .getPostByQuery(let query):
            return ""
        case .getAllBanks:
            return ""
        case .getContactByPhoneNumber(let phoneNumber):
            return ""
        case .getFeedsForUser(let profileId):
            return ""
        case .getFriends(let userId, let page):
            return ""
        case .getFriendSuggestion(let userId):
            return ""
        case .getFriendRequests(let userId, let page):
            return ""
        case .getReferralCode(let userId):
            return ""
        case .getUserBankAccounts:
            return ""
        case .getUserBankCard(let userId):
            return ""
        case .getUserMoment(let userId):
            return ""
        case .getUserDetailAndRoleByID(let id):
            return ""
        case .getUserDetailAndRoleByEmail(let email):
            return ""
        case .getUserFollower(let userId, let page):
            return ""
        case .getUserFollowing(let userId, let page):
            return ""
        case .getUserFriend(let userId, let page):
            return ""
        case .getUserPersonalProfile(let userId):
            return ""
        case .getUserInterest(let userId):
            return ""
        case .getUserWallet(_):
            return "wallet_service/get_wallets"
        case .getUserPageById(let userId, let pageId):
            return ""
        case .getMyLastLoginHistory:
            return ""
        case .getMyLoginHistory:
            return ""
        case .getUserLoginHistroy(let userId):
            return ""
        case .getUserLastLoginHistory(let userId):
            return ""
        case .getWayagramProfileByUserId(let userId):
            return ""
        case .getWayagramProfileByUserProfileId:
            return ""
        case .getWayagramProfileByUsername(let username):
            return ""
        case .getWayagramProfileByQuery(let query, let profileId):
            return ""
        case .getSelfUserInfo:
            return ""
        case .inviteOtherToGroup:
            return ""
        case .inviteToPage:
            return ""
        case .isBvnLinkedToAccount:
            return ""
        case .leaveGroupAndDelete:
            return ""
        case .likePost:
            return ""
        case .linkBvnToAccount:
            return ""
        case .muteGroupForUser:
            return ""
        case .resendOtpToPhone(let phone):
            return ""
        case .resendOtpToEmail(let email):
            return ""
        case .findAllBusinessTypes:
            return ""
        case .resetPassword:
            return ""
        case .resolveAccountNumber:
            return ""
        case .respondToGroupInvite:
            return ""
        case .reportGroup:
            return ""
        case .repportPage:
            return ""
        case .respondToAdminInvite:
            return ""
        case .respondToPageInvite:
            return ""
        case .saveUser:
            return ""
        case .saveUserLoginHistory:
            return ""
        case .seeAllMembersInGroup(let groupId):
            return ""
        case .searchProfileByEmail(let email):
            return ""
        case .searchProfileByName(let name):
            return ""
        case .searchProfileByPhoneNumber(let phoneNumber):
            return ""
        case .sendAdminInvite:
            return ""
        case .setDefaultWalletAccount(let userId, let account):
            return ""
        case .sendMoneyToContact:
            return ""
        case .sendMoneyToEmail:
            return ""
        case .sendMoneyToUserId:
            return ""
        case .updateGroup:
            return ""
        case .unblockUser:
            return ""
        case .unFollowUser:
            return ""
        case .unFollowPage:
            return ""
        case .updateComment:
            return ""
        case .updatePersonalProfileImage(let profileId):
            return ""
        case .updatePost:
            return ""
        case .updateUserProfile(let userId):
            return ""
        case .updateUserPage:
            return ""
        case .updateWayagramProfile:
            return ""
        case .verifyBvn(let bvn):
            return ""
        case .verifyEmail:
            return ""
        case .verifyOtp:
            return ""
        case .viewGroupInfo(let groupId):
            return ""
        case .getBusinessTypes:
            return ""
        case .verifyCardOtp:
            return ""
        case .getVirtualAccounts(_):
            return "wallet_service/get_virtual_accounts"
        case .chargeBankAccount:
            return ""
        case .getUserInfoByEmail(let email):
            return ""
        case .getUserInfoByPhone(let phone):
            return ""
        case .none:
            return ""
        case .some(.getChargeAbleBanks):
            return ""
        }
    }
}
