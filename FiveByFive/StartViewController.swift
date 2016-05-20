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

class StartViewController: UIViewController, GKGameCenterControllerDelegate, GADInterstitialDelegate {
    
    var videoInterstitial:GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGoogleInterstitialAds()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(presentAuthenticationVC),
                                                         name: Constants.Notifications.PRESENT_AUTH_VC, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showLeaderboard),
                                                         name: Constants.Notifications.PRESENT_LEADERBOARDS, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(presentGoogleInterstitial),
                                                         name: Constants.Notifications.PRESENT_INTERSTITIAL, object: nil)

        if let scene = StartScene(fileNamed: "StartScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            skView.presentScene(scene)
        }
    }
    override func viewDidAppear(animated: Bool) {

    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    // MARK: AdMob Functions
    private func setupGoogleInterstitialAds() {
        videoInterstitial = createAndLoadInterstitial()

    }
    private func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: Constants.googleInterstitialAdsID)
        interstitial.delegate = self
        let request = GADRequest()
        request.testDevices = ["f5cab6107619930570354d4c8c838ee5",kGADSimulatorID]
        interstitial.loadRequest(request)
        return interstitial
    }
    func presentGoogleInterstitial() {
        if videoInterstitial.isReady {
            videoInterstitial.presentFromRootViewController(self)
        }
    }
    func interstitialWillLeaveApplication(ad: GADInterstitial!) {
        if let scene:StartScene = StartScene(fileNamed: "StartScene") {
            scene.addCoinsFromAd(20)
        }
        videoInterstitial = createAndLoadInterstitial()
    }
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        if let scene:StartScene = StartScene(fileNamed: "StartScene") {
            scene.addCoinsFromAd(20)
        }
        videoInterstitial = createAndLoadInterstitial()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory Warning coming from Start View Controller")
        // Release any cached data, images, etc that aren't in use.
    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func showLeaderboard() {
        print("Present Leaderboard")
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
    
}
extension NSDate {
    var minute:  Int { return NSCalendar.currentCalendar().components(.Minute,  fromDate: self).minute  }
    var hour:  Int { return NSCalendar.currentCalendar().components(.Hour,  fromDate: self).hour  }
    var day:   Int { return NSCalendar.currentCalendar().components(.Day,   fromDate: self).day   }
    var month: Int { return NSCalendar.currentCalendar().components(.Month, fromDate: self).month }
    var year:  Int { return NSCalendar.currentCalendar().components(.Year,  fromDate: self).year  }
    var date12pm: NSDate {
        return  NSCalendar.currentCalendar().dateWithEra(1, year: year, month: month, day: day+1, hour: 12, minute: 0, second: 0, nanosecond: 0)!
    }
}
