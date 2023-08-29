//
//  SearchHistoryCollectionViewCell.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/14.
//

import UIKit

class SearchHistoryCollectionViewCell: UICollectionViewCell {
    private var imageView = UIImageView()
    var titleLabel = UILabel()
    
    override var isSelected: Bool {
        // MEMO: 選択時の色を変える
        didSet {
            contentView.backgroundColor = isSelected ? .systemGray6 : .systemBackground
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setUpLayout() {
        self.contentView.backgroundColor = .systemBackground
        
        setUpImageView()
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
            titleLabel.rightAnchor.constraint(equalTo: imageView.leftAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            heightConstraint
        ])
    }
    
    private func setUpImageView() {
        imageView.image = UIImage(systemName: "arrow.up.left")
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1)
        ])
    }
}
