//
//  String+Extension.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 21.04.2022.
//

import Foundation
import UIKit

extension String {
    var containsWhitespace : Bool {
        return(self.rangeOfCharacter(from: .whitespaces) != nil)
    }
    
    func isValidUrl() -> Bool {
        if let url = NSURL(string: self) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
}
