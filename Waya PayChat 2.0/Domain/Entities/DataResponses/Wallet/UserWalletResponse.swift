//
//  UserWalletResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/12/21.
//

import Foundation

struct UserWalletResponse: Codable {
    
    var id: Int64
    var del_flg: Bool
    var entity_cre_flg: Bool
    var sol_id: String
    var bacid: String
    var accountNo: String
    var acct_name: String
    var gl_code: String
    var product_code: String
    var acct_ownership: String
    var frez_code: String?
    var frez_reason_code: String?
    var acct_opn_date: String
    var acct_cls_flg: Bool
    var balance: Decimal
    var un_clr_bal_amt: Decimal
    var hashed_no: String
    var int_paid_flg:  Bool
    var int_coll_flg: Bool
    var lchg_user_id: String?
    var lchg_time: String?
    var rcre_user_id: String
    var rcre_time: String
    var acct_crncy_code: String
    var lien_amt: Decimal
    var product_type: String
    var cum_dr_amt: Decimal
    var cum_cr_amt: Decimal
    var chq_alwd_flg: Bool
    var cash_dr_limit: Float? = nil //9.99999999999E9,
    var xfer_dr_limit: Float? = nil //9.99999999999E9,
    var cash_cr_limit: Float? = nil //9.99999999999E9,
    var xfer_cr_limit: Float? = nil //9.99999999999E9,
    var acct_cls_date: String?
    var last_tran_date: String? //"2021-07-21",
    var last_tran_id_dr: String? //"M6",
    var last_tran_id_cr: String? // "M5",
    var datumDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id,  del_flg, entity_cre_flg, sol_id, bacid, accountNo, acct_name, gl_code, product_code, acct_ownership, frez_code, frez_reason_code, acct_opn_date, acct_cls_flg, un_clr_bal_amt, hashed_no, int_paid_flg, int_coll_flg, lchg_user_id, lchg_time, rcre_user_id, rcre_time, acct_crncy_code, lien_amt, product_type, cum_dr_amt, cum_cr_amt, chq_alwd_flg, acct_cls_date, last_tran_date, last_tran_id_dr, last_tran_id_cr
        case balance = "clr_bal_amt"
        case datumDefault = "walletDefault"
    }

    init(from decoder: Decoder) throws {
        let values =  try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        del_flg = try values.decode(Bool.self, forKey:  .del_flg)
        entity_cre_flg = try values.decode(Bool.self, forKey: .entity_cre_flg)
        sol_id = try values.decode(String.self, forKey: .sol_id)
        bacid = try values.decode(String.self, forKey: .bacid)
        accountNo = try values.decode(String.self, forKey: .accountNo)
        acct_name = try values.decode(String.self, forKey: .acct_name)
        gl_code = try values.decode(String.self, forKey: .gl_code)
        product_code = try values.decode(String.self, forKey: .product_code)
        acct_ownership = try values.decode(String.self, forKey: .acct_ownership)
        frez_code = try values.decodeIfPresent(String.self, forKey: .frez_code)
        frez_reason_code = try values.decodeIfPresent(String.self, forKey: .frez_reason_code)
        acct_opn_date = try values.decode(String.self, forKey: .acct_opn_date)
        acct_cls_flg = try values.decode(Bool.self, forKey: .acct_cls_flg)
        balance = try values.decode(Decimal.self, forKey: .balance)
        un_clr_bal_amt = try values.decode(Decimal.self, forKey: .un_clr_bal_amt)
        hashed_no = try values.decode(String.self, forKey: .hashed_no)
        int_paid_flg = try values.decode(Bool.self, forKey: .int_paid_flg)
        int_coll_flg = try values.decode(Bool.self, forKey: .int_coll_flg)
        lchg_user_id = try values.decodeIfPresent(String.self, forKey: .lchg_user_id)
        lchg_time = try values.decodeIfPresent(String.self, forKey: .lchg_time)
        rcre_user_id = try values.decode(String.self, forKey: .rcre_user_id)
        rcre_time = try values.decode(String.self, forKey: .rcre_time)
        acct_crncy_code = try values.decode(String.self, forKey: .acct_crncy_code)
        lien_amt = try values.decode(Decimal.self, forKey: .lien_amt)
        product_type = try values.decode(String.self, forKey: .product_type)
        cum_dr_amt = try values.decode(Decimal.self, forKey: .cum_dr_amt)
        cum_cr_amt = try values.decode(Decimal.self, forKey: .cum_cr_amt)
        chq_alwd_flg = try values.decode(Bool.self, forKey: .chq_alwd_flg)
        acct_cls_date = try values.decodeIfPresent(String.self, forKey: .acct_cls_date)
        last_tran_date = try values.decodeIfPresent(String.self, forKey: .last_tran_date)
        last_tran_id_dr = try values.decodeIfPresent(String.self, forKey: .last_tran_id_dr)
        last_tran_id_cr = try values.decodeIfPresent(String.self, forKey: .last_tran_id_cr)
        datumDefault = try values.decode(Bool.self, forKey: .datumDefault)
    }
}


struct ContactResponse: Codable {
    let contacts: [Contact]
}

struct Contact: Codable {
    var phone: [String]
    var name: String?
    var image: String?
    var wayaUser: Bool?
}

struct AuthContactResponse: Codable {
    var phone: String
    var isWayaUser: Bool
}
//
//struct WalletResponse: Codable {
//    var id: Int
//    var accountNo: Int
//    var productId: Int
//    var productName: String
//    var status: WalletStatus
//    var currency: WalletCurrency
//}
//
//struct WalletStatus: Codable {
//    var id: Int
//    var code: String //savingsAccountStatusType.approved,
//    var value: String //Approved,
//    var submittedAndPendingApproval: Bool //false
//    var approved: Bool
//    var rejected: Bool
//    var withdrawnByApplicant: Bool
//    var active: Bool
//    var closed: Bool
//}
//
//struct WalletCurrency: Codable {
//    var code: String
//    var name: String
//    var decimalPlaces: Int
//    var nameCode: String
//    var displayLabel: String
//}
