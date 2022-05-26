//
//  UINavigationController+Extension.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 26.05.2022.
//

import UIKit

extension UINavigationController {
    func setupBackgroundColor(_ color: UIColor, style: UIUserInterfaceStyle) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = color
        appearance.shadowColor = .clear
        self.navigationBar.overrideUserInterfaceStyle = style
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
}
