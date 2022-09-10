//
//  VCSwitcherViewController.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 10.09.2022.
//

import Foundation
import UIKit

class VCSwitcherViewController: UIViewController {
//    @IBOutlet private weak var segmentedControl: FintapSegmentedControl!
    @IBOutlet private weak var container: UIView!
    
    var viewControllers: [(String, UIViewController)] = []
    
    private var currentIndex: Int = -1
    
    private var animationRunned = false {
        didSet {
//            segmentedControl.isUserInteractionEnabled = !animationRunned
            container.isUserInteractionEnabled = !animationRunned
        }
    }
    
    override func viewDidLoad() {
//        viewControllers = getVCs()
        setupVCSwitcher()
        setupUI()
//        segmentedControl.segmentChanged = { [weak self] index in
//            self?.changeView(index)
//        }
//        segmentedControl.selectedIndex = 0
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupUI()
    }
    
    private func setupVCSwitcher() {
//        segmentedControl.segments = viewControllers.map { $0.0 }
    }
    
    private func add(asChildViewController viewController: UIViewController, _ frame: CGRect) {
        addChild(viewController)
        container.addSubview(viewController.view)
        viewController.view.frame = frame
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func setupUI() {
        container.backgroundColor = .clear
        view.isLightMode ? setLightModeUI() : setDarkModeUI()
    }
    
    private func changeView(_ index: Int) {
        guard currentIndex != index,
              viewControllers.count > index else { return }
        let vc = viewControllers[index].1
        
        if currentIndex == -1 {
            add(asChildViewController: vc, CGRect(origin: .zero, size: container.frame.size))
            currentIndex = index
            return
        }
        
        let rightFrame = CGRect(origin: CGPoint(x: container.frame.maxX, y: 0), size: container.frame.size)
        let leftFrame = CGRect(origin: CGPoint(x: 0 - container.frame.width, y: 0), size: container.frame.size)
        
        if index > currentIndex {
            animatedChangeView(newVc: vc, newVcFrame: rightFrame, oldVcFrame: leftFrame, newIndex: index)
            return
        }
        
        if index < currentIndex {
            animatedChangeView(newVc: vc, newVcFrame: leftFrame, oldVcFrame: rightFrame, newIndex: index)
            return
        }
    }
    
    private func animatedChangeView(newVc: UIViewController, newVcFrame: CGRect, oldVcFrame: CGRect, newIndex: Int) {
        add(asChildViewController: newVc, newVcFrame)
        animationRunned = true
        let currentVC = viewControllers[currentIndex].1
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.1,
                       options: .beginFromCurrentState,
                       animations: { [unowned self] in
            currentVC.view.frame = oldVcFrame
            newVc.view.frame = CGRect(origin: .zero, size: container.frame.size)
        }, completion: { [unowned self] _ in
            remove(asChildViewController: currentVC)
            currentIndex = newIndex
            animationRunned = false
        })
    }
}

extension VCSwitcherViewController {
    public func setDarkModeUI() {
//        view.backgroundColor = .darkBackground95
    }
    
    public func setLightModeUI() {
//        view.backgroundColor = .lightBackground95
    }
}
