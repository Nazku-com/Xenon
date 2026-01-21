//
//  GifPlayer.swift
//  UIComponent
//
//  Created by 김수환 on 3/16/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI
import NetworkingFeature
import AVKit

public struct GifPlayer: UIViewRepresentable {
    
    public typealias UIViewType = LoopingPlayerUIView
    
    public func makeUIView(context: Context) -> LoopingPlayerUIView {
        return LoopingPlayerUIView(url: url, height: height)
    }
    
    public func updateUIView(_ uiView: LoopingPlayerUIView, context: Context) {}
    
    private let url: URL
    private let height: CGFloat
    
    init(url: URL, height: CGFloat) {
        self.url = url
        self.height = height
    }
}

public final class LoopingPlayerUIView: UIView {
    
    private var playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    private var player = AVQueuePlayer()
    
    init(url: URL, height: CGFloat) {
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        
        super.init(frame: .zero)
        
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)
        
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        player.play()
        setUpFrame(asset: asset, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func setUpFrame(asset: AVAsset, height: CGFloat) {
        Task { @BackgroundActor in
            if let track = asset.tracks(withMediaType: .video).first {
                let size = track.naturalSize.applying(track.preferredTransform)
                let aspectedSize = CGSize(width: size.width * height / size.height, height: height)
                await playerLayer.frame.size = aspectedSize
            }
        }
    }
}
