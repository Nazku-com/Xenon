//
//  DateTimeVIew.swift
//  UIComponent
//
//  Created by 김수환 on 2/2/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI

struct DateTimeVIew: View {
    
    let date: Date
    
    var body: some View {
        let seconds = Date().timeIntervalSince1970 - date.timeIntervalSince1970
        if seconds < 86400 { // 1 Day
            Text(Constant.secondsToHoursMinutesSecondsFormatter(Int(seconds)))
                .font(DesignFont.Rounded.Bold.extraSmall)
        } else {
            Text(date, format: Date.FormatStyle().year().month().day().hour().minute())
                .font(DesignFont.Rounded.Bold.extraSmall)
        }
    }
}

// MARK: - Constant

private extension DateTimeVIew {
    
    enum Constant {
        static func secondsToHoursMinutesSecondsFormatter(_ seconds: Int) -> String {
            let hours = seconds / 3600
            let minutes = (seconds % 3600) / 60
            
            var contents = ""
            if hours > 0 {
                contents += "\(hours) hr, "
                if minutes > 0 {
                    contents += "\(minutes) min"
                }
            } else {
                contents += "\(max(minutes, 1)) min"
            }
            return contents + " ago"
        }
    }
}
