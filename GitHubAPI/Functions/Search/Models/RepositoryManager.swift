//
//  RepositoryManager.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/31.
//

import Foundation

enum APIResult {
    case update(Decodable)
    case doNothing
    case retry
}

protocol RepositoryFetchPorotocol: APIRequestManagerProtocol {
    func fetchRepository(perPage: Int, searchword: String) async throws -> RepositoryList
}

/// 本番用のAPI接続クラス
class RepositoryFetcher: RepositoryFetchPorotocol {
    func fetchRepository(perPage: Int, searchword: String) async throws -> RepositoryList {
        var urlComponents = URLComponents(string: "https://api.github.com/search/repositories")
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: searchword),
            URLQueryItem(name: "page", value: String(perPage)),
        ]
        // MEMO: urlが作成できないケースを認識するため、デバッグ時にアプリを落とす
        guard let url = urlComponents?.url else {
            assertionFailure("Error: can't convert to url")
            throw APIError.unknownError
        }
        let request = URLRequest(url: url)
        return try await handleSessionTask(RepositoryList.self, request: request)
    }
}

class RepositoryManager {
    private let repositoryFetchProtocol: RepositoryFetchPorotocol

    init(repositoryFetchProtocol: RepositoryFetchPorotocol) {
        self.repositoryFetchProtocol = repositoryFetchProtocol
    }

    func getAPIResult(perPage: Int, searchword: String) async -> APIResult {
        do {
            let repositoryList = try await repositoryFetchProtocol.fetchRepository(perPage: perPage, searchword: searchword)
            return APIResult.update(repositoryList)
        } catch let error as APIError {
            if error == .notModified {
                return APIResult.doNothing
            }
            return APIResult.retry
        } catch {
            return APIResult.retry
        }
    }
}
