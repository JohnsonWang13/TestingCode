//
//  VideoPlayVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/3/26.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit
import AVKit

class VideoPlayVC: UIViewController {
    
    @IBOutlet weak var videoProgress: UIProgressView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var playTouchView: UIView!
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isPlaying: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playTouchView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(playVideo(_:)))
        playTouchView.addGestureRecognizer(tap)
        
        self.view.backgroundColor = .black
        
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        
        player = AVPlayer(url: videoURL!)
        playerLayer = AVPlayerLayer(player: player)
        playTouchView.layer.addSublayer(playerLayer)
        
        let interval = CMTime(value: 1, timescale: 7)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (progressTime) in
            
            let seconds = CMTimeGetSeconds(progressTime)
            if let duration = self.player.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                self.videoProgress.progress = Float(seconds / durationSeconds)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = CGRect(x: 0, y: 0, width: playTouchView.frame.width, height: playTouchView.frame.height)
    }
    
    @objc private func playVideo(_ sender: UITapGestureRecognizer) {
        
        if isPlaying {
            playImageView.isHidden = false
            player.pause()
        } else {
            playImageView.isHidden = true
            player.play()
        }
        
        isPlaying = !isPlaying
    }
}

extension VideoPlayVC: AVPlayerViewControllerDelegate {
    
}
