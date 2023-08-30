//
//  APIRequestManager.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/16.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: LocalizedError {
    case decodeFailed
    case validationFailed
    case notModified
    case serviceUnavailable
    case unknownError
    case resurceNotFound
}

protocol APIRequestManagerProtocol {
    func getRepository(perPage: Int, searchword: String) async throws -> RepositoryList
    func getReadme(owner: String, repo: String) async throws -> Readme
}

class APIRequestManager {
    private func handleSessionTask<T: Decodable>(_ dataType: T.Type, request: URLRequest) async throws -> T {
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

// MARK: - APIRequestManagerProtocol

extension APIRequestManager: APIRequestManagerProtocol {
    /// GitHubから、該当のwordが入るリポジトリの取得を行う
    func getRepository(perPage: Int, searchword: String) async throws -> RepositoryList {
        // MEMO: urlの作成
        var urlComponents = URLComponents(string: "https://api.github.com/search/repositories")
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: searchword),
            URLQueryItem(name: "page", value: String(perPage))
        ]
        // MEMO: urlが作成できないケースを認識するため、デバッグ時にアプリを落とす
        guard let url = urlComponents?.url else {
            assertionFailure("Error: can't convert to url")
            throw APIError.unknownError
        }
        let request = URLRequest(url: url)
        return try await handleSessionTask(RepositoryList.self, request: request)
    }
    
    func getReadme(owner: String, repo: String) async throws -> Readme {
        // MRMO: urlの作成
        let urlString = "https://api.github.com/repos/\(owner)/\(repo)/readme"
        // MEMO: urlが作成できないケースを認識するため、デバッグ時にアプリを落とす
        guard let url = URL(string: urlString) else {
            assertionFailure("Error: can't convert to url")
            throw APIError.unknownError
        }
        let request = URLRequest(url: url)
        return try await handleSessionTask(Readme.self, request: request)
    }
    
}
