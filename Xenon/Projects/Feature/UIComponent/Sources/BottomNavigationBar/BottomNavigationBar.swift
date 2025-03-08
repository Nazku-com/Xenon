//
//  BottomNavigationBar.swift
//  UIComponent
//
//  Created by 김수환 on 1/30/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import Combine
import Neumorphic

public enum BottomNavigationBarButtonType: String {
    
    case home
    case plus
    case message
    case search
}

public final class NavigationBarModel: ObservableObject {
    
    // MARK: - Input
    
    public let shrinkBarPublisher = PassthroughSubject<Bool,Never>()
    
    // MARK: - Output
    
    public let buttonTapPublisher = PassthroughSubject<BottomNavigationBarButtonType,Never>()
    
    
    // MARK: - Initialization
    
    public static let shared = NavigationBarModel()
    private init() {}
}

public struct BottomNavigationBar: View {
    
    @State var isShrinked: Bool = false
    @ObservedObject var model: NavigationBarModel
    public var body: some View {
        VStack {
            if !isShrinked {
                contenet
                    .transition(.move(edge: .bottom))
            }
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: isShrinked ? 0 : 50)
        .onReceive(model.shrinkBarPublisher) { needShrink in
            withAnimation(.easeOut(duration: 0.1)) {
                isShrinked = needShrink
            }
        }
    }
    
    @ViewBuilder
    private var contenet: some View {
        HStack {
            Button {
                model.buttonTapPublisher.send(.home)
            } label: {
                Circle()
                    .fill(Color.Neumorphic.main)
                    .overlay {
                        Image(systemName: "house.fill")
                    }
            }
            .softButtonStyle(Circle(), padding: 8)
            .padding(.top, 6)
            
            Spacer()
            
            Button {
                model.buttonTapPublisher.send(.plus)
            } label: {
                Capsule()
                    .fill(Color.Neumorphic.main)
                    .frame(width: 80)
                    .padding(.vertical, 10)
                    .overlay {
                        Image(systemName: "plus")
                    }
            }
            .softButtonStyle(Capsule(), padding: 8)
            
            Spacer()
            
            Button {
                model.buttonTapPublisher.send(.message)
            } label: {
                Circle()
                    .fill(Color.Neumorphic.main)
                    .overlay {
                        Image(systemName: "bell.fill")
                    }
            }
            .softButtonStyle(Circle(), padding: 8)
            .padding(.top, 6)
        }
        .padding(.top, 8)
    }
    
    public init(model: NavigationBarModel) {
        self.model = model
    }
}
