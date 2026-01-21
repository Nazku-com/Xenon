//
//  StyledFont.swift
//  UIComponent
//
//  Created by 김수환 on 12/16/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI

public enum StyledFont: CaseIterable {
    
    case title
    case subtitle
    case body
    case caption
}

public extension Font {
    
    static func styled(_ style: StyledFont, weight: Font.Weight? = nil, design: Font.Design? = nil) -> Font {
        switch style {
        case .title:
            return .system(size: 24, weight: weight ?? .bold, design: design ?? .rounded)
        case .subtitle:
            return .system(size: 20, weight: weight ?? .bold, design: design ?? .rounded)
        case .body:
            return .system(size: 16, weight: weight ?? .medium, design: design ?? .default)
        case .caption:
            return .system(size: 12, weight: weight ?? .medium, design: design ?? .default)
        }
    }
}

#Preview {
    VStack {
        ForEach(StyledFont.allCases, id:\.self) {
            Text("hello world")
                .font(.styled($0))
        }
    }
}
