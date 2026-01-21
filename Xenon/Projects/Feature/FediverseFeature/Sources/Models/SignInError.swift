//
//  SignInError.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation

public enum SignInError: Error {
    
    case nodeInfoNotFound
    case unsupportedServer
    case appRegisterFailed(Error?)
    case urlNotFound
    case createTokenFailed(Error?)
}
