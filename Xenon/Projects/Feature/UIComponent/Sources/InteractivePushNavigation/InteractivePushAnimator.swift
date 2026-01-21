//
//  InteractivePushAnimator.swift
//  UIComponent
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import UIKit

class InteractivePushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromView = transitionContext.view(forKey: .from),
          let toView = transitionContext.view(forKey: .to) else {
      return
    }
    
    let containerView = transitionContext.containerView
    let screenWidth = containerView.frame.width
    
    toView.frame = containerView.frame.offsetBy(dx: screenWidth, dy: 0)
    containerView.addSubview(toView)
    
    let duration = transitionDuration(using: transitionContext)
    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: .curveEaseInOut,
      animations: {
        fromView.frame = containerView.frame.offsetBy(dx: -screenWidth * 0.3, dy: 0)
        toView.frame = containerView.frame
      },
      completion: { finished in
        if transitionContext.transitionWasCancelled {
          toView.removeFromSuperview()
        }
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    )
  }
}
