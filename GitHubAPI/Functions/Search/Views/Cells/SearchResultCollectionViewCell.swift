//
//  SearchResultCollectionViewCell.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/15.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    private let largeStackView = UIStackView()
    private let ownerStackView = UIStackView()
    private let mediumStackView = UIStackView()
    private let starStackView = UIStackView()
    let ownerImageView = UIImageView()
    let ownerNameLabel = UILabel()
    let repositoryNameLabel = UILabel()
    let aboutLabel = UILabel()
    let starCountLabel = UILabel()
    let languageLabel = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Action
    
    
    // MARK: - Layout
    
    private func setUpLayout() {
        self.contentView.backgroundColor = .systemBackground
        
        setUpLargeStackView()
        setUpOwnerStackView()
        setUpOwnerImageView()
        setUpOwnerNameLabel()
        setUpRepositoryNameLabel()
        setUpAboutLabel()
        setUpMediumStackView()
        setUpStarStackView()
        setUpStarCountLabel()
        setUpLanguageLabel()
    }
    
    private func setUpLargeStackView() {
        largeStackView.translatesAutoresizingMaskIntoConstraints = false
        largeStackView.addArrangedSubview(ownerStackView)
        largeStackView.addArrangedSubview(repositoryNameLabel)
        largeStackView.addArrangedSubview(aboutLabel)
        largeStackView.addArrangedSubview(mediumStackView)
        largeStackView.axis = .vertical
        largeStackView.spacing = 10
        largeStackView.alignment = .fill
        largeStackView.distribution = .fill
        self.contentView.addSubview(largeStackView)
        
        // MEMO: UICollectionViewCellの自動的に追加される制約とコンフリクトするため優先度を下げる
        let bottomAnchor = largeStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        bottomAnchor.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            largeStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            largeStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            largeStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            bottomAnchor
        ])
    }
    
    private func setUpOwnerStackView() {
        ownerStackView.translatesAutoresizingMaskIntoConstraints = false
        ownerStackView.addArrangedSubview(ownerImageView)
        ownerStackView.addArrangedSubview(ownerNameLabel)
        ownerStackView.axis = .horizontal
        ownerStackView.spacing = 5
        ownerStackView.alignment = .fill
        ownerStackView.distribution = .fill
        
        // MEMO: UICollectionViewCellの自動的に追加される制約とコンフリクトするため優先度を下げる
        let heightAnchor = ownerStackView.heightAnchor.constraint(equalToConstant: 25)
        heightAnchor.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            ownerStackView.topAnchor.constraint(equalTo: largeStackView.topAnchor),
            ownerStackView.leadingAnchor.constraint(equalTo: largeStackView.leadingAnchor),
            ownerStackView.trailingAnchor.constraint(equalTo: largeStackView.trailingAnchor),
            heightAnchor
        ])
    }

    private func setUpOwnerImageView() {
        ownerImageView.translatesAutoresizingMaskIntoConstraints = false
        ownerImageView.image = UIImage(systemName: "apple.logo")
        ownerImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            ownerImageView.topAnchor.constraint(equalTo: ownerStackView.topAnchor),
            ownerImageView.leadingAnchor.constraint(equalTo: ownerStackView.leadingAnchor),
            ownerImageView.bottomAnchor.constraint(equalTo: ownerStackView.bottomAnchor),
            ownerImageView.widthAnchor.constraint(equalTo: ownerImageView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func setUpOwnerNameLabel() {
        ownerNameLabel.textAlignment = .left
        ownerNameLabel.font = UIFont.systemFont(ofSize: 12)
    }
    
    private func setUpRepositoryNameLabel() {
        repositoryNameLabel.textAlignment = .left
        repositoryNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    private func setUpAboutLabel() {
        aboutLabel.textAlignment = .left
        aboutLabel.font = UIFont.systemFont(ofSize: 16)
        aboutLabel.numberOfLines = 0
    }
    
    private func setUpMediumStackView() {
        mediumStackView.addArrangedSubview(starStackView)
        mediumStackView.addArrangedSubview(languageLabel)
        mediumStackView.axis = .horizontal
        mediumStackView.spacing = 10
        mediumStackView.alignment = .leading
        mediumStackView.distribution = .fill
        
        // MEMO: UICollectionViewCellの自動的に追加される制約とコンフリクトするため優先度を下げる
        let heightAnchor = mediumStackView.heightAnchor.constraint(equalToConstant: 20)
        heightAnchor.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            mediumStackView.leadingAnchor.constraint(equalTo: largeStackView.leadingAnchor),
            mediumStackView.trailingAnchor.constraint(equalTo: largeStackView.trailingAnchor),
            mediumStackView.bottomAnchor.constraint(equalTo: largeStackView.bottomAnchor),
            heightAnchor
        ])
    }
    
    private func setUpStarStackView() {
        let starImageView = UIImageView(image: UIImage(systemName: "star"))
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        starImageView.tintColor = .systemGray
        starStackView.addArrangedSubview(starImageView)
        starStackView.addArrangedSubview(starCountLabel)
        starStackView.axis = .horizontal
        starStackView.spacing = 5
        starStackView.alignment = .leading
        starStackView.distribution = .fill
        
        // ImageViewの配置
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(equalTo: starStackView.topAnchor),
            starImageView.leadingAnchor.constraint(equalTo: starStackView.leadingAnchor),
            starImageView.bottomAnchor.constraint(equalTo: starStackView.bottomAnchor),
            starImageView.widthAnchor.constraint(equalTo: starImageView.heightAnchor, multiplier: 1)
        ])
    }
    
    private func setUpStarCountLabel() {
        starCountLabel.textAlignment = .left
        starCountLabel.font = UIFont.systemFont(ofSize: 16)
        starCountLabel.textColor = .systemGray
        starCountLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private func setUpLanguageLabel() {
        languageLabel.textAlignment = .left
        languageLabel.font = UIFont.systemFont(ofSize: 16)
        languageLabel.textColor = .systemGray
    }
    
}
