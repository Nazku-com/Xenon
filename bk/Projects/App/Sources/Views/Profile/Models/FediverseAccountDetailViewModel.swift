//
//  FediverseAccountDetailViewModel.swift
//  xenon
//
//  Created by 김수환 on 3/9/25.
//

import SwiftUI
import UIComponent
import FediverseFeature
import EmojiText

final class FediverseAccountDetailViewModel: ObservableObject {
    
    typealias itemType = FediverseResponseEntity
    
    @Published var items = [FediverseResponseEntity]()
    @Published var didFetched = false
    
    @MainActor
    public func fetch(fromBottom: Bool) async {
        guard !isLoading else { return }
        isLoading = true
        if items.count > 0 {
            fromBottom
            ? await appendData(minID: nil, maxID: items.last?.id)
            : await appendData(minID: items.first?.id, maxID: nil)
        } else {
            await reloadData()
        }
        didFetched = true
        isLoading = false
    }
    
    @MainActor
    private func reloadData() async {
        let result = await oAuthData?.accountDetail(id: userId, contentType: contentType)
        switch result {
        case .success(let success):
            if SensitiveContentManager.shared.hideAllSensitiveContent {
                items = success.filter({ $0.sensitive == false })
            } else {
                items = success
            }
        case .failure, .none:
            print("Failed")
            return
        }
    }
    
    @MainActor
    private func appendData(minID: String?, maxID: String?) async {
        let result = await oAuthData?.accountDetail(id: userId, contentType: contentType, minID: minID, maxID: maxID)
        switch result {
        case .success(let success):
            var content = success
            if SensitiveContentManager.shared.hideAllSensitiveContent {
                content = success.filter({ $0.sensitive == false })
            }
            if minID != nil {
                items.insert(contentsOf: content, at: 0)
            } else {
                items.append(contentsOf: content)
            }
        case .failure, .none:
            print("Failed")
            return
        }
    }
    
    @Published var isLoading: Bool = false
    
    // MARK: - Attribute
    
    private let oAuthData: OauthData?
    private let userId: String
    private let contentType: OauthData.ContentType
    
    // MARK: - Initialization
    
    init(userId: String, contentType: OauthData.ContentType) {
        self.oAuthData = OAuthDataManager.shared.currentOAuthData
        self.userId = userId
        self.contentType = contentType
    }
}
