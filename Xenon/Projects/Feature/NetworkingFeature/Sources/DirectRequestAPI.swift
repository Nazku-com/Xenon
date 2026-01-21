//
//  DirectRequestAPI.swift
//  NetworkingFeature
//
//  Created by 김수환 on 9/23/25.
//  Copyright © 2025 test.tuist. All rights reserved.
//

import Foundation

public struct DirectRequestAPI: NetworkingAPIType {
    
    public let baseURL: URL
    public let path: String? = nil
    public let method: HttpMethod
    
    public var headers: [String: String]
    public var queryItems: [URLQueryItem]
    public var body: [String: Any]
    public var uploadData: MultipartFormData?
    
    public init(
        baseURL: URL,
        method: HttpMethod,
        headers: [String : String] = [:],
        queryItems: [URLQueryItem] = [],
        body: [String : Any] = [:],
        uploadData: MultipartFormData? = nil
    ) {
        self.baseURL = baseURL
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
        self.uploadData = uploadData
    }
}
