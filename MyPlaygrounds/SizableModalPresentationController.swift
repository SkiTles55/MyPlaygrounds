//
//  SizableModalPresentationController.swift
//  MyPlaygrounds
//
//  Created by Dmitry on 10.09.2022.
//

import Foundation
import UIKit

@objc protocol SizableModalPresentationControllerDelegate: AnyObject {
    @objc optional func onSizableModalDismiss()
    
    @objc optional func sizableModalCalculateSize(for viewController: UIViewController, initialSize: CGRect) -> CGRect
}

@objc class SizableModalPresentationController: UIPresentationController {
    @objc weak var modalDelegate: SizableModalPresentationControllerDelegate?
    
    let isDismissable: Bool
    
    @objc var autoSize: Bool = true
    
    private let interactor = UIPercentDrivenInteractiveTransition()
    private let dimmingView = UIView()
    private var propertyAnimator: UIViewPropertyAnimator!
    
    private let dragPaneEnabled: Bool
    
    private var dragPane: UIView?
    
    private var isInteractive: Bool = false
    
    private var scrollView: UIScrollView? {
        presentedView?.firstSubview(of: UIScrollView.self)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        if let rect = modalDelegate?.sizableModalCalculateSize?(for: presentedViewController, initialSize: super.frameOfPresentedViewInContainerView) {
            return rect
        } else if autoSize {
            return calculatePresnetedFrame()
        } else {
            var frame = super.frameOfPresentedViewInContainerView
            
            let height = containerView?.bounds.height ?? frame.height
            
            frame.size.height = height - UIApplication.statusBarHeight - 20.0
            
            frame.origin.y = height - frame.height
            
            return frame
        }
    }
    
    private func calculatePresnetedFrame() -> CGRect {
        guard let containerBounds = containerView?.bounds else { return .zero }
        
        var frame = containerBounds
        frame.size.height = min(presentedViewController.preferredHeight + (containerView?.safeAreaInsets.bottom ?? 0), containerBounds.height - UIApplication.statusBarHeight - 20)
        frame.origin.y = containerBounds.height - frame.size.height
        
        return frame
    }
    
    private let topOffset = UIApplication.statusBarHeight + 20
    
    @objc
    init(presentedViewController: UIViewController,
         presentingViewController: UIViewController?,
         isDismissable: Bool,
         addDragPane: Bool) {
        self.isDismissable = isDismissable
        
        self.dragPaneEnabled = addDragPane
        
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
    }
    
    deinit {
        if dimmingView.superview != nil {
            dimmingView.removeFromSuperview()
        }
        
        if let dragPane = dragPane,
           dragPane.superview != nil {
            dragPane.removeFromSuperview()
        }
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerBounds = containerView?.bounds, let presentedView = presentedView else { return }
            
        // Configure the presented view.
        containerView?.addSubview(presentedView)
        presentedView.layoutIfNeeded()
        presentedView.frame = frameOfPresentedViewInContainerView
        presentedView.frame.origin.y = containerBounds.height
        
        // Add a dimming view below the presented view controller.
        dimmingView.backgroundColor = .black
        dimmingView.frame = containerBounds
        dimmingView.alpha = 0
        containerView?.insertSubview(dimmingView, at: 0)
        
        if dragPaneEnabled {
            let dragPane = UIView()
            dragPane.backgroundColor = .white
            dragPane.layer.cornerRadius = 2.5
            dragPane.translatesAutoresizingMaskIntoConstraints = false
            
            presentedView.addSubview(dragPane)
            
            dragPane.widthAnchor.constraint(equalToConstant: 134.0).isActive = true
            dragPane.heightAnchor.constraint(equalToConstant: 5.0).isActive = true
            dragPane.centerXAnchor.constraint(equalTo: presentedView.centerXAnchor).isActive = true
            dragPane.bottomAnchor.constraint(equalTo: presentedView.topAnchor, constant: -8.0).isActive = true
            self.dragPane = dragPane
            dragPane.alpha = 0
        }
        
        // Add pan gesture recognizers for interactive dismissal.
        presentedView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
        
        
        scrollView?.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        
        // Add tap recognizer for dismissal.
        if isDismissable {
            dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
            dimmingView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
        }
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.dimmingView.alpha = 0.5
            self.dragPane?.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
            self.dimmingView.alpha = 0
            self.dragPane?.alpha = 0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            modalDelegate?.onSizableModalDismiss?()
            dragPane?.removeFromSuperview()
            propertyAnimator = nil
        }
    }
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        if propertyAnimator != nil && !propertyAnimator.isRunning {
            // Respond to height changes in the child view controller.
            let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: UISpringTimingParameters(dampingRatio: 1.0))
            animator.addAnimations {
                self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            }
            animator.startAnimation()
        }
    }
    
    @objc private func dismiss() {
        presentedView?.endEditing(true)
        presentedViewController.dismiss(animated: true)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard isDismissable, let containerView = containerView else { return }
        
        limitScrollView(gesture)
        
        let percent = gesture.translation(in: containerView).y / containerView.bounds.height
        switch gesture.state {
        case .began:
            if !presentedViewController.isBeingDismissed && (scrollView?.contentOffset.y ?? 0) <= 0 {
                isInteractive = true
                presentedViewController.dismiss(animated: true)
            }
        case .changed:
            if isInteractive {
                interactor.update(percent)
            }
        case .cancelled:
            if isInteractive {
                interactor.cancel()
                isInteractive = false
            }
        case .ended:
            if isInteractive {
                let velocity = gesture.velocity(in: containerView).y
                interactor.completionSpeed = 0.9
                if percent > 0.3 || velocity > 1600 {
                    interactor.finish()
                } else {
                    interactor.cancel()
                }
                isInteractive = false
            }
        default:
            break
        }
    }

    private func limitScrollView(_ gesture: UIPanGestureRecognizer) {
        guard let scrollView = scrollView else { return }
        if interactor.percentComplete > 0 {
            // Don't let the scroll view scroll while dismissing.
            scrollView.contentOffset.y = -scrollView.adjustedContentInset.top
        }
    }

}

