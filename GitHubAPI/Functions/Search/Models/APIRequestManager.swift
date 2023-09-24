//
//  APIRequestManager.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/16.
//

import Foundation

protocol APIRequestManagerProtocol {
    func handleSessionTask<T: Decodable>(_ dataType: T.Type, request: URLRequest) async throws -> T
}

extension APIRequestManagerProtocol {
    func handleSessionTask<T: Decodable>(_: T.Type, request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw APIError.unknownError
        }

        switch response.statusCode {
        case 200:
            // MEMO: 取得できたレスポンスを引数で指定した型の配列に変換して受け取る
            do {
                let hashableObjects = try JSONDecoder().decode(T.self, from: data)
                return hashableObjects
            } catch {
                throw APIError.decodeFailed
            }
        case 304:
            throw APIError.notModified
        case 404:
            throw APIError.resurceNotFound
        case 422:
            throw APIError.validationFailed
        case 503:
            throw APIError.serviceUnavailable
        default:
            throw APIError.unknownError
        }
    }
}
