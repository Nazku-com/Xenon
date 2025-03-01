//
//  DesignFont.swift
//  example.UIComponent
//
//  Created by 김수환 on 1/27/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI

public enum DesignFont {
    
    public enum Default {
        
        public enum light {
            
            public static let extralarge = Font.system(size: FontSize.extralarge, weight: .light, design: .default)
            public static let large = Font.system(size: FontSize.large, weight: .light, design: .default)
            public static let normal = Font.system(size: FontSize.normal, weight: .light, design: .default)
            public static let small = Font.system(size: FontSize.small, weight: .light, design: .default)
            public static let extraSmall = Font.system(size: FontSize.extraSmall, weight: .thin, design: .default)
        }
        
        public enum Medium {
            
            public static let extralarge = Font.system(size: FontSize.extralarge, weight: .medium, design: .default)
            public static let large = Font.system(size: FontSize.large, weight: .medium, design: .default)
            public static let normal = Font.system(size: FontSize.normal, weight: .medium, design: .default)
            public static let small = Font.system(size: FontSize.small, weight: .medium, design: .default)
            public static let extraSmall = Font.system(size: FontSize.extraSmall, weight: .medium, design: .default)
        }
        
        public enum Bold {
            
            public static let extralarge = Font.system(size: FontSize.extralarge, weight: .bold, design: .default)
            public static let large = Font.system(size: FontSize.large, weight: .bold, design: .default)
            public static let normal = Font.system(size: FontSize.normal, weight: .bold, design: .default)
            public static let small = Font.system(size: FontSize.small, weight: .bold, design: .default)
            public static let extraSmall = Font.system(size: FontSize.extraSmall, weight: .bold, design: .default)
        }
    }
    
    public enum Rounded {
        
        public enum Medium {
            
            public static let extralarge = Font.system(size: FontSize.extralarge, weight: .medium, design: .rounded)
            public static let large = Font.system(size: FontSize.large, weight: .medium, design: .rounded)
            public static let normal = Font.system(size: FontSize.normal, weight: .medium, design: .rounded)
            public static let small = Font.system(size: FontSize.small, weight: .medium, design: .rounded)
            public static let extraSmall = Font.system(size: FontSize.extraSmall, weight: .medium, design: .rounded)
        }
        
        public enum Bold {
            
            public static let extralarge = Font.system(size: FontSize.extralarge, weight: .bold, design: .rounded)
            public static let large = Font.system(size: FontSize.large, weight: .bold, design: .rounded)
            public static let normal = Font.system(size: FontSize.normal, weight: .bold, design: .rounded)
            public static let small = Font.system(size: FontSize.small, weight: .bold, design: .rounded)
            public static let extraSmall = Font.system(size: FontSize.extraSmall, weight: .bold, design: .rounded)
        }
    }
    
    public enum FontSize {
        
        public static let extralarge: CGFloat = 24
        public static let large: CGFloat = 20
        public static let normal: CGFloat = 16
        public static let small: CGFloat = 14
        public static let extraSmall: CGFloat = 12
    }
}



#Preview {
    ScrollView {
        VStack {
            Text("Preview")
                .font(DesignFont.Default.light.extraSmall)
            Text("Preview")
                .font(DesignFont.Default.light.small)
            Text("Preview")
                .font(DesignFont.Default.light.normal)
            Text("Preview")
                .font(DesignFont.Default.light.large)
            Text("Preview")
                .font(DesignFont.Default.light.extralarge)
            
            Text("Preview")
                .font(DesignFont.Default.Medium.extraSmall)
            Text("Preview")
                .font(DesignFont.Default.Medium.small)
            Text("Preview")
                .font(DesignFont.Default.Medium.normal)
            Text("Preview")
                .font(DesignFont.Default.Medium.large)
            Text("Preview")
                .font(DesignFont.Default.Medium.extralarge)
            
            Divider()
            
            Text("Preview")
                .font(DesignFont.Default.Bold.extraSmall)
            Text("Preview")
                .font(DesignFont.Default.Bold.small)
            Text("Preview")
                .font(DesignFont.Default.Bold.normal)
            Text("Preview")
                .font(DesignFont.Default.Bold.large)
            Text("Preview")
                .font(DesignFont.Default.Bold.extralarge)
            
            Divider()
            
            Text("Preview")
                .font(DesignFont.Rounded.Medium.extraSmall)
            Text("Preview")
                .font(DesignFont.Rounded.Medium.small)
            Text("Preview")
                .font(DesignFont.Rounded.Medium.normal)
            Text("Preview")
                .font(DesignFont.Rounded.Medium.large)
            Text("Preview")
                .font(DesignFont.Rounded.Medium.extralarge)
            
            Divider()
            
            Text("Preview")
                .font(DesignFont.Rounded.Bold.extraSmall)
            Text("Preview")
                .font(DesignFont.Rounded.Bold.small)
            Text("Preview")
                .font(DesignFont.Rounded.Bold.normal)
            Text("Preview")
                .font(DesignFont.Rounded.Bold.large)
            Text("Preview")
                .font(DesignFont.Rounded.Bold.extralarge)
            
            Divider()
            
        }
        .padding(.top, 32)
    }
}
