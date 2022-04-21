//
//  UIView+Extension.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 21.04.2022.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ view: UIView...) {
        for v in view {
            addSubview(v)
        }
    }
}
