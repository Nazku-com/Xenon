//
//  SignInError.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation

public enum SignInError: Error {
    
    case nodeInfoNotFound
    case unsupportedServer
    case appRegisterFailed
    case urlNotFound
    case createTokenFailed
}
