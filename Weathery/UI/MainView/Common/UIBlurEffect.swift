//
//  UIBlurEffect.swift
//  Weathery
//
//  Created by Anna Filin on 26/02/2025.
//

import Foundation
import UIKit

extension UIBlurEffect {
    static func effect(blurRadius: CGFloat) -> UIBlurEffect? {
        let selector = NSSelectorFromString("effectWithBlurRadius:")
        guard self.responds(to: selector) else { return nil }
        let blurEffect = self.perform(selector, with: blurRadius).takeUnretainedValue()
        return blurEffect as? UIBlurEffect
    }
}
