//
//  GridView.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 13.05.2022.
//

import UIKit

class GridView: UIView
{
    private var path = UIBezierPath()
    var gridWidthMultiple: CGFloat = 25
    var gridHeightMultiple: CGFloat = 25
    var startX: CGFloat = 0
    var startY: CGFloat = 0

    fileprivate var gridWidth: CGFloat
    {
        return bounds.width/CGFloat(gridWidthMultiple)
    }

    fileprivate var gridHeight: CGFloat
    {
        return bounds.height/CGFloat(gridHeightMultiple)
    }

    fileprivate func drawGrid()
    {
        path = UIBezierPath()
        path.lineWidth = 1.0

        for index in 0...Int(gridWidthMultiple)
        {
            let start = CGPoint(x: (CGFloat(index) * gridWidth) + startX, y: 0)
            let end = CGPoint(x: (CGFloat(index) * gridWidth) + startX, y: bounds.height - startY)
            path.move(to: start)
            path.addLine(to: end)
        }
        
        for index in 0...Int(gridHeightMultiple) {
            let start = CGPoint(x: startX, y: bounds.height - ((CGFloat(index) * gridHeight) + startY))
            let end = CGPoint(x: bounds.width, y: bounds.height - ((CGFloat(index) * gridHeight) + startY))
            path.move(to: start)
            path.addLine(to: end)
        }
        
        path.close()
    }

    override func draw(_ rect: CGRect)
    {
        drawGrid()
        UIColor.white.setStroke()
        path.stroke()
    }
}
