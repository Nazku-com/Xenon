//
//  UIApplication+topViewController.swift
//  Sugar
//
//  Created by 김수환 on 1/11/26.
//  Copyright © 2026 social.xenon. All rights reserved.
//
// Source - https://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller

import UIKit

extension UIApplication {
    
    public var topViewController: UIViewController? {
        if var topController = firstKeyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
