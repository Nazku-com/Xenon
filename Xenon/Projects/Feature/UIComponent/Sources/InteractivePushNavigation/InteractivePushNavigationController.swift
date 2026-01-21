//
//  InteractivePushNavigationController.swift
//  UIComponent
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import UIKit

public class InteractivePushNavigationController: UINavigationController {
    private var interactivePushGestureRecognizer: UIPanGestureRecognizer?
    private var percentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition?
    private var destinationViewController: UIViewController?
    private let pushAnimator = InteractivePushAnimator()
    
    private static let gestureVelocityThreshold: CGFloat = 500.0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setupInteractivePush(to viewController: UIViewController) {
        destinationViewController = viewController
        delegate = self
        
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleInteractivePushGesture(_:))
        )
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
        interactivePushGestureRecognizer = gesture
    }
    
    @objc private func handleInteractivePushGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        guard let view = self.view else { return }
        
        let progress = -gestureRecognizer.translation(in: view).x / view.frame.width
        
        switch gestureRecognizer.state {
        case .began:
            guard let destination = destinationViewController else { return }
            pushViewController(destination, animated: true)
            
        case .changed:
            percentDrivenInteractiveTransition?.update(progress)
            
        case .ended:
            let velocity = gestureRecognizer.velocity(in: view).x
            if velocity < 0.0 && (progress > 0.5 || velocity < -Self.gestureVelocityThreshold) {
                percentDrivenInteractiveTransition?.finish()
            } else {
                percentDrivenInteractiveTransition?.cancel()
            }
            
        default:
            percentDrivenInteractiveTransition?.cancel()
        }
    }
}

extension InteractivePushNavigationController: UINavigationControllerDelegate {
    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return operation == .push ? pushAnimator : nil
    }
    
    public func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        if interactivePushGestureRecognizer?.state == .began {
            percentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
            percentDrivenInteractiveTransition?.completionCurve = .easeOut
            return percentDrivenInteractiveTransition
        }
        return nil
    }
}

extension InteractivePushNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        false
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === interactivePopGestureRecognizer {
            return viewControllers.count > 1
        }
        if gestureRecognizer === interactivePushGestureRecognizer {
            guard let destination = destinationViewController else { return false }
            guard gestureRecognizer.location(in: view).x > view.frame.size.width / 2 else { return false }
            return topViewController !== destination && !viewControllers.contains(destination)
        }
        return false
    }
}
