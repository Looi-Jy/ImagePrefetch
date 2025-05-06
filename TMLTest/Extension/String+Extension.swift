//
//  String+Extension.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import Foundation

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}
