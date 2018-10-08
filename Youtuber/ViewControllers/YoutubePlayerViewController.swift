//
//  YoutubePlayerViewController.swift
//  Youtuber
//
//  Created by Fernando Cañón on 10/7/18.
//  Copyright © 2018 Fernando Cañón. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YoutubePlayerViewController: UIViewController {

    @IBOutlet var playerView:YTPlayerView!
    var model:Video?

    override func viewDidLoad() {
        super.viewDidLoad()
        startVideo()
    }
    
    func startVideo()  {
        guard let videoId = model?.videoId else { return }
        playerView.load(withVideoId:videoId )
    }
}
