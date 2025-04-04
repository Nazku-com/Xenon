//
//  NetworkingService.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/2/24.
//  Copyright © 2024 test.tuist. All rights reserved.
//

import Foundation
import Alamofire

public final class NetworkingService: NetworkingServiceType {
    
    // MARK: - Interface
    
    @MainActor
    public func request<T: NetworkingDTOType>(api: NetworkingAPIType, dtoType: T.Type) async ->  Result<T.EntityType, NetworkingServiceError> {
        let data: Data?
        if api.method == .post {
            if api.headers?["Content-Type"] == "multipart/form-data" {
                data = await upload(api: api)
            } else {
                data = await requestWithBody(api: api)
            }
        } else {
            data = await request(api: api)
        }
        guard let data else {
            return .failure(.networkError("data is nil"))
        }
        
        let result = handleResponse(data: data, dtoType: dtoType)
        switch result {
        case .success(let value):
            return .success(value.toEntity())
        case .failure(let error):
            return .failure(error)
        }
    }
    
    @BackgroundActor
    public func request(api: NetworkingAPIType) async -> Data? {
        if api.method == .post {
            if api.headers?["Content-Type"] == "multipart/form-data" {
                let result = await upload(api: api)
                return result
            } else {
                let result = await requestWithBody(api: api)
                return result
            }
        }
        let result = await afSession.request(
            api.route,
            method: api.method,
            parameters: api.parameters,
            headers: api.headers
        ).serializingData().result
        
        switch result {
        case .success(let success):
            return success
        case .failure:
            return nil
        }
    }
    
    
    @BackgroundActor
    private func upload(api: NetworkingAPIType) async ->  Data? {
        var request = URLRequest(url: api.route)
        request.httpMethod = api.method.rawValue
        request.headers = api.headers ?? []
        return await withCheckedContinuation { continuation in
            afSession.upload(multipartFormData: { multipartFormData in
                if let bodyData = api.bodyData {
                    bodyData.forEach{ key, value in
                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                }
                if let content  = api.uploadData {
                    multipartFormData.append(content.data, withName: content.fileName, fileName: content.fileName, mimeType: content.mimeType)
                }
            }, to: api.route, method: api.method, headers: api.headers)
            .response { response in
                continuation.resume(returning: response.data)
            }
        }
    }
    
    @BackgroundActor
    private func requestWithBody(api: NetworkingAPIType) async -> Data? {
        var request = URLRequest(url: api.route)
        request.httpMethod = api.method.rawValue
        request.headers = api.headers ?? []
        request.httpBody = try? JSONSerialization.data(withJSONObject: api.bodyData ?? [], options: [])
        return await withCheckedContinuation { continuation in
            afSession.request(request)
                .responseData { response in
                    continuation.resume(returning: response.data)
                }
        }
    }
    
    
    // MARK: - Attribute
    
    private let afSession: Alamofire.Session
    
    
    // MARK: - Initialization
    
    public init(afSession: Alamofire.Session = AF) {
        self.afSession = afSession
    }
    
    
    // MARK: - Response Handler
    
    private func handleResponse<T: NetworkingDTOType>(data: Data, dtoType: T.Type) -> Result<T, NetworkingServiceError> {
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return .success(result)
        } catch (let error) {
            return .failure(.jsonParsingFailed(error.localizedDescription))
        }
    }
}
