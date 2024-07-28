//
//  AppNetwork.swift
//  NetworkLayerGenerics
//
//  Created by Peter Kos on 7/27/24.
//

import Foundation

typealias NetworkResult<Response> = Result<Response, NetworkError>

enum AppNetwork<Response: Codable & Sendable> {
    private enum HTTPMethod: String {
        case GET
        case POST
    }

    static func get(url: URL) async -> NetworkResult<Response> {
        var request = URLRequest(url: url)
        return await performAndDecode(request: &request, method: .GET)
    }

    static func post(
        data: some Codable,
        url: URL
    ) async -> NetworkResult<Response> {
        var request = URLRequest(url: url)
        do {
            let data = try JSONEncoder().encode(data)
            request.httpBody = data
        } catch {
            return .failure(.jsonEncodingError(error.localizedDescription, request))
        }

        return await performAndDecode(request: &request, method: .POST)
    }
}

extension AppNetwork {
    private static func performAndDecode(
        request: inout URLRequest,
        method: HTTPMethod
    ) async -> NetworkResult<Response> {
        // Header configuration
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestData: Data
        switch await perform(request: request) {
        case let .success(data):
            requestData = data
        case let .failure(error):
            return .failure(error)
        }

        return decode(data: requestData, forRequest: request, model: Response.self)
    }

    private static func perform(request: URLRequest) async -> NetworkResult<Data> {
        let responseData: Data
        let response: HTTPURLResponse
        do {
            (responseData, response) = try await URLSession.shared.dataResponse(for: request)
        } catch {
            return .failure(.transportError(error.localizedDescription))
        }
        guard let code = response.responseCode else {
            return .failure(.transportError("Unknown response code for response \(response.statusCode)"))
        }
        if code.isError {
            return .failure(.httpError(code, response))
        }
        return .success(responseData)
    }

    private static func decode<Model: Codable>(
        data: Data,
        forRequest request: URLRequest,
        model _: Model.Type
    ) -> NetworkResult<Model> {
        let responseDTO: ResponseDTO<Model>
        do {
            responseDTO = try JSONDecoder().decode(ResponseDTO<Model>.self, from: data)
        } catch {
            return .failure(.jsonDecodingError(error.localizedDescription, request))
        }

        return .success(responseDTO.data)
    }
}
