//
//  UIImage+Extension.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 26.04.2022.
//

import UIKit

extension UIImage {
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        ctx!.saveGState()

        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx!.setFillColor(color.cgColor)
        ctx!.fillEllipse(in: rect)

        ctx!.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img!
    }
    
    class func sliderThumbImage(color: UIColor, borderColor: UIColor, size: CGFloat = 20, borderWidth: CGFloat = 2) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.saveGState()
        
        ctx.setFillColor(color.cgColor)
        ctx.setStrokeColor(borderColor.cgColor)
        ctx.setLineWidth(borderWidth)
        
        ctx.addEllipse(in: CGRect(x: borderWidth / 2, y: borderWidth / 2, width: size - borderWidth, height: size - borderWidth))
        ctx.drawPath(using: .fillStroke)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
}
