//
//  Extensions.swift
//  NetworkLayerGenerics
//
//  Created by Peter Kos on 7/27/24.
//

import Foundation

// MARK: - Helpers

extension URLResponse {
    var httpURLResponse: HTTPURLResponse {
        // SAFETY: Quinn the Eskimo's blessing
        // https://forums.developer.apple.com/forums/thread/120099?answerId=372749022#372749022
        self as! HTTPURLResponse
    }
}

extension HTTPURLResponse {
    var responseCode: ResponseCode? {
        ResponseCode(rawValue: httpURLResponse.statusCode)
    }

    var responseCodeIsError: Bool? {
        responseCode?.isError
    }
}

extension URLSession {
    /// Return a `HTTPURLResponse` as the response of an HTTP request, instead of the limited URLResponse.
    /// Not sure why this isn't in the standard library yet.
    func dataResponse(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await URLSession.shared.data(for: request)
        return (data, response.httpURLResponse)
    }
}
