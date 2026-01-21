//
//  FetchableModelType.swift
//  example.UIComponent
//
//  Created by 김수환 on 1/29/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI

public protocol FetchableModelType: ObservableObject {
    
    func fetch(fromBottom: Bool) async
    var isLoading: Bool { get }
}
