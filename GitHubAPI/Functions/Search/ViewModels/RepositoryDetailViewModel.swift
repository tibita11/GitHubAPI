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
    
    func getReadme(owner: String, repo: String) {
        isLoadingRelay.accept(true)
        
        Task {
            do {
                let readme = try await APIRequestManager().getReadme(owner: owner, repo: repo)
                isLoadingRelay.accept(false)
                urlRelay.accept(readme.url)
            } catch {
                // MEMO: 取得できない場合、何もしない
                isLoadingRelay.accept(false)
                isWarnigRelay.accept(true)
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
    
    var isLoading: Driver<Bool> {
        isLoadingRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    var isWarnig: Driver<Bool> {
        isWarnigRelay.asDriver(onErrorDriveWith: .empty())
    }
}
