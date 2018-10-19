//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by Pankaj Gondaliya on 10/19/18.
//  Copyright © 2018 Pankaj Gondaliya. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AVKit
import AVFoundation

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    @IBOutlet var imageView: UIImageView!
    
    // init video background and its path
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        
        //For Local Notification
        if(content.categoryIdentifier != "") {
            if(content.attachments.count>0) {
                let attachments = content.attachments[0]
                if(notification.request.identifier == "IMAGE") {
                    print(attachments.url)
                    //attachments.url.stopAccessingSecurityScopedResource()
                    // imageView.image = UIImage(contentsOfFile: attachments.url.path)
                    let imageData = NSData(contentsOf: attachments.url)
                    if(imageData != nil) {
                        let image = UIImage(data: imageData! as Data)
                        imageView.image = image
                    } else {
                        imageView.image = #imageLiteral(resourceName: "smallImage.jpg")
                    }
                } else {
                    //VIDEO
                    playVideo(videoURL: attachments.url)
                }
            }
        }
    }
}

extension NotificationViewController {
    func playVideo(videoURL: URL) {
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        //        player?.isMuted = true
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        playerLayer.frame = view.frame
        //Add observer to detect the end of the video
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationViewController.playerItemReachedEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        view.layer.addSublayer(playerLayer)
        player?.play()
    }
    
    //MARK: Play Video
    @objc fileprivate func playerItemReachedEnd(){
        // this works like a rewind button. It starts the player over from the beginning
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
}
