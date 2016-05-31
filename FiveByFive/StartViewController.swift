//
//  StartViewController.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/5/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit
import FirebaseAnalytics

class StartViewController: UIViewController, GKGameCenterControllerDelegate, GADRewardBasedVideoAdDelegate,GameDataProtocol /*GADInterstitialDelegate,*/ {
    static let adWatchReward = 25
    
    //var videoInterstitial:GADInterstitial!
    var rewardedInterstitial:GADRewardBasedVideoAd!
    var interstitialLoading:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        if !self.interstitialLoading && !GADRewardBasedVideoAd.sharedInstance().ready {
            requestRewardedVideo()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(presentAuthenticationVC),
                                                         name: Constants.Notifications.PRESENT_AUTH_VC, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showLeaderboard),
                                                         name: Constants.Notifications.PRESENT_LEADERBOARDS, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(presentRewardedInterstitial),
                                                         name: Constants.Notifications.PRESENT_INTERSTITIAL, object: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let scene = StartScene(fileNamed: "StartScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            scene.size = skView.bounds.size
            /* Set the scale mode to scale to fit the window */
            let os = NSProcessInfo().operatingSystemVersion
            switch (os.majorVersion, os.minorVersion, os.patchVersion) {
            case (8, 0, _):
                print("iOS >= 8.0.0, < 8.1.0")
                scene.scaleMode = .Fill
            case (8, _, _):
                print("iOS >= 8.1.0, < 9.0")
                scene.scaleMode = .AspectFill
            case (9, _, _):
                print("iOS >= 9.0.0")
                scene.scaleMode = .ResizeFill
            default:
                // this code will have already crashed on iOS 7, so >= iOS 10.0
                scene.scaleMode = .ResizeFill
                print("iOS >= 10.0.0")
            }
            
            skView.presentScene(scene)
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let skView = self.view as! SKView
        skView.presentScene(nil)
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    // MARK: AdMob Rewarded Interstitial
    func presentRewardedInterstitial() {
        if GADRewardBasedVideoAd.sharedInstance().ready {
            
            GADRewardBasedVideoAd.sharedInstance().presentFromRootViewController(self)
        } else {
            let alert = UIAlertController(title: "Video Not Ready", message: "Please try again later.", preferredStyle: UIAlertControllerStyle.Alert)
            let dismissAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                print("Alert View Dismissed")
            }
            alert.addAction(dismissAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    func requestRewardedVideo() {
        self.interstitialLoading = true
        let request:GADRequest = GADRequest()
        //request.testDevices = ["f5cab6107619930570354d4c8c838ee5",kGADSimulatorID]
        GADRewardBasedVideoAd.sharedInstance().loadRequest(request, withAdUnitID: Constants.rewardedInterstitialAdsID)
        print("Loading Video Ad")
    }
    func rewardBasedVideoAdDidReceiveAd(rewardBasedVideoAd: GADRewardBasedVideoAd!) {
        self.interstitialLoading = false
        print("Reward video ad is recieved")
    }
    func rewardBasedVideoAdDidOpen(rewardBasedVideoAd: GADRewardBasedVideoAd!) {
        FIRAnalytics.logEventWithName("Video Ad Watched", parameters: nil)
        print("Reward Video opened")
    }
    func rewardBasedVideoAdDidStartPlaying(rewardBasedVideoAd: GADRewardBasedVideoAd!) {
        print("Reward Video started playing")
    }
    func rewardBasedVideoAdDidClose(rewardBasedVideoAd: GADRewardBasedVideoAd!) {
        print("Reward Video closed")
        requestRewardedVideo()
    }
    func rewardBasedVideoAd(rewardBasedVideoAd: GADRewardBasedVideoAd!, didRewardUserWithReward reward: GADAdReward!) {
        //ERROR HERE
//        if let scene:StartScene = StartScene(fileNamed: "StartScene") {
//            scene.addCoinsFromAd(reward.amount.integerValue)
//            print("User Rewarded")
//            scene.gameData.printData()
//            FIRAnalytics.logEventWithName("Video_Ad_Watched", parameters: nil)
//        }
        //requestRewardedVideo()
        let gameData = loadInstance()
        gameData.addCoins(reward.amount.integerValue)
        saveGame(gameData)
        FIRAnalytics.logEventWithName("Video_Ad_Watched", parameters: nil)
    }
    func rewardBasedVideoAdWillLeaveApplication(rewardBasedVideoAd: GADRewardBasedVideoAd!) {
        print("Reward Video will leave application")
    }
    func rewardBasedVideoAd(rewardBasedVideoAd: GADRewardBasedVideoAd!, didFailToLoadWithError error: NSError!) {
        self.interstitialLoading = false
        print("Reward Video failed to load")
        //requestRewardedVideo()
    }
    
    // MARK: Game Center Helper
    func presentAuthenticationVC() {
        let helper = GameKitHelper.sharedGameKitHelper
        self.presentViewController(helper.authenticationVC!, animated: true, completion: nil)
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    func showLeaderboard() {
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.viewState = GKGameCenterViewControllerState.Leaderboards
        gc.viewState = GKGameCenterViewControllerState.Achievements
        gc.leaderboardIdentifier = "leaderboards.highest_score"
        self.presentViewController(gc, animated: true, completion: nil)
    }
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: Game Data Protocol
    func saveGame(withData:GameData) {
        let encodedData = NSKeyedArchiver.archiveRootObject(withData, toFile: GameData.archiveURL.path!)
        if !encodedData {
            print("Save Failed")
        }
    }
    
    func loadInstance() -> GameData {
        let data = NSKeyedUnarchiver.unarchiveObjectWithFile(GameData.archiveURL.path!) as? GameData
        if data == nil {
            print("Data could not be loaded properly")
            return GameData()
        }
        return data!
    }
}
