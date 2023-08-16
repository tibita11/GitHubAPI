//
//  SearchResultViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/15.
//

import Foundation
import RxSwift
import RxCocoa


enum SearchResultSection {
    case main
}

struct SearchResult: Identifiable {
    let id: UUID
    let ownerName: String
    let repositoryName: String
    let about: String
    let starCount: String
    let language: String
}

protocol SearchResultViewModelOutputs {
    var application: Driver<NSDiffableDataSourceSnapshot<SearchResultSection, SearchResult.ID>> { get }
}

protocol SearchResultViewModelType {
    var outputs: SearchResultViewModelOutputs { get }
}

class SearchResultViewModel: SearchResultViewModelType {
    var outputs: SearchResultViewModelOutputs { self }
    private var repository: SearchResultRepository = .init()
    private let snapshot = PublishRelay<NSDiffableDataSourceSnapshot<SearchResultSection, SearchResult.ID>>()
    
    
    // MARK: - Action
    
    func setUp() {
        snapshot.accept(getSnaphot())
    }
    
    func getSearchResult(id: SearchResult.ID) -> SearchResult? {
        return repository.getSearchResult(id: id)
    }
    
    private func getSnaphot() -> NSDiffableDataSourceSnapshot<SearchResultSection, SearchResult.ID> {
        var snapshot = NSDiffableDataSourceSnapshot<SearchResultSection, SearchResult.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(repository.searchResultIDs, toSection: .main)
        return snapshot
    }
    
    
}


// MARK: - SearchResultViewModelOutputs

extension SearchResultViewModel: SearchResultViewModelOutputs {
    var application: Driver<NSDiffableDataSourceSnapshot<SearchResultSection, SearchResult.ID>> {
        snapshot.asDriver(onErrorDriveWith: .empty())
    }
}
