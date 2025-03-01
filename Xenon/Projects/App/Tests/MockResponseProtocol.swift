//
//  MockResponseProtocol.swift
//  XenonTest
//
//  Created by 김수환 on 1/27/25.
//

import Foundation
import Alamofire

final class MockResponseProtocol: URLProtocol {
    
    // MARK: - Interface
    
    static func responseWithDTO(type: MockDTOType) {
        MockResponseProtocol.dtoType = type
    }
    
    static func responseWithStatusCode(code: Int) {
        MockResponseProtocol.responseType = MockResponseProtocol.ResponseType.success(
            HTTPURLResponse(
                url: URL(string: "https://haze.social")!,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
        )
    }
    
    static func responseWithFailure() {
        MockResponseProtocol.responseType = MockResponseProtocol.ResponseType.error(MockError.none)
    }
    
    // MARK: - Attribute
    
    static var responseType: ResponseType!
    
    static var dtoType: MockDTOType!
    
    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration)
    }()
    
    private(set) var activeTask: URLSessionTask?
    
    // MARK: - Setup
    
    private func setUpMockResponse() -> HTTPURLResponse? {
        var response: HTTPURLResponse?
        switch MockResponseProtocol.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let newResponse)?:
            response = newResponse
        default:
            fatalError("No fake responses found.")
        }
        return response!
    }
    
    private func setUpMockData() -> Data {
        MockResponseProtocol.dtoType.mockData
    }
    
    static func setUpMockDataFromFile(fileName: String) -> Data {
        guard let file = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            return Data()
        }
        return (try? Data(contentsOf: file)) ?? Data()
    }
    
    // MARK: - Override
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override class func requestIsCacheEquivalent(_ firstURLRequest: URLRequest, to secondURLRequest: URLRequest) -> Bool {
        false
    }
    
    // MARK: - Loading
    
    // swiftlint:disable:next call_super_method_inside_override_method
    override func startLoading() {
        let response = setUpMockResponse()
        let data = setUpMockData()
        
        client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
        
        client?.urlProtocol(self, didLoad: data)
        
        self.client?.urlProtocolDidFinishLoading(self)
        activeTask = session.dataTask(with: request.urlRequest!)
        activeTask?.cancel()
    }
    
    // swiftlint:disable:next call_super_method_inside_override_method
    override func stopLoading() {
        activeTask?.cancel()
    }
}

// MARK: - Constant

extension MockResponseProtocol {
    
    enum MockError: Error {
        
        case none
    }
    
    enum MockDTOType {
        
        case misskeyResponse
        case mastodonResponse
        
        var mockData: Data {
            switch self {
            case .misskeyResponse:
                return MisskeyResponse
            case .mastodonResponse:
                return MastodonResponse
            }
        }
    }
    
    enum ResponseType {
        
        case error(Error)
        case success(HTTPURLResponse)
    }
    
    static let MisskeyResponse = setUpMockDataFromFile(fileName: "misskeyResponse.json")
    static let MastodonResponse = setUpMockDataFromFile(fileName: "mastodonResponse.json")
}
