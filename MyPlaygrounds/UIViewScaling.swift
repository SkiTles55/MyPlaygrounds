//
//  UIViewScaling.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 21.04.2022.
//

import UIKit

class UIViewScaling {
    enum ScaleMode {
        case both
        case vertical
        case horizontal
    }
    
    var scalingMode: ScaleMode = .both
    
    private func scalePictureSymbolView(_ view: UIView, scaleFactor: CGFloat) {
        let previousSize = view.frame.size
        var newSize = CGSize()
        let newWidth = scalingMode == .vertical ? previousSize.width : previousSize.width * max(scaleFactor, 0.5)
        let newHeight = scalingMode == .horizontal ? previousSize.height : previousSize.height * max(scaleFactor, 0.5)
        
        if scalingMode == .both {
            let imageViewRatio = previousSize.width / previousSize.height
            let scaleByWidth = imageViewRatio > (3 / 4)
            newSize = CGSize(width: scaleByWidth ? newWidth : newHeight * imageViewRatio, height: scaleByWidth ? newWidth / imageViewRatio : newHeight)
        } else {
            newSize = CGSize(width: newWidth, height: newHeight)
        }
        
        let frame = CGRect(x: view.frame.origin.x,
                           y: view.frame.origin.y,
                           width: newSize.width,
                           height: newSize.height)
        
        view.frame = frame
    }
}
