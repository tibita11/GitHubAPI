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
    private var introductionViewTopConstraint: NSLayoutConstraint!
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout())
    
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
        
        setUpViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        _ = initViewLayout
    }
    
    
    // MARK: - Action
    
    private func setUpViewModel() {
        // collectionView設定
        collectionView.register(SearchHistoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: "searchHistoryCell")
        viewModel.outputs.collectionViewItem
            .drive(collectionView.rx.items(cellIdentifier: "searchHistoryCell",
                                           cellType: SearchHistoryCollectionViewCell.self)) { row, element, cell in
                cell.titleLabel.text = element
            }
            .disposed(by: disposeBag)
        
        // データ取得処理、バインド後に行う
        viewModel.initialSetUp()
    }
    
    @objc private func tapClearButton() {
        introductionViewTopConstraint.isActive = false
        introductionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: heightToNavBar).isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self else { return }
            view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0) { [weak self] in
            guard let self else { return }
            introductionView.alpha = 1
            searchHistoryCollectionHeaderView.alpha = 0
            collectionView.alpha = 0
        }
    }
    
    
    // MARK: - Layout
    
    private func setUpLayout() {
        self.view.backgroundColor = .systemGray6
        
        setUpSearchBar()
        setUpSearchHistoryCollectionHeaderView()
        setUpIntroductionView()
        setUpCollectionView()
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
        
        introductionViewTopConstraint = introductionView.topAnchor.constraint(equalTo: searchHistoryCollectionHeaderView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            introductionViewTopConstraint,
            introductionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            introductionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            introductionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                     constant: -heightToTabBar)
        ])
    }
    
    private func setUpCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray6
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.view.bounds.width, height: 50)
        flowLayout.minimumLineSpacing = 1.0
        collectionView.collectionViewLayout = flowLayout
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchHistoryCollectionHeaderView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                   constant: -heightToTabBar)
        ])
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
        viewModel.saveSearchHistory(value: text)
    }
}
