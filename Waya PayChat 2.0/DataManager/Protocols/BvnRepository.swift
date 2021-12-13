//
//  BvnRepository.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/2/21.
//

import Foundation


protocol BvnRepository {
    func linkBvnToAccount(linkBvnRequest: LinkBvnRequest,  completion : @escaping Handler)
    func verifyBvnToAccount(otp: String, user: String, completion : @escaping Handler)
    func isBvnLinked(completion: @escaping Handler)
}
