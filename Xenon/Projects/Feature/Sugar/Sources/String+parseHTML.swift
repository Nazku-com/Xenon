//
//  String+parseHTML.swift
//  Sugar
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import SwiftHTMLtoMarkdown

public extension String {
    
    func parseHTML() -> NSAttributedString? {
        let string = self.replacing(
            /(<img.*?>|<video.*?<\/video>|<iframe.*?<\/iframe>)/,
            with: { _ in "" }
        )
        
        let data = Data(string.utf8)
        return try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue,
            ],
            documentAttributes: nil
        )
    }
    
    func parseHTMLToMarkdown() async -> String? {
        var document = BasicHTML(rawHTML: self)
        try? document.parse()
        return try? document.asMarkdown()
    }
}
