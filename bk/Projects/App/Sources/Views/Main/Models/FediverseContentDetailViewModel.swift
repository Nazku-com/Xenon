//
//  FediverseContentDetailViewModel.swift
//  example.UIComponent
//
//  Created by 김수환 on 1/29/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import UIComponent
import FediverseFeature

public final class FediverseContentDetailViewModel: FetchableModelType {
    
    @Published var contents: [FediverseResponseEntity]
    @Published public var isLoading: Bool = false
    
    @MainActor
    public func fetch(fromBottom: Bool) async { // TODO: -
        guard !isLoading else { return }
        isLoading = true
        contents = [navigatedContent]
        if let contexts = await oAuthData.context(for: navigatedContent.id) {
            withAnimation {
                contents.insert(contentsOf: contexts.ancestors, at: 0)
                contents.append(contentsOf: contexts.descendants)
            }
        }
        isLoading = false
    }
    
    let oAuthData: OauthData
    private let navigatedContent: FediverseResponseEntity
    
    public init(oAuthData: OauthData, navigatedContent: FediverseResponseEntity) {
        self.contents = [navigatedContent]
        self.navigatedContent = navigatedContent
        self.oAuthData = oAuthData
    }
}
