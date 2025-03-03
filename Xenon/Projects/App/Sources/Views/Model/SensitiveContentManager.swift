//
//  SensitiveContentManager.swift
//  xenon
//
//  Created by 김수환 on 3/3/25.
//

import Foundation
import FediverseFeature

final class SensitiveContentManager: ObservableObject {
    
    static var shared = SensitiveContentManager()
    private init() {}
    
    @Published var hideAllSensitiveContent: Bool = load(contentType: .hideAllSensitiveContent) {
        didSet {
            Self.save(contentType: .hideAllSensitiveContent, value: hideAllSensitiveContent)
        }
    }
    
    @Published var hideWarning: Bool = load(contentType: .hideWarning) {
        didSet {
            Self.save(contentType: .hideWarning, value: hideWarning)
        }
    }
    
    private static func save(contentType: ContentType, value: Bool) {
        UserDefaults.standard.set(value, forKey: contentType.rawValue)
    }
    
    private static func load(contentType: ContentType) -> Bool {
        UserDefaults.standard.bool(forKey: contentType.rawValue)
    }
}

private extension SensitiveContentManager {
    
    enum ContentType: String {
        case hideAllSensitiveContent
        case hideWarning
    }
}
