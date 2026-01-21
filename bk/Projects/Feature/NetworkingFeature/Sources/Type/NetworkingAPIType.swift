//
//  NetworkingAPIType.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/2/24.
//  Copyright © 2024 test.tuist. All rights reserved.
//

import Foundation

public struct MultipartFormData {
    
    let fileName: String
    let mimeType: String
    let data: Data
    
    public init(fileName: String, mimeType: String, data: Data) {
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
}

public enum HttpMethod: String {
    
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}


public protocol NetworkingAPIType {
    
    var baseURL: URL { get }
    var path: String? { get }
    var method: HttpMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var uploadData: MultipartFormData? { get }
    var body: [String: Any] { get }
}

public extension NetworkingAPIType {
    
    var route: URL {
        guard let path = path else { return baseURL }
        return baseURL.appendingPathComponent(path)
    }
}
