//
//  SearchHistoryCollectionViewCell.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/14.
//

import UIKit

class SearchHistoryCollectionViewCell: UICollectionViewCell {
    private var searchButton: UIButton!
    var titleLabel: UILabel!
    
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
    
    private func setUpSearchButton() {
        searchButton = UIButton()
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
    
    private func setUpTitleLable() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: searchButton.leftAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
