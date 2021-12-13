//
//  MockResponse.swift
//  Waya PayChat 2.0Tests
//
//  Created by Nwudo Anthony Chukwuebuka on 20/06/2021.
//

import Foundation


//typealias MockResponse<T: Codable, B:Codable> = (T, B) -> Void

//
struct MockResponse<T: Codable, S: Codable>: Codable {
    var correct: T?
    var incorrect: S?
    
    enum CodingKeys: String, CodingKey {
        case correct = "correct_output"
        case incorrect = "incorrect_output"
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        correct = try values.decodeIfPresent(T.self, forKey: .correct)
        incorrect = try values.decodeIfPresent(S.self, forKey: .incorrect)
    }
}
