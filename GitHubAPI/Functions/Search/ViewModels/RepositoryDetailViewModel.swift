//
//  RepositoryDetailViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/30.
//

import Foundation
import RxSwift
import RxCocoa

protocol RepositoryDetailViewModelOutput {
    var urlDriver: Driver<String> { get }
}

protocol RepositoryDetailViewModelType {
    var outputs: RepositoryDetailViewModelOutput { get }
}

class RepositoryDetailViewModel: RepositoryDetailViewModelType {
    var outputs: RepositoryDetailViewModelOutput { self }
    private let urlRelay = PublishRelay<String>()
    
    func getReadme(owner: String, repo: String) {
        Task {
            do {
                let readme = try await APIRequestManager().getReadme(owner: owner, repo: repo)
                urlRelay.accept(readme.url)
            } catch {
                // MEMO: 取得できない場合、何もしない
                print("Error: Failed to get README")
            }
        }
    }
}


// MARK: - RepositoryDetailViewModelOutput

extension RepositoryDetailViewModel: RepositoryDetailViewModelOutput {
    var urlDriver: Driver<String> {
        urlRelay.asDriver(onErrorDriveWith: .empty())
    }
}
