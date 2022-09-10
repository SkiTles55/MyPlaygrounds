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
    
    //creates a UIImage given a UIColor
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    class func segmentControlImage(image: UIImage?, string: String?, description: String?, color: UIColor, descriptionColor: UIColor) -> UIImage {
        let stringAttributes = [NSAttributedString.Key.foregroundColor: color]
        let descriptionAttributes = [NSAttributedString.Key.foregroundColor: descriptionColor]
        
        let imageSize = image?.size ?? .zero
        
        var expectedTextSize = CGSize.zero
        if let text = string {
            expectedTextSize = (text as NSString).size(withAttributes: stringAttributes)
        }
        
        var expectedDescriptionSize = CGSize.zero
        if let description = description {
            expectedDescriptionSize = (description as NSString).size(withAttributes: descriptionAttributes)
        }
        
        let imageTextSpacing: CGFloat = imageSize != .zero && expectedTextSize != .zero && expectedDescriptionSize != .zero ? 8 : 0
        let stringDescriptionSpacing: CGFloat = expectedDescriptionSize != .zero ? 4 : 0
        
        let width: CGFloat = imageSize.width + imageTextSpacing + expectedTextSize.width + stringDescriptionSpacing + expectedDescriptionSize.width
        let height: CGFloat = max(imageSize.height, expectedTextSize.height, expectedDescriptionSize.height)
        
        let size: CGSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.setFillColor(color.cgColor)
        
        let stringTopPosition: CGFloat = (height - expectedTextSize.height) / 2.0
        let stringOrigin: CGFloat = imageSize.width + imageTextSpacing
        let stringPoint: CGPoint = CGPoint.init(x: stringOrigin, y: stringTopPosition)
        
        string?.draw(at: stringPoint, withAttributes: stringAttributes)
        
        let descriptionTopPosition: CGFloat = height - (height * 0.9)
        let descriptionOrigin: CGFloat = stringOrigin + expectedTextSize.width + stringDescriptionSpacing
        let descriptionPoint: CGPoint = CGPoint.init(x: descriptionOrigin, y: descriptionTopPosition)
        
        description?.draw(at: descriptionPoint, withAttributes: descriptionAttributes)
        
        let flipVertical: CGAffineTransform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
        context.concatenate(flipVertical)
        
        if let cgImage = image?.cgImage {
            context.draw(cgImage, in: CGRect.init(x: 0.0, y: ((height - imageSize.height) / 2.0), width: imageSize.width, height: imageSize.height))
            
            context.setBlendMode(.sourceIn)
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        }
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? UIImage()
    }
    
    func applyGradient(_ gradient: CGGradient) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context: CGContext = UIGraphicsGetCurrentContext(),
              let cgImage = cgImage else { return self }
        let flipVertical: CGAffineTransform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
        context.concatenate(flipVertical)
        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        context.setBlendMode(.sourceIn)
        context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: size.height / 2), end: CGPoint(x: size.width, y: size.height / 2), options: [])
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
