import Foundation
import FediverseFeature
import XCTest

final class FediverseDecodingTest: XCTestCase {
    func test_misskeyResponseDecoding() {
        do {
            try JSONDecoder().decode([MisskeyResponseDTO].self, from: MockResponseProtocol.MisskeyResponse)
            XCTAssertTrue(true)
        } catch(let error) {
            print(error)
            XCTFail()
        }
    }
    func test_mastodonResponseDecoding() {
        do {
            try JSONDecoder().decode([MastodonResponseDTO].self, from: MockResponseProtocol.MastodonResponse)
            XCTAssertTrue(true)
        } catch(let error) {
            print(error)
            XCTFail()
        }
    }
}
