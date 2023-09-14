//
//  TransitionManager.swift
//  WeatherApp
//
//  Created by Василий Пронин on 22.07.2023.
//

import UIKit

protocol IZoomingTransitionViewController {
    func animatedView(by index: Int?, onMain: Bool?) -> UIView?
}

final class TransitionManager: NSObject {
    
    private var operation: UINavigationController.Operation = .none
    private var transitionDuration = 0.35
    private var pageIndex: Int?
    
    init(pageIndex: Int? = nil) {
        self.pageIndex = pageIndex
    }
}

extension TransitionManager {
    private func startTransition(
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        with context: UIViewControllerContextTransitioning
    ) {
        switch operation {
        case .push:
            push(
                from: fromViewController,
                to: toViewController,
                with: context
            )
        case .pop:
            pop2(
                from: fromViewController,
                to: toViewController,
                with: context
            )
        default:
            break
        }
    }
    
    private func push(
        from fromVC: UIViewController,
        to toVC: UIViewController,
        with context: UIViewControllerContextTransitioning
    ) {
        guard let initialView = (fromVC as? IZoomingTransitionViewController)?
            .animatedView(by: pageIndex, onMain: false) as? LocationCardView,
              let destinationView = (toVC as? IZoomingTransitionViewController)?
            .animatedView(by: pageIndex, onMain: true) else {
            return
        }
        toVC.view.layoutIfNeeded()
        initialView.layoutIfNeeded()
        
        let destinationViewFrame = CGRect(
            x: 0,
            y: initialView.frame.origin.y,
            width: fromVC.view.frame.width,
            height: initialView.frame.height
        )
        
        let containerView = context.containerView
        
        destinationView.frame = destinationViewFrame
        destinationView.layer.cornerRadius = initialView.layer.cornerRadius
        destinationView.layoutIfNeeded()
        destinationView.alpha = 0
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(initialView)
        containerView.addSubview(destinationView)
        
        toVC.view.isHidden = true
        
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration,
            curve: .easeInOut
        ) {
            destinationView.alpha = 1
            destinationView.frame = containerView.convert(
                toVC.view.frame,
                from: toVC.view
            )
            initialView.viewsToAnimate().forEach { $0.alpha = 0 }
            initialView.frame = containerView.convert(
                toVC.view.frame,
                from: toVC.view
            )
        }
        
        animator.addCompletion { position in
            toVC.view.isHidden = false
            initialView.removeFromSuperview()
            destinationView.removeFromSuperview()
            context.completeTransition(position == .end)
        }
        animator.startAnimation()
    }
    
    private func pop(
        from fromVC: UIViewController,
        to toVC: UIViewController,
        with context: UIViewControllerContextTransitioning
    ) {
        guard let destinationView = (toVC as? IZoomingTransitionViewController)?
            .animatedView(by: pageIndex, onMain: false) as? LocationCardView else {
            popFirstTime(from: fromVC, to: toVC, with: context)
            return
        }
        
        toVC.view.layoutIfNeeded()
        
        let destinationViewFrame = destinationView.frame
        let initialViewFrame = CGRect(
            x: 0,
            y: destinationViewFrame.origin.y,
            width: fromVC.view.frame.width,
            height: destinationViewFrame.height
        )
        
        let containerView = context.containerView
        
        destinationView.frame = fromVC.view.frame
        destinationView.layoutIfNeeded()
        destinationView.viewsToAnimate().forEach { $0.alpha = 0 }
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(destinationView)
        containerView.addSubview(fromVC.view)
        
        
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration,
            curve: .easeInOut
        ) {
            destinationView.viewsToAnimate().forEach { $0.alpha = 1 }
            destinationView.frame = destinationViewFrame
            
            fromVC.view.alpha = 0
            fromVC.view.frame = initialViewFrame
        }
        
        animator.addCompletion { position in
            destinationView.removeFromSuperview()
            fromVC.view.removeFromSuperview()
            context.completeTransition(position == .end)
        }
        
        animator.startAnimation()
    }
    
    private func pop2(
        from fromVC: UIViewController,
        to toVC: UIViewController,
        with context: UIViewControllerContextTransitioning
    ) {
        guard let initialView = (fromVC as? IZoomingTransitionViewController)?
            .animatedView(by: pageIndex, onMain: false),
              let destinationView = (toVC as? IZoomingTransitionViewController)?
            .animatedView(by: pageIndex, onMain: false) as? LocationCardView else {
            popFirstTime(from: fromVC, to: toVC, with: context)
            return
        }
        
        toVC.view.layoutIfNeeded()
        
        let destinationViewFrame = destinationView.frame
        let initialViewFrame = CGRect(
            x: 0,
            y: destinationViewFrame.origin.y,
            width: fromVC.view.frame.width,
            height: destinationViewFrame.height
        )
        
        let containerView = context.containerView
        
        destinationView.frame = fromVC.view.frame
        destinationView.layoutIfNeeded()
        destinationView.viewsToAnimate().forEach { $0.alpha = 0 }
        
        initialView.frame = fromVC.view.frame
        initialView.layoutIfNeeded()
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(destinationView)
        containerView.addSubview(initialView)
        
        
        let animator = UIViewPropertyAnimator(
            duration: transitionDuration,
            curve: .easeInOut
        ) {
            destinationView.viewsToAnimate().forEach { $0.alpha = 1 }
            destinationView.frame = destinationViewFrame
            
            initialView.alpha = 0
            initialView.frame = initialViewFrame
        }
        
        animator.addCompletion { position in
            destinationView.removeFromSuperview()
            initialView.removeFromSuperview()
            context.completeTransition(position == .end)
        }
        
        animator.startAnimation()
    }
    
    private func popFirstTime(
        from fromVC: UIViewController,
        to toVC: UIViewController,
        with context: UIViewControllerContextTransitioning
    ) {
        toVC.view.layoutIfNeeded()
        
        let containerView = context.containerView
        containerView.addSubview(toVC.view)
        
        context.completeTransition(true)
    }
}

extension TransitionManager: UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        transitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext
            .viewController(forKey: .from),
              let toViewController = transitionContext
            .viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        startTransition(
            from: fromViewController,
            to: toViewController,
            with: transitionContext
        )
    }
    
}


extension TransitionManager: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is IZoomingTransitionViewController &&
            toVC is IZoomingTransitionViewController {
            self.operation = operation
            
            return self
        }
        return nil
    }
}
