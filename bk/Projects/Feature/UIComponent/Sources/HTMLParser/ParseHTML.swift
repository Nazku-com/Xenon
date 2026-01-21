//
//  ParseHTML.swift
//  UIComponent
//
//  Created by 김수환 on 1/31/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI

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
}
