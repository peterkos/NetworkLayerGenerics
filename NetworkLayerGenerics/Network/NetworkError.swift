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
    case jsonDecodingError(DecodingError?, URLRequest)
    case httpError(ResponseCode, URLResponse)

    var fullDescription: String {
        switch self {
        case .notImplemented: "Not Implemented"
        case let .transportError(info): "Transport error: \(info)"
        case .jsonEncodingError: "Encoding error"
        case let .jsonDecodingError(error, _):
            if let error {
                switch error {
                case let .typeMismatch(_, context):
                    context.underlyingError.debugDescription
                case let .valueNotFound(_, context):
                    context.underlyingError.debugDescription
                case let .keyNotFound(_, context):
                    context.underlyingError.debugDescription
                case let .dataCorrupted(context):
                    context.underlyingError.debugDescription
                @unknown default:
                    fatalError()
                }
            } else {
                "Unknown error"
            }
        case let .httpError(responseCode, _): "HTTP error \(responseCode.description)"
        }
    }
}

enum ResponseCode: Int {
    case ok = 200
    case notFound = 404

    var isError: Bool {
        [.notFound].contains(self)
    }

    var description: String {
        "\(rawValue) \(self)"
    }
}
