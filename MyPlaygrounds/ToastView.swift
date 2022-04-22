//
//  ToastView.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 21.04.2022.
//

import Foundation
import UIKit
import PinLayout

class ToastView: UIView {
    var color = UIColor("009999")
    var height: CGFloat = 48
    var image = #imageLiteral(resourceName: "venue-icon")
    var text = ""
    
    let triangleView = TriangleView()
    
    let messageView = UIView()
    
    let icon = UIImageView()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubviews(triangleView, messageView, icon, label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureSubviews()
    }

    private func configureSubviews() {
        triangleView.fillColor = color
        messageView.backgroundColor = color
        messageView.layer.cornerRadius = height / 8
        icon.image = image
        label.text = text
        
        triangleView.pin
            .left()
            .vCenter()
            .width(height / 3)
            .height(height / 3)
        
        messageView.pin
            .left(to: triangleView.edge.hCenter)
            .top()
            .bottom()
            .right()
            .height(height)
        
        icon.pin
            .left(to: messageView.edge.left)
            .marginLeft(10)
            .vCenter()
            .width(height / 3)
            .height(height / 3)
        
        label.pin
            .after(of: icon, aligned: .center)
            .marginLeft(10)
            .sizeToFit()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        .init(width: label.frame.maxX + 10, height: messageView.frame.maxY)
    }
    
    func fadeIn(_ duration: TimeInterval? = 0.8, onCompletion: (() -> Void)? = nil) {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 1 },
                       completion: { _ in if let complete = onCompletion { complete() } }
        )
    }
    
    func fadeOut(_ duration: TimeInterval? = 0.6) {
        UIView.animate(withDuration: duration!,
                       animations: { self.alpha = 0 },
                       completion: { _ in self.isHidden = true }
        )
    }
}
