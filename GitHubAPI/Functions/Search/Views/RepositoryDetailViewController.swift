//
//  RepositoryDetailViewController.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/29.
//

import UIKit

class RepositoryDetailViewController: UIViewController {
    
    private let repository: Repository!
    
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
    
    // MARK: - Action
    
    
    // MARK: - Layout
    
    private func setUpLayout() {
        self.view.backgroundColor = .systemBackground
    }
}
