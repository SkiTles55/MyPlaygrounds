//
//  TriangleView.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 22.04.2022.
//

import UIKit

enum TriangleDirection {
    case left
    case up
}

class TriangleView: UIView {
    var fillColor: UIColor = .white
    var direction: TriangleDirection = .left
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch direction {
        case .left:
            setLeftTriangle()
        case .up:
            setUpTriangle()
        }
    }
    
    private func setLeftTriangle() {
        let heightWidth = frame.size.width
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: heightWidth/2, y: 0))
        path.addLine(to: CGPoint(x: 0, y: heightWidth/2))
        path.addLine(to: CGPoint(x: heightWidth/2, y: heightWidth))
        path.addLine(to: CGPoint(x: heightWidth/2, y: 0))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = fillColor.cgColor
        
        layer.insertSublayer(shape, at: 0)
    }
    
    func setUpTriangle() {
        let heightWidth = frame.size.width
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: heightWidth / 2))
        path.addLine(to: CGPoint(x: heightWidth/2, y: 0))
        path.addLine(to: CGPoint(x: heightWidth, y: heightWidth / 2))
        path.addLine(to: CGPoint(x: 0, y: heightWidth / 2))
        
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = fillColor.cgColor
        
        layer.insertSublayer(shape, at: 0)
    }
}
