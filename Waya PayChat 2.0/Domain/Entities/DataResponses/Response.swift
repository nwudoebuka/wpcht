//
//  Response.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 09/06/2021.
//

import Foundation

struct Response<T: Codable>: Codable {
    var status: Bool?
    var error: String?
    var code: Int?
    var message: String?
    var data: T?
    var statusCode: MetadataType? //"CREATED",
    var statusCodeValue: Int? // 201
    
    enum CodingKeys: String, CodingKey {
        case status, message, code, data, error, statusCode, statusCodeValue
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        
        status = try values.decodeIfPresent(Bool.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        data = try values.decodeIfPresent(T.self, forKey: .data)
        error = try values.decodeIfPresent(String.self, forKey: .error)
        statusCode = try values.decodeIfPresent(MetadataType.self, forKey: .statusCode)
        statusCodeValue = try values.decodeIfPresent(Int.self, forKey: .statusCodeValue)
    }
}

struct ResponseList<T: Codable>: Codable {
    var timestamp: String?
    var status: Bool?
    var code: Int?
    var error: String?
    var message: String?
    var data: [T]?
}

enum MetadataType: Codable {
  case int(Int)
  case string(String)

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      self = try .int(container.decode(Int.self))
    } catch DecodingError.typeMismatch {
      do {
        self = try .string(container.decode(String.self))
      } catch DecodingError.typeMismatch {
        throw DecodingError.typeMismatch(MetadataType.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
      }
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .int(let int):
      try container.encode(int)
    case .string(let string):
      try container.encode(string)
    }
  }
}
