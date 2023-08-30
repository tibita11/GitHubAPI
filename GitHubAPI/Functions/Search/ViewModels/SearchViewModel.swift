//
//  SearchViewModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/13.
//

import Foundation
import RxSwift
import RxCocoa

enum SearchHistorySection {
    case main
}

protocol SearchViewModelOutputs {
    var application: Driver<[String]> { get }
}

protocol SearchViewModelType {
    var outputs: SearchViewModelOutputs { get }
}

class SearchViewModel: SearchViewModelType {
    var outputs: SearchViewModelOutputs { self }
    private let searchHistoryManager = SearchHistoryManager()
    private var observer: NSKeyValueObservation?
    private let searchHistory = PublishRelay<[String]>()

    
    // MARK: - Action
    
    func setUp() {
        observer = UserDefaults.standard.observe(
            \.searchHistory,
             options: [.initial, .new],
             changeHandler: { [weak self] userDefaults, changeValue in
                 // MEMO: 変更後の値をUIとバインド
                 self?.searchHistory.accept(changeValue.newValue ?? [])
             })
    }
    
    func saveSearchHistory(value: String) {
        if let searchHistory = searchHistoryManager.getSearchHistory() {
            // MEMO: 重複がある場合、何もしない
            guard !searchHistory.contains(value) else {
                return
            }
            // MEMO: 配列を保存
            let newValue = searchHistory + [value]
            searchHistoryManager.saveSearchHistory(value: newValue)
        } else {
            // MEMO: 登録がない場合、そのまま保存
            searchHistoryManager.saveSearchHistory(value: [value])
        }
    }
    
    func deleteSearchHistory(row: Int) {
        searchHistoryManager.deleteSearchHistory(row: row)
    }
    
    func clearSearchHistory() {
        searchHistoryManager.deleteAllSearchHistory()
    }
    
    func getSearchWord(row: Int) -> String? {
        guard let searchHistory = searchHistoryManager.getSearchHistory() else {
            return nil
        }
        return searchHistory[row]
    }
}


// MARK: - SearchViewModelOutputs

extension SearchViewModel: SearchViewModelOutputs {
    var application: Driver<[String]> {
        searchHistory.asDriver(onErrorDriveWith: .empty())
    }
}


// MARK: - UserDefaults

extension UserDefaults {
    @objc dynamic var searchHistory: [String] {
        return array(forKey: Const.searchHistoryKey) as? [String] ?? []
    }
}
