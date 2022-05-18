//
//  LeftAlignedImageBox.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 18.05.2022.
//

import Foundation
import UIKit
import PinLayout

class LeftAlignedImageBox: UIView {
    private var width: CGFloat = 0
    var image: UIImage? {
        didSet {
            imageView.image = image
            if let image = image {
                width = min(frame.height * (image.size.width / image.size.height), frame.width)
                configureSubviews()
            }
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureSubviews()
    }

    private func configureSubviews() {
        imageView.pin
            .vertically()
            .left()
            .width(width)
    }
}
