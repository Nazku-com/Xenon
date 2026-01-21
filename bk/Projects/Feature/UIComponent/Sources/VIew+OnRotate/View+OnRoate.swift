//
//  View+OnRoate.swift
//  UIComponent
//
//  Created by 김수환 on 1/27/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier { // TODO: - Fix bug
    @State var originalOrientation = UIDevice.current.orientation
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                let orientation = UIDevice.current.orientation
                guard orientation.isLandscape || orientation.isPortrait,
                      orientation.isPortrait != originalOrientation.isPortrait else {
                    return
                }
                action(orientation)
                originalOrientation = orientation
            }
    }
}

extension View {
    public func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
