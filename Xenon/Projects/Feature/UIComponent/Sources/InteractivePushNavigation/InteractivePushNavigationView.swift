//
//  InteractivePushNavigationView.swift
//  UIComponent
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI

public struct InteractivePushNavigationView<Content: View>: UIViewControllerRepresentable {
  let content: Content
  let destinationView: AnyView
  
  init<D: View>(content: Content, destination: D) {
    self.content = content
    self.destinationView = AnyView(destination)
  }
  
    public func makeUIViewController(context: Context) -> InteractivePushNavigationController {
    let hostingController = UIHostingController(rootView: content)
    let navigationController = InteractivePushNavigationController(rootViewController: hostingController)
    let destinationController = UIHostingController(rootView: destinationView)
    navigationController.setupInteractivePush(to: destinationController)
    return navigationController
  }
  
    public func updateUIViewController(_ uiViewController: InteractivePushNavigationController, context: Context) {}
}

extension View {
    
  public func interactivePushDestination<D: View>(destination: D) -> some View {
    InteractivePushNavigationView(content: self, destination: destination)
      .ignoresSafeArea()
  }
}
