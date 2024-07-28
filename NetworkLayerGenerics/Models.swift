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
    var id: String
    var first_name: String
    var last_name: String
    var username: String
    var email: String
}

typealias Login = LoginDTO
