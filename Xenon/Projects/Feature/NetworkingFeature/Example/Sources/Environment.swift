//
//  Environment.swift
//  TuistExample
//
//  Created by 김수환 on 11/29/24.
//

import Foundation

protocol EnvironmentCompatible {}

extension EnvironmentCompatible {
    
    init(production: Self, dev: Self? = nil, stage: Self? = nil) {
#if PROD
        self = production
#elseif DEV
        self = dev ?? production
#elseif STAGE
        self = stage ?? production
#endif
    }
}