// MARK: UIViewControllerAnimatedTransitioning
extension SizableModalPresentationController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        propertyAnimator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext),
                                                  timingParameters: UISpringTimingParameters(dampingRatio: 1.0,
                                                                                            initialVelocity: CGVector(dx: 1, dy: 1)))
        propertyAnimator.addAnimations { [unowned self] in
            if self.presentedViewController.isBeingPresented {
                transitionContext.view(forKey: .to)?.frame = self.frameOfPresentedViewInContainerView
            } else {
                transitionContext.view(forKey: .from)?.frame.origin.y = transitionContext.containerView.frame.maxY
            }
        }
        propertyAnimator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        return propertyAnimator
    }
}

// MARK: UIViewControllerTransitioningDelegate
extension SizableModalPresentationController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        isInteractive ? interactor : nil
    }

}

private extension UIView {
    var allSubviews: [UIView] {
        subviews + subviews.flatMap { $0.allSubviews }
    }
    
    func firstSubview<T: UIView>(of type: T.Type) -> T? {
        allSubviews.first(where: { $0 is T }) as? T
    }
}

private extension UIApplication {
    static var statusBarHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
}

private extension UIViewController {
    
    /// Return the preferred height of the view controller, taking scrollviews into account.
    var preferredHeight: CGFloat {
        /// If the view controller provides it's own preferred size, use it.
        if let nav = self as? UINavigationController {
            guard let vc = nav.visibleViewController,
                  !vc.isKind(of: UIAlertController.self) else {
                return self.view.frame.size.height
            }
            
            return definePreferredHeight(for: vc)
        }
        return definePreferredHeight(for: self)
    }
    
    private func definePreferredHeight(for vc: UIViewController) -> CGFloat {
        if (vc.preferredContentSize.height > 0) {
            return vc.preferredContentSize.height
        }
        
        return calculatePreferredHeight(for: vc.view)
    }
    
    func calculatePreferredHeight(for view: UIView) -> CGFloat {
        // Insets are all zero intially, but once setup they will influence the results of the systemLayoutSizeFitting method.
        let insets = view.safeAreaInsets.top + view.safeAreaInsets.bottom
        // We substract the insets from the height to always get the actual height of only the view itself.
        
        view.layoutIfNeeded()
        
        var height = max(0, view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height - insets)
                
        // Support for UITableViewControllers.
        if let tableView = view as? UITableView {
            height += tableView.contentSize.height + tableView.contentInset.top + tableView.contentInset.bottom
            return height
        }
        
        // Include scroll views in the height calculation.
        
        let subviews = view.subviews
        
        height += subviews.filter { $0 is UIScrollView }.reduce(CGFloat(0), { result, view in
            if view.intrinsicContentSize.height <= 0 {
                // If a scroll view does not have an intrinsic content size set, use the content size.
                let scrollView = view as! UIScrollView
                return result + scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom
            } else {
                return result
            }
        })
                
        return height
    }
}

@objc
extension UIViewController {
    @objc
    func requestHeightUpdate() {
        // Set the preferredContentSize to force a preferredContentSizeDidChange call in the parent.
        preferredContentSize.height += 1
        preferredContentSize.height = 0
    }
}
