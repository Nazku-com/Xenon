//
//  SuffixNumber.swift
//  UIComponent
//
//  Created by 김수환 on 1/29/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation

public enum SuffixNumber {
    public static func format(_ number: Int) -> String {
        
        guard number > 9999 else {
            return "\(number)"
        }
        
        var num: Double = Double(number)
        let sign = ((num < 0) ? "-" : "" )
        
        num = fabs(num)
        
        if (num < 1000.0) {
            return "\(sign)\(num)"
        }
        
        let exp: Int = Int(log10(num) / 3.0)
        
        let units: [String] = ["K","M","G","T","P","E"];
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10
        
        return "\(sign)\(roundedNum)\(units[exp-1])"
        
    }
}
