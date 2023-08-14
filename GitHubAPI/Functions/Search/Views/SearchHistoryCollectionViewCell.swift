//
//  SearchHistoryCollectionViewCell.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/14.
//

import UIKit

class SearchHistoryCollectionViewCell: UICollectionViewCell {
    private var searchButton: UIButton = UIButton()
    var titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc private func tapSearchButton() {
        
    }
    
    // MARK: - Layout
    
    private func setUpLayout() {
        self.contentView.backgroundColor = .systemBackground
        
        setUpSearchButton()
        setUpTitleLable()
    }
    
    private func setUpTitleLable() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        // 自動計算される高さとコンフリクトしてしまうため、優先度を下げる
        let heightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 50)
        heightConstraint.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: searchButton.leftAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            heightConstraint
        ])
    }
    
    private func setUpSearchButton() {
        searchButton.setImage(UIImage(systemName: "arrow.up.left"), for: .normal)
        searchButton.contentMode = .scaleAspectFit
        searchButton.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            searchButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            searchButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor, multiplier: 1)
        ])
    }
}
