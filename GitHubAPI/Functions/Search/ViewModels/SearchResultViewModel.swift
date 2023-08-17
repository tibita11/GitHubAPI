//
//  SearchResultViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/15.
//

import Foundation
import RxSwift
import RxCocoa


protocol SearchResultViewModelOutputs {
    var application: Driver<[Repository]> { get }
    var retryView: Driver<Bool> { get }
}

protocol SearchResultViewModelType {
    var outputs: SearchResultViewModelOutputs { get }
}

class SearchResultViewModel: SearchResultViewModelType {
    var outputs: SearchResultViewModelOutputs { self }
    private let searchRsults = PublishRelay<[Repository]>()
    private let isRetry = PublishRelay<Bool>()

    
    
    // MARK: - Action
    
    func setUp(searchWord: String) {
        search(searchWord: searchWord)
    }
    
    func search(searchWord: String) {
        isRetry.accept(false)
        // MEMO: API通信を行い、結果をバインドする
        Task {
            do {
                let repositories = try await APIRequestManager().getRepository(
                    perPage: 1,
                    searchword: searchWord
                )
                searchRsults.accept(repositories.items)
            } catch let error as APIError {
                // MEMO: 変更がないとみなし、処理を行わない
                if error == .notModified {
                    return
                }
                // MEMO: 再試行ボタンを表示する
                isRetry.accept(true)
            } catch {
                // MEMO: 再試行ボタンを表示する
                isRetry.accept(true)
            }
        }
    }
}


// MARK: - SearchResultViewModelOutputs

extension SearchResultViewModel: SearchResultViewModelOutputs {
    var application: Driver<[Repository]> {
        searchRsults.asDriver(onErrorDriveWith: .empty())
    }
    
    var retryView: Driver<Bool> {
        isRetry.asDriver(onErrorDriveWith: .empty())
    }
    
}
