//
//  NetworkingAPIType.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/2/24.
//  Copyright © 2024 test.tuist. All rights reserved.
//

import Foundation
import Alamofire

public protocol NetworkingAPIType {
    
    var baseURL: URL { get }
    
    var path: String? { get }
    
    var method: HTTPMethod { get }
    
    var headers: HTTPHeaders? { get }
    
    var bodyData: Parameters? { get }
    
    var parameters: Parameters? { get }
    
    var route: URL { get }
}

public extension NetworkingAPIType {
    var route: URL {
        guard let path = path else { return baseURL }
        return baseURL.appendingPathComponent(path)
    }
}
