//
//  UICollectionViewCell+Extension.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import UIKit

extension UICollectionViewCell {
    class var identifier: String { return String.className(self) }
    
    static func getNib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
