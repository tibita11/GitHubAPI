//
//  ReadmeManager.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/31.
//

import Foundation

protocol ReadmeFetchProtocol: APIRequestManagerProtocol {
    func fetchReadme(owner: String, repo: String) async throws -> Readme
}

/// 本番用のAPI接続クラス
class ReadmeFetcher: ReadmeFetchProtocol {
    func fetchReadme(owner: String, repo: String) async throws -> Readme {
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

class ReadmeManager {
    private let readmeFetchProtocol: ReadmeFetchProtocol
    
    init(readmeFetchProtocol: ReadmeFetchProtocol) {
        self.readmeFetchProtocol = readmeFetchProtocol
    }
    
    func getAPIResult(owner: String, repo: String) async -> APIResult {
        do {
            let readme = try await readmeFetchProtocol.fetchReadme(
                owner: owner,
                repo: repo
            )
            return APIResult.update(readme)
        } catch {
            return APIResult.retry
        }
    }
}
