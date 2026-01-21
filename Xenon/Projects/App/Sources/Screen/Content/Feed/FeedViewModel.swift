//
//  FeedViewModel.swift
//  xenon
//
//  Created by 김수환 on 12/17/25.
//

import SwiftUI
import Combine
import Sugar
import FediverseFeature

@Observable
@MainActor
final class FeedViewModel: Identifiable {
    
    let oAuthdata: OauthData
    var items: [[FediverseResponseEntity]] = []
    @ObservationIgnored var timelineData: [FediverseResponseEntity] = [] {
        didSet {
            items = transformArray(timelineData, numberOfRows: columns)
        }
    }
    var columns: Int
    var isLoading: Bool = false
    var anchorID: String?
    
    @ObservationIgnored var pagenation: (next: URL?, prev: URL?)
    
    func loadNew() async {
        if let next = pagenation.prev {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            let result = await oAuthdata.timeline(type: timeline, pagenationURL: next)
            switch result {
            case .success(let success):
                timelineData.insert(contentsOf: success.data, at: 0)
                if let pagenation = (success.urlResponse as? HTTPURLResponse)?.pagenation {
                    self.pagenation.prev = pagenation.prev
                }
            case .failure(let failure):
                print(failure) // swiftlint:disable:this no_print
                // TODO: -
            }
        } else {
            await fetchContents(minID: timelineData.first?.id)
        }
    }
    func loadMore() async {
        if let next = pagenation.next {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            let result = await oAuthdata.timeline(type: timeline, pagenationURL: next)
            switch result {
            case .success(let success):
                timelineData.append(contentsOf: success.data)
                if let pagenation = (success.urlResponse as? HTTPURLResponse)?.pagenation {
                    self.pagenation.next = pagenation.next
                }
            case .failure(let failure):
                print(failure) // swiftlint:disable:this no_print
                // TODO: -
            }
        } else {
            await fetchContents(maxID: timelineData.last?.id)
        }
    }
    
    func fetchContents(minID: String? = nil, maxID: String? = nil) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        let result = await oAuthdata.timeline(type: timeline, minID: minID, maxID: maxID)
        switch result {
        case .success(let success):
            if minID != nil {
                timelineData.insert(contentsOf: success.data, at: 0)
            } else if maxID != nil {
                timelineData.append(contentsOf: success.data)
            } else {
                timelineData = success.data
            }
            if let pagenation = (success.urlResponse as? HTTPURLResponse)?.pagenation {
                if minID != nil {
                    self.pagenation.prev = pagenation.prev
                } else if maxID != nil {
                    self.pagenation.next = pagenation.next
                } else {
                    self.pagenation = pagenation
                }
            }
        case .failure(let failure):
            print(failure) // swiftlint:disable:this no_print
            // TODO: -
        }
    }
    
    private func transformArray(_ array: [FediverseResponseEntity], numberOfRows: Int) -> [[FediverseResponseEntity]] {
        guard numberOfRows > 0 else { return [array] }
        var result = [[FediverseResponseEntity]](repeating: [], count: numberOfRows)
        
        for i in 0..<numberOfRows {
            result[i] = stride(from: i, to: array.count, by: numberOfRows).map { array[$0] }
        }
        
        return result
    }
    
    // MARK: - Attribute
    
    private let timeline: TimelineType
    
    // MARK: - Initialization
    
    init(oAuthdata: OauthData, columns: Int, timeline: TimelineType) {
        self.oAuthdata = oAuthdata
        self.columns = columns
        self.timeline = timeline
    }
}
