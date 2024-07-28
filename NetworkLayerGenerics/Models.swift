//
//  Models.swift
//  NetworkLayerGenerics
//
//  Created by Peter Kos on 7/27/24.
//

import Foundation

struct ResponseDTO<Response: Codable>: Codable {
    var randomBackendDataWeNeedToUnwrap: String
    var data: Response
}

struct LoginDTO: Codable {
    var username: String
    var password: String
}

struct Login: Codable {
    var username: String
    var password: String
    var followerCount: Int
}
