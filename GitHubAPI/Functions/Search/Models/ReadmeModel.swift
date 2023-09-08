//
//  ReadmeModel.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/08/30.
//

import Foundation

struct Readme: Decodable {
    let url: String

    private enum CodingKeys: String, CodingKey {
        case url = "html_url"
    }
}
