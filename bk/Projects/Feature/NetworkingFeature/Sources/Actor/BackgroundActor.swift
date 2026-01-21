//
//  BackgroundActor.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/2/24.
//  Copyright © 2024 test.tuist. All rights reserved.
//

import Foundation

@globalActor final public actor BackgroundActor: GlobalActor {
    public typealias ActorType = BackgroundActor
    public static let shared = BackgroundActor()
}
