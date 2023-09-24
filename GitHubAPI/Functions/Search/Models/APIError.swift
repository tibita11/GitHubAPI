//
//  APIError.swift
//  GitHubAPI
//
//  Created by 鈴木楓香 on 2023/09/24.
//

import Foundation

enum APIError: LocalizedError {
    case decodeFailed
    case validationFailed
    case notModified
    case serviceUnavailable
    case unknownError
    case resurceNotFound
}
