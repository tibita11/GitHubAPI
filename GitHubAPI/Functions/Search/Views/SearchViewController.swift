//
//  SearchViewController.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/12.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    private var searchBar: UISearchBar!
    private let searchHistoryCollectionHeaderView = UIView()

    private let introductionView = UIView()
    private var introductionViewInitialTopConstraint: NSLayoutConstraint!
    private var introductionViewMovedTopConstraint: NSLayoutConstraint!
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SearchHistorySection, String>!

    private var heightToNavBar: CGFloat {
        var height: CGFloat = 0
        if let navigationController = self.parent?.navigationController {
            let navBarMaxY = navigationController.navigationBar.frame.maxY
            height = navBarMaxY
        }
        return height
    }
    private var heightToTabBar: CGFloat {
        self.tabBarController?.tabBar.bounds.height ?? 0
    }
    /// レイアウト処理は一度のみ実行
    private lazy var initViewLayout: Void = {
        setUpLayout()
    }()
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    
    // MARK: - View Life Cycle
    
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
        // MEMO: UserDefaultsが更新された場合に実行される
        viewModel.outputs.application
            .do { [weak self] value in
                // MEMO: 値がある場合のみ表示する
                self?.showCollectionView(bool: value.first != nil)
            }
            .drive(onNext: { [weak self] value in
                guard let self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<SearchHistorySection, String>()
                snapshot.appendSections([.main])
                snapshot.appendItems(value, toSection: .main)
                dataSource.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)
        // 初期データを入れるため、バインド後に実行
        viewModel.setUp()
    }
    
    @objc private func tapClearButton() {
        viewModel.clearSearchHistory()
    }
    
    /// CollectionViewの表示・非表示をanimationを使用して切り替える
    private func showCollectionView(bool: Bool) {
        // コンフリクトを起こす可能性があるので、isActiveの設定を明示的な順序で行う
        if bool {
            introductionViewInitialTopConstraint.isActive = !bool
            introductionViewMovedTopConstraint.isActive = bool
        } else {
            introductionViewMovedTopConstraint.isActive = !bool
            introductionViewInitialTopConstraint.isActive = bool
        }
        
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self else { return }
            view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self else { return }
            introductionView.alpha = bool ? 0 : 1
            searchHistoryCollectionHeaderView.alpha = bool ? 1 : 0
            collectionView.alpha = bool ? 1 : 0
        }
    }
    
    
    // MARK: - Layout
    
    private func setUpLayout() {
        self.view.backgroundColor = .systemGray6
        
        setUpSearchBar()
        setUpSearchHistoryCollectionHeaderView()
        setUpIntroductionView()
        setUpCollectionView()
        setUpCollectionViewDataSource()
    }
    
    private func setUpSearchBar() {
        // NavigationBar上に設置
        if let navigationBarFrame = self.parent?.navigationController?.navigationBar.bounds,
        let navigationItem = self.parent?.navigationItem {
            let searchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.placeholder = "Search repository"
            searchBar.showsCancelButton = true
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            searchBar.delegate = self
            self.searchBar = searchBar
        }
    }
    
    private func setUpSearchHistoryCollectionHeaderView() {
        // クリアボタン設定
        let clearButton = UIButton()
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(tapClearButton), for: .touchUpInside)
        clearButton.setTitleColor(UIColor.tintColor, for: .normal)
        clearButton.titleLabel?.font = Const.textFont
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        searchHistoryCollectionHeaderView.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            clearButton.topAnchor.constraint(equalTo: searchHistoryCollectionHeaderView.topAnchor),
            clearButton.rightAnchor.constraint(equalTo: searchHistoryCollectionHeaderView.rightAnchor),
            clearButton.bottomAnchor.constraint(equalTo: searchHistoryCollectionHeaderView.bottomAnchor),
            clearButton.widthAnchor.constraint(equalTo: clearButton.heightAnchor, multiplier: 1)
        ])
        // ラベル設定
        let label = UILabel()
        label.text = "Recent searches"
        label.font = Const.titleFont
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        searchHistoryCollectionHeaderView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: searchHistoryCollectionHeaderView.topAnchor),
            label.leftAnchor.constraint(equalTo: searchHistoryCollectionHeaderView.leftAnchor, constant: 30),
            label.rightAnchor.constraint(equalTo: clearButton.leftAnchor),
            label.bottomAnchor.constraint(equalTo: searchHistoryCollectionHeaderView.bottomAnchor)
        ])
        // HeaderViewの設定
        searchHistoryCollectionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(searchHistoryCollectionHeaderView)
        
        NSLayoutConstraint.activate([
            searchHistoryCollectionHeaderView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: heightToNavBar),
            searchHistoryCollectionHeaderView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            searchHistoryCollectionHeaderView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            searchHistoryCollectionHeaderView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setUpIntroductionView() {
        // ラベル設定
        let titleLabel = UILabel()
        titleLabel.text = "Let's search!"
        titleLabel.font = Const.titleFont
        let textLabel = UILabel()
        textLabel.text = "You can search the repository."
        textLabel.font = Const.textFont
        // ラベルをまとめる
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        introductionView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: introductionView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: introductionView.centerXAnchor)
        ])
        // IntroductionViewの設定
        introductionView.alpha = 0
        introductionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(introductionView)
        
        NSLayoutConstraint.activate([
            introductionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            introductionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            introductionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                     constant: -heightToTabBar)
        ])
    }
    
    private func setUpCollectionView() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.backgroundColor = .systemGray6
        configuration.trailingSwipeActionsConfigurationProvider = { indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
                guard let self else { return }
                viewModel.deleteSearchHistory(row: indexPath.row)
                completion(true)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(frame: .null, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        // animationを実行するため、プロパティとして保持する
        introductionViewInitialTopConstraint = introductionView.topAnchor.constraint(equalTo: searchHistoryCollectionHeaderView.bottomAnchor)
        introductionViewMovedTopConstraint = introductionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: heightToNavBar)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchHistoryCollectionHeaderView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                   constant: -heightToTabBar)
        ])
    }
    
    private func setUpCollectionViewDataSource() {
        let searchHistoryCellRegistration = UICollectionView.CellRegistration<SearchHistoryCollectionViewCell, String> { cell, indexPath, value in
            cell.titleLabel.text = value
        }
        
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                return collectionView.dequeueConfiguredReusableCell(using: searchHistoryCellRegistration, for: indexPath, item: itemIdentifier)
            })
    }
}


// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        let vc = SearchResultViewController(searchWord: text)
        self.parent?.navigationController?.pushViewController(vc, animated: true)
        
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.saveSearchHistory(value: text)
    }
}


// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // MEMO: タップしたWordでAPI検索処理開始
        guard let searchWord = viewModel.getSearchWord(row: indexPath.row) else {
            return
        }
        let vc = SearchResultViewController(searchWord: searchWord)
        self.parent?.navigationController?.pushViewController(vc, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
