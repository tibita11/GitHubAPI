//
//  SearchResultViewController.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/15.
//

import Kingfisher
import RxCocoa
import RxSwift
import UIKit

class SearchResultViewController: UIViewController {
    private let searchWord: String!
    /// 検索結果がない場合に表示するView
    private var noDataWarnigView: UIView!
    /// 検索結果がエラーの場合に表示するView
    private var retryView: UIView!
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<RepositorySection, Repository>!
    private var activityIndicatorView: UIActivityIndicatorView!
    private let viewModel = SearchResultViewModel()
    private let disposeBag = DisposeBag()
    // MEMO: 初期化時のみ実行する処理
    private lazy var initViewLayout: Void = {
        setUpLayout()
        setUpViewModel()
    }()

    private var heightToNavBar: CGFloat {
        var height: CGFloat = 0
        if let navigationController {
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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
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
    }

    // MARK: - Action

    private func setUpViewModel() {
        viewModel.outputs.application
            // MEMO: 初期値はスキップ
            .skip(1)
            .do { [weak self] repositories in
                // MEMO: 検索結果が0の場合はViewを表示する
                if repositories.first == nil {
                    self?.showNoDataWarnigView()
                }
            }
            .drive(onNext: { [weak self] repositories in
                var snapshot = NSDiffableDataSourceSnapshot<RepositorySection, Repository>()
                snapshot.appendSections([.main])
                snapshot.appendItems(repositories)
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.retryView
            .drive(onNext: { [weak self] isRetry in
                // MEMO: 検索結果がエラーの場合は再試行ボタンを表示する
                self?.showRetryView(isRetry)
            })
            .disposed(by: disposeBag)
        // MEMO: ローディング画面を表示するか否か
        viewModel.outputs.isLoading
            .drive(onNext: { [weak self] bool in
                self?.changeActivityIndicatiorStatus(bool)
            })
            .disposed(by: disposeBag)

        // MEMO: 初期データ取得のためバインド後に実行
        viewModel.search(searchWord: searchWord)
    }

    private func showNoDataWarnigView() {
        noDataWarnigView.isHidden = false
        // MEMO: isHiddenはアニメーションができないためalphを変更する
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.noDataWarnigView.alpha = 1
        }
    }

    private func showRetryView(_ bool: Bool) {
        retryView.isHidden = !bool
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.retryView.alpha = bool ? 1 : 0
        }
    }

    @objc private func tapRetryButton() {
        viewModel.search(searchWord: searchWord)
    }

    /// trueの場合、表示して動かす・falseの場合、非表示して止める
    private func changeActivityIndicatiorStatus(_ bool: Bool) {
        activityIndicatorView.isHidden = !bool
        bool ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
    }

    // MARK: - Layout

    private func setUpLayout() {
        view.backgroundColor = .systemGray6

        setUpCollectionView()
        setUpDataSource()
        setUpNoDataWarnigView()
        setUpRetryView()
        setUpActivityIndicatorView()
    }

    private func setUpCollectionView() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView = UICollectionView(frame: .null, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: heightToNavBar),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setUpDataSource() {
        let searchResultCellRegistration = UICollectionView.CellRegistration<SearchResultCollectionViewCell, Repository> { cell, _, result in
            cell.repositoryNameLabel.text = result.name
            cell.ownerNameLabel.text = result.owner.login
            cell.ownerImageView.kf.setImage(with: URL(string: result.owner.avatarURL))
            cell.aboutLabel.text = result.description
            cell.starCountLabel.text = String(result.starCount)
            cell.languageLabel.text = result.language
        }

        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                collectionView.dequeueConfiguredReusableCell(using: searchResultCellRegistration, for: indexPath, item: itemIdentifier)
            }
        )
    }

    private func setUpNoDataWarnigView() {
        noDataWarnigView = UIView()
        noDataWarnigView.backgroundColor = .systemGray6
        noDataWarnigView.translatesAutoresizingMaskIntoConstraints = false
        // MEMO: リポジトリ検索結果がない場合のみ表示するため初期値は0に設定する
        noDataWarnigView.alpha = 0
        noDataWarnigView.isHidden = true
        view.addSubview(noDataWarnigView)

        NSLayoutConstraint.activate([
            noDataWarnigView.topAnchor.constraint(equalTo: view.topAnchor),
            noDataWarnigView.leftAnchor.constraint(equalTo: view.leftAnchor),
            noDataWarnigView.rightAnchor.constraint(equalTo: view.rightAnchor),
            noDataWarnigView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        // MEMO: View中央の文言を設定する
        let label = UILabel()
        label.text = "No repository"
        label.font = Const.titleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        noDataWarnigView.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: noDataWarnigView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: noDataWarnigView.centerYAnchor),
        ])
    }

    private func setUpRetryView() {
        retryView = UIView()
        retryView.backgroundColor = .systemGray6
        // MEMO: 検索結果がエラーの場合のみ表示するため初期値は0に設定する
        retryView.alpha = 0
        retryView.isHidden = true
        retryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(retryView)

        NSLayoutConstraint.activate([
            retryView.topAnchor.constraint(equalTo: view.topAnchor),
            retryView.leftAnchor.constraint(equalTo: view.leftAnchor),
            retryView.rightAnchor.constraint(equalTo: view.rightAnchor),
            retryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        // MEMO: View中央の文言を設定する
        let label = UILabel()
        label.text = "問題が発生しました"
        label.textAlignment = .center
        label.font = Const.titleFont
        // MEMO: View中央の再試行ボタンを設定する
        let button = UIButton(configuration: .tinted())
        button.setTitle("やり直す", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(tapRetryButton), for: .touchUpInside)
        // MRMO: LabelとButtonをStackViewでまとめて中央に配置
        let stackView = UIStackView()
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        retryView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: retryView.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: retryView.centerXAnchor),
        ])
    }

    private func setUpActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.isHidden = true
        view.addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - UICollectionViewDelegate

extension SearchResultViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        let distanceToBottom = maximumOffset - currentOffsetY

        if distanceToBottom < 500 {
            viewModel.search(searchWord: searchWord)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // MEMO: タップした行の詳細を表示する
        let repository = viewModel.getRepository(row: indexPath.row)
        let vc = RepositoryDetailViewController(repository: repository)
        navigationController?.pushViewController(vc, animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
