//
//  SearchResultViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/15.
//

import Foundation
import RxSwift
import RxCocoa

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

    
    
    // MARK: - Action
    
    func search(searchWord: String) {
        guard loadStatus != .fetching, loadStatus != .full else {
            // MEMO: 取得中と、すでにデータが表示されている場合は何もしない
            return
        }
        loadStatus = .fetching
        isRetry.accept(false)
        // MEMO: API通信を行い、結果をバインドする
        Task {
            do {
                let repositories = try await APIRequestManager().getRepository(
                    perPage: pageCount,
                    searchword: searchWord
                )
                // MEMO: 新しく取得したデータは既存データに追加する
                var oldValue = searchResults.value
                oldValue += repositories.items
                searchResults.accept(oldValue)
                pageCount += 1
                // MEMO: nullの場合すでにデータが表示されているとみなす
                loadStatus = repositories.items.first == nil ? .full : .loadmore
            } catch let error as APIError {
                // MEMO: 変更がないとみなし、処理を行わない
                if error == .notModified {
                    loadStatus = .full
                    return
                }
                // MEMO: 再試行ボタンを表示する
                isRetry.accept(true)
                loadStatus = .error
            } catch {
                // MEMO: 再試行ボタンを表示する
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
    
}
