//
//  UIControl+publisher.swift
//  Sugar
//
//  Created by 김수환 on 12/29/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//


import UIKit
import Combine

extension UIControl {
    
    // MARK: - Interface
    
    public func publisher(for controlEvents: UIControl.Event) -> ControlEventPublisher {
        ControlEventPublisher(control: self, event: controlEvents)
    }
    
    // MARK: - ControlEventSubscription
    
    class ControlEventSubscription<S: Subscriber>: Subscription where S.Input == Void {
        
        private let subscriber: S?
        private let control: UIControl
        private let event: UIControl.Event
        
        init(subscriber: S, control: UIControl, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            
            control.addTarget(self, action: #selector(handleEvent(_:)), for: event)
        }
        
        // MARK: - Implement Subscription
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {}
        
        @objc
        private func handleEvent(_ sender: UIControl) {
            _ = subscriber?.receive(())
        }
    }
    
    // MARK: - InteractionPublisher
    
    public struct ControlEventPublisher: Publisher {
        
        public typealias Output = Void
        public typealias Failure = Never
        
        private let control: UIControl
        private let event: UIControl.Event
        
        init(control: UIControl, event: UIControl.Event) {
            self.control = control
            self.event = event
        }
        
        public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = ControlEventSubscription(
                subscriber: subscriber,
                control: control,
                event: event
            )
            
            subscriber.receive(subscription: subscription)
        }
    }
}
