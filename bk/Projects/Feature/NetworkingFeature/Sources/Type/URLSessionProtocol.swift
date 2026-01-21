//
//  URLSessionProtocol.swift
//  NetworkingFeature
//
//  Created by 김수환 on 6/29/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation

public protocol URLSessionProtocol {
    
    func upload(for request: URLRequest, from bodyData: Data) async throws -> (Data, URLResponse)
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
