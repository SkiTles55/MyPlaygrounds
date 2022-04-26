//
//  String+Extension.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 21.04.2022.
//

import Foundation
import UIKit
import CryptoKit

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
    
    func hash256() -> String {
        // iOS 13.0
        let inputData = Data(utf8)
        
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
