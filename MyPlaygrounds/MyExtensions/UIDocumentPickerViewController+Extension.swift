//
//  UIDocumentPickerViewController+Extension.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 21.04.2022.
//

import Foundation
import UIKit

// let imageTypes = ["jpeg", "jpg", "png", "bmp", "svg"]
// let documentPicker = UIDocumentPickerViewController(with: imageTypes)

extension UIDocumentPickerViewController {
    convenience init(with fileTypes: [String]) {
        if #available(iOS 14, *) {
            self.init(forOpeningContentTypes: fileTypes.getContentTypes())
        } else {
            self.init(documentTypes: fileTypes.getTypes(), in: .open)
        }
    }
}

import UniformTypeIdentifiers

extension Array where Element == String {
    @available(iOS 14, *)
    func getContentTypes() -> [UTType] {
        return self.map { UTType.init(filenameExtension: $0) ?? UTType.text }
    }
    
    func getTypes() -> [String] {
        return self
            .map { $0.getTypesFromExtension() }
            .flatMap { $0 }
    }
}

import MobileCoreServices

extension String {
    func getTypesFromExtension() -> [String] {
        if let types = UTTypeCreateAllIdentifiersForTag(kUTTagClassFilenameExtension, self as CFString, nil)?.takeRetainedValue() as? [String] {
            return types
        }
        return []
    }
}
