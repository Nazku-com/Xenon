//
//  NetworkingServiceType.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/2/24.
//  Copyright © 2024 test.tuist. All rights reserved.
//

import Foundation

public protocol NetworkingServiceType {
    
    func request<T: NetworkingDTOType>(api: NetworkingAPIType, dtoType: T.Type) async -> Result<T.EntityType, NetworkingServiceError>
    func request(api: NetworkingAPIType) async -> Result<Data, Error>
}

public enum NetworkingServiceError: Error {
    
    case uploadDataNotFound
    case parseEntityError
    case jsonParsingFailed(Error)
    case networkError(String)
    case asError(Error)
}
