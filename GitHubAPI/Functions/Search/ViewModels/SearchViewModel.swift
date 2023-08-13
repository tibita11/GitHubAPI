//
//  SearchViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/13.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchViewModelOutputs {
    var collectionViewItem: Driver<[String]> { get }
}

protocol SearchViewModelType {
    var outputs: SearchViewModelOutputs { get }
}

class SearchViewModel: SearchViewModelType {
    var outputs: SearchViewModelOutputs { self }
    private let userDefaults = UserDefaults.standard
    private var observer: NSKeyValueObservation?
    private let searchHistory = PublishRelay<[String]>()
    
    // MARK: - Action
    
    func initialSetUp() {
        observer = userDefaults.observe(\.searchHistory, options: [.initial, .new], changeHandler: { [weak self] userDefaults, changeValue in
            guard let self else { return }
            
            if let newValue = changeValue.newValue {
                searchHistory.accept(newValue)
            } else {
                
            }
        })
    }
    
    func saveSearchHistory(value: String) {
        let searchHistory = userDefaults.array(forKey: Const.searchHistoryKey) as? [String] ?? []
        let updatedHistory = searchHistory + [value]
        userDefaults.set(updatedHistory, forKey: Const.searchHistoryKey)
    }
}


// MARK: - SearchViewModelOutputs

extension SearchViewModel: SearchViewModelOutputs {
    var collectionViewItem: Driver<[String]> {
        searchHistory.asDriver(onErrorDriveWith: .empty())
    }
}


// MARK: - UserDefaults

extension UserDefaults {
    @objc dynamic var searchHistory: [String] {
        return array(forKey: Const.searchHistoryKey) as? [String] ?? []
    }
}
