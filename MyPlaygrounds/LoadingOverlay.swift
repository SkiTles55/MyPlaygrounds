//
//  LoadingOverlay.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 26.04.2022.
//

import UIKit
import PinLayout

public class LoadingOverlay {
    var loader = LoaderView()

    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }

    public func show() {
        loader.removeFromSuperview()
        loader.frame = UIScreen.main.bounds
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(loader)
        loader.activityIndicator.startAnimating()
    }

    public func hide() {
        loader.activityIndicator.stopAnimating()
        loader.removeFromSuperview()
    }
}

class LoaderView: UIView {
    let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.layer.cornerRadius = 10
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = UIActivityIndicatorView.Style.large
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(overlayView)
        overlayView.addSubview(activityIndicator)
        
        backgroundColor = UIColor("242424", alpha: 0.4)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        overlayView.pin
            .width(80)
            .height(80)
            .vCenter()
            .hCenter()
        
        activityIndicator.pin
            .width(40)
            .height(40)
            .vCenter()
            .hCenter()
    }
}
