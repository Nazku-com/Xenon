//
//  SlideTransitionManager.swift
//  UIComponent
//
//  Created by 김수환 on 1/11/26.
//  Copyright © 2026 social.xenon. All rights reserved.
//

import UIKit

public class SlideTransitionManager: NSObject, UIViewControllerTransitioningDelegate {
    
    private let interactionController = SwipeInteractionController()
    
    // 1. Tell UIKit we want a custom presentation animation
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator(isPresenting: true)
    }
    
    // 2. Tell UIKit we want a custom dismissal animation
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideAnimator(isPresenting: false)
    }
    
    // 3. Tell UIKit to make the dismissal interactive (if a swipe is happening)
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController.interactionInProgress ? interactionController : nil
    }
    
    // Helper to attach the gesture to the View Controller
    public func apply(to viewController: UIViewController) {
        viewController.transitioningDelegate = self
        viewController.modalPresentationStyle = .fullScreen
        interactionController.wireToViewController(viewController: viewController)
    }
}

// --- The Animator (Handles the visual slide) ---
class SlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else { return }
        
        let container = transitionContext.containerView
        let width = container.frame.width
        
        if isPresenting {
            container.addSubview(toView)
            toView.frame = container.frame.offsetBy(dx: width, dy: 0) // Start off-screen right
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                toView.frame = container.frame // Slide in
                fromView.frame = container.frame.offsetBy(dx: -width * 0.3, dy: 0) // Parallax effect
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        } else {
            // Dismissal
            container.insertSubview(toView, belowSubview: fromView)
            toView.frame = container.frame.offsetBy(dx: -width * 0.3, dy: 0) // Start slightly left
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0,
                           options: .curveLinear,
                           animations: {
                fromView.frame = container.frame.offsetBy(dx: width, dy: 0) // Slide out right
                toView.frame = container.frame // Slide back in
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
}

// --- The Interaction Controller (Handles the gesture) ---
class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    private weak var viewController: UIViewController?
    
    func wireToViewController(viewController: UIViewController) {
        self.viewController = viewController
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = .left // Only swipe from left edge
        viewController.view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard let view = gestureRecognizer.view else { return }
        
        let translation = gestureRecognizer.translation(in: view)
        let progress = translation.x / view.bounds.width
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController?.dismiss(animated: true)
        case .changed:
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if progress > 0.3 || gestureRecognizer.velocity(in: view).x > 300 {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}
