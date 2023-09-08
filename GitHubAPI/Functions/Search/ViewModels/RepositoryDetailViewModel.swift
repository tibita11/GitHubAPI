//
//  RepositoryDetailViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/30.
//

import Foundation
import RxCocoa
import RxSwift

protocol RepositoryDetailViewModelOutput {
    var urlDriver: Driver<String> { get }
    var isLoading: Driver<Bool> { get }
    var isWarnig: Driver<Bool> { get }
}

protocol RepositoryDetailViewModelType {
    var outputs: RepositoryDetailViewModelOutput { get }
}

class RepositoryDetailViewModel: RepositoryDetailViewModelType {
    var outputs: RepositoryDetailViewModelOutput { self }
    private let urlRelay = PublishRelay<String>()
    private let isLoadingRelay = PublishRelay<Bool>()
    private let isWarnigRelay = PublishRelay<Bool>()
    private let readmeManager = ReadmeManager(readmeFetchProtocol: ReadmeFetcher())

    func getReadme(owner: String, repo: String) {
        isLoadingRelay.accept(true)

        Task {
            let result = await readmeManager.getAPIResult(owner: owner, repo: repo)
            // MEMO: 結果をバインド
            switch result {
            case let .update(value):
                guard let readme = value as? Readme else {
                    assertionFailure("取得した値がReadme型に変換できませんでした。")
                    return
                }
                isLoadingRelay.accept(false)
                urlRelay.accept(readme.url)
            default:
                // MEMO: 取得できない場合、警告表示
                isLoadingRelay.accept(false)
                isWarnigRelay.accept(true)
            }
        }
    }
}

// MARK: - RepositoryDetailViewModelOutput

extension RepositoryDetailViewModel: RepositoryDetailViewModelOutput {
    var urlDriver: Driver<String> {
        urlRelay.asDriver(onErrorDriveWith: .empty())
    }

    var isLoading: Driver<Bool> {
        isLoadingRelay.asDriver(onErrorDriveWith: .empty())
    }

    var isWarnig: Driver<Bool> {
        isWarnigRelay.asDriver(onErrorDriveWith: .empty())
    }
}
