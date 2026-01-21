//
//  SensitiveContentToggleView.swift
//  xenon
//
//  Created by 김수환 on 3/3/25.
//

import SwiftUI

struct SensitiveContentToggleView: View {
    
    @ObservedObject var manager = SensitiveContentManager.shared
    
    var body: some View {
        VStack {
            Toggle("hide sensitive content from Timeline", isOn: $manager.hideAllSensitiveContent)
            Toggle("do not show warning", isOn: $manager.hideWarning)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    SensitiveContentToggleView()
}
