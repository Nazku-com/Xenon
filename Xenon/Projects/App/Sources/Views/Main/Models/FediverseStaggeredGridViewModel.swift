//
//  FediverseStaggeredGridViewModel.swift
//  xenon
//
//  Created by 김수환 on 2/3/25.
//

import SwiftUI
import UIComponent
import FediverseFeature
import EmojiText

final class FediverseStaggeredGridViewModel: StaggeredGridViewModelType {
    
    typealias itemType = FediverseResponseEntity
    
    @Published var items: [[FediverseResponseEntity]]
    @Published var numberOfRows: Int
    
    @MainActor
    public func fetch(fromBottom: Bool) async {
        guard !isLoading else { return }
        isLoading = true
        if timelineData.count > 0 {
            fromBottom
            ? await appendData(minID: nil, maxID: timelineData.last?.id)
            : await appendData(minID: timelineData.first?.id, maxID: nil)
        } else {
            await reloadData()
        }
        isLoading = false
    }
    
    @MainActor
    private func reloadData() async {
        let result = await oAuthData?.timeline(type: timeline)
        switch result {
        case .success(let success):
            if SensitiveContentManager.shared.hideAllSensitiveContent {
                timelineData = success.filter({ $0.sensitive == false })
            } else {
                timelineData = success
            }
        case .failure, .none:
            return
        }
    }
    
    @MainActor
    private func appendData(minID: String?, maxID: String?) async {
        let result = await oAuthData?.timeline(type: timeline, minID: minID, maxID: maxID)
        switch result {
        case .success(let success):
            var content = success
            if SensitiveContentManager.shared.hideAllSensitiveContent {
                content = success.filter({ $0.sensitive == false })
            }
            if minID != nil {
                timelineData.insert(contentsOf: content, at: 0)
            } else {
                timelineData.append(contentsOf: content)
            }
        case .failure, .none:
            return
        }
    }
    
    @Published var isLoading: Bool = false
    
    private func transformArray(_ array: [FediverseResponseEntity], numberOfRows: Int) -> [[FediverseResponseEntity]] {
        guard numberOfRows > 0 else { return [array] }
        var result = [[FediverseResponseEntity]](repeating: [], count: numberOfRows)
        
        for i in 0..<numberOfRows {
            result[i] = stride(from: i, to: array.count, by: numberOfRows).map { array[$0] }
        }
        
        return result
    }
    
    @objc func didRecieveNeedRefreshFediverseResponse(_ notification: Notification) {
        guard let entity = notification.object as? FediverseResponseEntity else { return }
        if let index = timelineData.firstIndex(where: { $0.id == entity.id }) {
            timelineData[index] = entity
        }
    }
    
    // MARK: - Attribute
    
    private let oAuthData: OauthData?
    private let timeline: TimelineType
    private var timelineData = [FediverseResponseEntity]() {
        didSet {
            items = transformArray(timelineData, numberOfRows: numberOfRows)
        }
    }
    
    // MARK: - Initialization
    
    init(items: [[FediverseResponseEntity]] = [[]], numberOfRows: Int, timeline: TimelineType) {
        self.items = items
        self.numberOfRows = numberOfRows
        self.oAuthData = OAuthDataManager.shared.currentOAuthData
        self.timeline = timeline
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didRecieveNeedRefreshFediverseResponse(_:)),
            name: .NeedRefreshFediverseResponse,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
