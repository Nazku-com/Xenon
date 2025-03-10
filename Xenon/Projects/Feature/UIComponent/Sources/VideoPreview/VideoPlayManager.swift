//
//  VideoPlayManager.swift
//  UIComponent
//
//  Created by 김수환 on 3/10/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import UIKit
import AVKit

final class VideoPlayManager {
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        guard let window = UIApplication.shared.firstKeyWindow else {
            return
        }
        DispatchQueue.main.async {
            window.rootViewController?.present(playerViewController, animated: true)
            playerViewController.player?.play()
        }
    }
}
