//
//  NetworkError.swift
//  NetworkLayerGenerics
//
//  Created by Peter Kos on 7/27/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case notImplemented
    case transportError(String)
    case jsonEncodingError(String, URLRequest)
    case jsonDecodingError(String, URLRequest)
    case httpError(ResponseCode, URLResponse)
}

enum ResponseCode: Int {
    case ok = 200
    case notFound = 404

    var isError: Bool {
        [.notFound].contains(self)
    }
}
