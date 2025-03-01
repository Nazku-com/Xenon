//
//  SegmentedControlTab.swift
//  xenon
//
//  Created by 김수환 on 2/18/25.
//

import SwiftUI
import FediverseFeature

struct SegmentedControlTab: Codable {
    
    var title: String
    var contentType: ContentType
}

extension SegmentedControlTab {
    
    static let `default`: [SegmentedControlTab] = [ .init(title: "home", contentType: .fediverse(.home)) ]
}

extension SegmentedControlTab {
    
    enum ContentType: Codable {
        case fediverse(TimelineType)
    }
}
