//
//  GridView.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 13.05.2022.
//

import UIKit

class GridView: UIView {
    private var path = UIBezierPath()
    private var gridColor = UIColor.lightGray
    var gridWidthMultiple: CGFloat = 25
    var gridHeightMultiple: CGFloat = 25
    var startX: CGFloat = 0
    var startY: CGFloat = 0

    fileprivate var gridWidth: CGFloat {
        return (bounds.width - startX) / CGFloat(gridWidthMultiple)
    }

    fileprivate var gridHeight: CGFloat {
        return (bounds.height - startY) / CGFloat(gridHeightMultiple)
    }
    
    fileprivate var labelAttributes: [NSAttributedString.Key : NSObject] {
        return [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 10),
            NSAttributedString.Key.foregroundColor : gridColor
        ]
    }

    fileprivate func drawGrid() {
        path = UIBezierPath()
        path.lineWidth = 0.5

        for index in 0...Int(gridWidthMultiple)
        {
            let start = CGPoint(x: (CGFloat(index) * gridWidth) + startX, y: 0)
            let end = CGPoint(x: (CGFloat(index) * gridWidth) + startX, y: bounds.height - startY)
            path.move(to: start)
            path.addLine(to: end)
            if (gridWidthMultiple > 20 && index % 3 == 0) || gridWidthMultiple <= 20 {
                drawXLabel(text: index == 0 ? "X" : "\(index)", point: end)
            }
        }
        
        for index in 0...Int(gridHeightMultiple) {
            let start = CGPoint(x: startX, y: bounds.height - ((CGFloat(index) * gridHeight) + startY))
            let end = CGPoint(x: bounds.width, y: bounds.height - ((CGFloat(index) * gridHeight) + startY))
            path.move(to: start)
            path.addLine(to: end)
            if (gridHeightMultiple > 10 && index % 2 == 0) || gridHeightMultiple <= 10 {
                drawYLabel(text: index == 0 ? "Y" : "\(index)", point: start)
            }
        }
        
        path.close()
    }
    
    private func drawXLabel(text: String, point: CGPoint) {
        let string = text as NSString
        let stringSize = string.size(withAttributes: labelAttributes)
        string.draw(
            in: CGRect(x: point.x - (stringSize.width / 2), y: point.y + 3, width: stringSize.width, height: stringSize.height),
            withAttributes: labelAttributes
        )
    }
    
    private func drawYLabel(text: String, point: CGPoint) {
        let string = text as NSString
        let stringSize = string.size(withAttributes: labelAttributes)
        string.draw(
            in: CGRect(x: point.x - stringSize.width - 3, y: point.y - (stringSize.height / 2), width: stringSize.width, height: stringSize.height),
            withAttributes: labelAttributes
        )
    }

    override func draw(_ rect: CGRect) {
        drawGrid()
        gridColor.setStroke()
        path.stroke()
    }
}
