//
//  File.swift
//  Sugar
//
//  Created by 김수환 on 12/14/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation

public extension HTTPURLResponse {
    
    var pagenation: (next: URL?, prev: URL?) {
        let links = (allHeaderFields["Link"] as? String)?
            .split(separator: ",")
            .compactMap { part -> (String, URL)? in
                let sections = part.split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }
                guard
                    let urlPart = sections.first,
                    let url = URL(
                        string: urlPart
                            .replacingOccurrences(of: "<", with: "")
                            .replacingOccurrences(of: ">", with: "")
                    )
                else { return nil }
                
                let rel = sections
                    .first { $0.hasPrefix("rel=") }?
                    .replacingOccurrences(of: "rel=", with: "")
                    .replacingOccurrences(of: "\"", with: "")
                
                guard let rel else { return nil }
                return (rel, url)
            }
        
        let result = Dictionary(uniqueKeysWithValues: links ?? [])
        return (next: result["next"], prev: result["prev"])
    }
}
