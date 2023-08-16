//
//  SearchResultViewController.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/15.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultViewController: UIViewController {
    
    private let searchWord: String!
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SearchResultSection, SearchResult.ID>!
    private let viewModel = SearchResultViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var initViewLayout: Void = {
        setUpLayout()
    }()
    
    private var heightToNavBar: CGFloat {
        var height: CGFloat = 0
        if let navigationController = self.navigationController {
            let navBarMaxY = navigationController.navigationBar.frame.maxY
            height = navBarMaxY
        }
        return height
    }
    
    
    // MARK: - View Life Cycle
    
    init(searchWord: String) {
        self.searchWord = searchWord
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _ = initViewLayout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpViewModel()
    }
    
    
    // MARK: - Action
    
    private func setUpViewModel() {
        // snapshotをもらう処理を書く
        viewModel.outputs.application
            .drive(onNext: { [weak self] snapshot in
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
        // 初期データ取得
        viewModel.setUp()
    }
    
    
    // MARK: - Layout
    
    private func setUpLayout() {
        self.view.backgroundColor = .systemBackground
        
        setUpCollectionView()
        setUpDataSource()
    }
    
    private func setUpCollectionView() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(frame: .null, collectionViewLayout: layout)
        
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: heightToNavBar),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setUpDataSource() {
        let searchResultCellRegistration = UICollectionView.CellRegistration<SearchResultCollectionViewCell, SearchResult> { cell, indexPath, result in
            cell.ownerNameLabel.text = result.ownerName
            cell.repositoryNameLabel.text = result.repositoryName
            cell.aboutLabel.text = result.about
            cell.starCountLabel.text = result.starCount
            cell.languageLabel.text = result.language
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
                let searchResult = self?.viewModel.getSearchResult(id: itemIdentifier)
                return collectionView.dequeueConfiguredReusableCell(using: searchResultCellRegistration, for: indexPath, item: searchResult)
            })
    }
    
}
