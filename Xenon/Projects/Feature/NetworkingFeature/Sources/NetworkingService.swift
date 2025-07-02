//
//  NetworkingService.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/2/24.
//  Copyright © 2024 test.tuist. All rights reserved.
//

import Foundation

public final class NetworkingService: NetworkingServiceType {
    
    // MARK: - Interface
    
    @BackgroundActor
    public func request<T: NetworkingDTOType>(api: NetworkingAPIType, dtoType: T.Type) async -> Result<T.EntityType, NetworkingServiceError> {
        let result = await request(api: api)
        switch result {
        case .success(let data):
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                let entity = try result.toEntity()
                return .success(entity)
            } catch(let error) {
                return .failure(.jsonParsingFailed(error))
            }
        case .failure(let failure):
            return .failure(.asError(failure))
        }
    }
    
    @BackgroundActor
    public func request(api: NetworkingAPIType) async -> Result<Data, Error> {
        if api.method == .post,
           api.headers["Content-Type"] == "multipart/form-data" {
            return await upload(api: api)
        }
        var url = api.route
        if !api.queryItems.isEmpty {
            url.append(queryItems: api.queryItems)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.allHTTPHeaderFields = api.headers
        if !api.body.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: api.body, options: [])
        }
        do {
            let (data, _) = try await session.data(for: urlRequest)
            return .success(data)
        } catch(let error) {
            return .failure(error)
        }
    }
    
    @BackgroundActor
    private func upload(api: NetworkingAPIType) async -> Result<Data, Error> {
        var request = URLRequest(url: api.route)
        request.httpMethod = api.method.rawValue
        request.allHTTPHeaderFields = api.headers
        
        guard let uploadData = api.uploadData else {
            return .failure(NetworkingServiceError.uploadDataNotFound)
        }
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        for (key, value) in api.body {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)".data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(uploadData.fileName)\"; filename=\"\(uploadData.fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(uploadData.mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(uploadData.data)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        do {
            let (data, _) = try await session.upload(for: request, from: body)
            return .success(data)
        } catch(let error) {
            return .failure(error)
        }
    }
    
    // MARK: - Attribute
    
    private let session: URLSessionProtocol
    
    // MARK: - Initialization
    
    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    
    // MARK: - Response Handler
    
    private func handleResponse<T: NetworkingDTOType>(data: Data, dtoType: T.Type) -> Result<T, NetworkingServiceError> {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch (let error) {
            return .failure(.jsonParsingFailed(error))
        }
    }
}
