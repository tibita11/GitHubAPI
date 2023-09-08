//
//  SearchResultViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/15.
//

import Foundation
import RxCocoa
import RxSwift

// MEMO: API接続が複数回行われないように状態を保持する
private enum LoadStatus {
    case initial
    case fetching
    case loadmore
    case full
    case error
}

protocol SearchResultViewModelOutputs {
    var application: Driver<[Repository]> { get }
    var retryView: Driver<Bool> { get }
    var isLoading: Driver<Bool> { get }
}

protocol SearchResultViewModelType {
    var outputs: SearchResultViewModelOutputs { get }
}

class SearchResultViewModel: SearchResultViewModelType {
    var outputs: SearchResultViewModelOutputs { self }
    private let searchResults = BehaviorRelay<[Repository]>(value: [])
    private let isRetry = PublishRelay<Bool>()
    private var pageCount = 1
    private var loadStatus: LoadStatus = .initial
    private let isLoadingRelay = PublishRelay<Bool>()
    private let repositoryManager: RepositoryManager = .init(repositoryFetchProtocol: RepositoryFetcher())

    // MARK: - Action

    func search(searchWord: String) {
        guard loadStatus != .fetching, loadStatus != .full else {
            // MEMO: 取得中と、すでにデータが表示されている場合は何もしない
            return
        }
        loadStatus = .fetching
        isRetry.accept(false)
        // MEMO: 今のカウント数が0の場合、ローディング画面を表示する
        if searchResults.value.first == nil {
            isLoadingRelay.accept(true)
        }
        // MEMO: API通信を行い、結果をバインドする
        Task {
            let result = await repositoryManager.getAPIResult(
                perPage: pageCount,
                searchword: searchWord
            )
            // MEMO: 結果をバインド
            switch result {
            case let .update(value):
                // MEMO: 新しく取得したデータは既存データに追加する
                guard let repositoryList = value as? RepositoryList else { return }
                var oldValue = searchResults.value
                oldValue += repositoryList.items
                isLoadingRelay.accept(false)
                searchResults.accept(oldValue)
                pageCount += 1
                // MEMO: nullの場合すでにデータが表示されているとみなす
                loadStatus = repositoryList.items.first == nil ? .full : .loadmore
            case .doNothing:
                loadStatus = .full
            case .retry:
                // MEMO: 再試行ボタンを表示する
                isLoadingRelay.accept(false)
                isRetry.accept(true)
                loadStatus = .error
            }
        }
    }

    func getRepository(row: Int) -> Repository {
        let value = searchResults.value
        return value[row]
    }
}

// MARK: - SearchResultViewModelOutputs

extension SearchResultViewModel: SearchResultViewModelOutputs {
    var application: Driver<[Repository]> {
        searchResults.asDriver(onErrorDriveWith: .empty())
    }

    var retryView: Driver<Bool> {
        isRetry.asDriver(onErrorDriveWith: .empty())
    }

    var isLoading: Driver<Bool> {
        isLoadingRelay.asDriver(onErrorDriveWith: .empty())
    }
}
