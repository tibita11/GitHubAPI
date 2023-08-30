//
//  RepositoryDetailViewController.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/29.
//

import UIKit
import Kingfisher
import WebKit
import RxSwift
import RxCocoa

class RepositoryDetailViewController: UIViewController {
    
    private let repository: Repository!
    private let repositoryView = UIView()
    private let largeStackView = UIStackView()
    private let ownerStackView = UIStackView()
    private let avatarImageView = UIImageView()
    private let ownerNameLabel = UILabel()
    private let repositoryNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let countStackView = UIStackView()
    private let starStackView = UIStackView()
    private let forkStackView = UIStackView()
    private var webView: WKWebView!
    private var viewModel: RepositoryDetailViewModel!
    private let disposeBag = DisposeBag()
    
    private var heightToNavBar: CGFloat {
        var height: CGFloat = 0
        if let navigationController = self.navigationController {
            let navBarMaxY = navigationController.navigationBar.frame.maxY
            height = navBarMaxY
        }
        return height
    }
    
    private lazy var initViewLayout: Void = {
        setUpLayout()
    }()
    
    // MARK: - View Life Cycle
    
    init(repository: Repository) {
        self.repository = repository
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
        viewModel = RepositoryDetailViewModel()
        // MEMO: URLをwebViewに反映
        viewModel.outputs.urlDriver
            .drive(onNext: { [weak self] urlString in
                guard let self, let url = URL(string: urlString) else { return }
                webView.load(URLRequest(url: url))
            })
            .disposed(by: disposeBag)
        // MEMO: データ取得
        viewModel.getReadme(owner: repository.owner.login, repo: repository.name)
    }
    
    // MARK: - Layout
    
    private func setUpLayout() {
        self.view.backgroundColor = .systemGray6
        
        setUpRepositoryView()
        setUpLargeStackView()
        setUpOwnerStackView()
        setUpAvatarImageView()
        setUpOwnerNameLabel()
        setUpRepositoryNameLabel()
        setUpDescriptionLabel()
        setUpCountStackView()
        setUpStarStackView()
        setUpForkStackView()
        setUpReadmeView()
    }
    
    private func setUpRepositoryView() {
        repositoryView.backgroundColor = .systemBackground
        repositoryView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(repositoryView)
        
        NSLayoutConstraint.activate([
            repositoryView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: heightToNavBar),
            repositoryView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            repositoryView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        ])
    }
    
    private func setUpLargeStackView() {
        largeStackView.addArrangedSubview(ownerStackView)
        largeStackView.addArrangedSubview(repositoryNameLabel)
        largeStackView.addArrangedSubview(descriptionLabel)
        largeStackView.addArrangedSubview(countStackView)
        largeStackView.axis = .vertical
        largeStackView.spacing = 15
        largeStackView.alignment = .fill
        largeStackView.distribution = .fill
        largeStackView.translatesAutoresizingMaskIntoConstraints = false
        repositoryView.addSubview(largeStackView)
        
        NSLayoutConstraint.activate([
            largeStackView.topAnchor.constraint(equalTo: repositoryView.topAnchor, constant: 10),
            largeStackView.trailingAnchor.constraint(equalTo: repositoryView.trailingAnchor, constant: -10),
            largeStackView.leadingAnchor.constraint(equalTo: repositoryView.leadingAnchor, constant: 10),
            largeStackView.bottomAnchor.constraint(equalTo: repositoryView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setUpOwnerStackView() {
        ownerStackView.addArrangedSubview(avatarImageView)
        ownerStackView.addArrangedSubview(ownerNameLabel)
        ownerStackView.axis = .horizontal
        ownerStackView.spacing = 5
        ownerStackView.alignment = .fill
        ownerStackView.distribution = .fill
        ownerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ownerStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setUpAvatarImageView() {
        avatarImageView.kf.setImage(with: URL(string: repository.owner.avatarURL))
        avatarImageView.layer.cornerRadius = 5
        avatarImageView.layer.masksToBounds = true
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: ownerStackView.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: ownerStackView.leadingAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: ownerStackView.bottomAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func setUpOwnerNameLabel() {
        ownerNameLabel.text = repository.owner.login
        ownerNameLabel.textAlignment = .left
        ownerNameLabel.font = Const.smallTextFont
    }
    
    private func setUpRepositoryNameLabel() {
        repositoryNameLabel.text = repository.name
        repositoryNameLabel.textAlignment = .left
        repositoryNameLabel.font = Const.titleFont
    }
    
    private func setUpDescriptionLabel() {
        descriptionLabel.text = repository.description
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = Const.textFont
    }
    
    private func setUpCountStackView() {
        countStackView.addArrangedSubview(starStackView)
        countStackView.addArrangedSubview(forkStackView)
        countStackView.axis = .horizontal
        countStackView.spacing = 10
        countStackView.alignment = .fill
        countStackView.distribution = .fill
        countStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setUpStarStackView() {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let starCountLabel = UILabel()
        starCountLabel.text = String(repository.starCount)
        starCountLabel.textColor = .systemGray
        starCountLabel.textAlignment = .left
        starCountLabel.font = Const.textFont
        starCountLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        starStackView.addArrangedSubview(imageView)
        starStackView.addArrangedSubview(starCountLabel)
        starStackView.axis = .horizontal
        starStackView.spacing = 5
        starStackView.alignment = .fill
        starStackView.distribution = .fill
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: starStackView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: starStackView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: starStackView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func setUpForkStackView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Fork")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let forkCountLabel = UILabel()
        forkCountLabel.text = String(repository.forks)
        forkCountLabel.textColor = .systemGray
        forkCountLabel.textAlignment = .left
        forkCountLabel.font = Const.textFont
        
        forkStackView.addArrangedSubview(imageView)
        forkStackView.addArrangedSubview(forkCountLabel)
        forkStackView.axis = .horizontal
        forkStackView.spacing = 5
        forkStackView.alignment = .fill
        forkStackView.distribution = .fill
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: forkStackView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: forkStackView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: forkStackView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func setUpReadmeView() {
        let label = UILabel()
        label.text = "README"
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = Const.textFont
        label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: repositoryView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: label.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
