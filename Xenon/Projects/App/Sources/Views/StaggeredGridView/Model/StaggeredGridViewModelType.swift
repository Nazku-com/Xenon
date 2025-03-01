//
//  StaggeredGridViewModelType.swift
//  xenon
//
//  Created by 김수환 on 2/8/25.
//

import SwiftUI

public protocol StaggeredGridViewModelType: ObservableObject {
    
    associatedtype itemType: StaggeredGridContentType
    
    func fetch(fromBottom: Bool) async
    var isLoading: Bool { get }
    var items: [[itemType]] { get }
    var numberOfRows: Int { get }
}

public protocol StaggeredGridContentType {
    
    associatedtype Content: View
    associatedtype ContextMenu: View
    
    var id: String { get }
    var view: Content { get }
    var contextMenu: ContextMenu { get }
    var contentString: String { get }
}

public protocol StaggeredGridViewCellInteractorType: ObservableObject {}
