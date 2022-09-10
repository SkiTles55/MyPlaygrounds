//
//  PlaceholderColoredTextField.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 10.09.2022.
//

import UIKit

class PlaceholderColoredTextField: UITextField {
    var placeholderColor: UIColor = .gray
    
    override var placeholder: String? {
        didSet {
            updatePlaceholder(color: placeholderColor)
        }
    }
    
    func updatePlaceholder(color: UIColor) {
        if let placeholder = placeholder {
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: color]
            attributedPlaceholder = NSAttributedString(string:placeholder,
                                                       attributes: attributes)
        }
    }
}
