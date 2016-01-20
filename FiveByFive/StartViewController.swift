//
//  StartViewController.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/5/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import Foundation
import UIKit
import iAd
import GameKit

class StartViewController: UIViewController, GKGameCenterControllerDelegate, ADBannerViewDelegate {
    
    let DailyNotification = UILocalNotification()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var leaderBoardID = NSString()
    var gameCenterEnabled = false
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        var free_coins = defaults.integerForKey(DefaultKeys.FreeCoins.description)
        
        let flags: NSCalendarUnit = [.Day, .Month, .Year]
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        
        let saved_day = defaults.integerForKey(DefaultKeys.Day.description)
        let saved_month = defaults.integerForKey(DefaultKeys.Month.description)
        let saved_year = defaults.integerForKey(DefaultKeys.Year.description)
        
        if free_coins == 1 {
            if day > saved_day {
                free_coins = 0
            } else if day < saved_day {
                if month > saved_month {
                    free_coins = 0
                } else if month < saved_month {
                    if year > saved_year {
                        free_coins = 0
                    }
                }
    
            }
        }
        defaults.setInteger(free_coins, forKey: DefaultKeys.FreeCoins.description)
        defaults.synchronize()
        
        self.checkAdsOn()
        
        self.authenticateLocalPlayer()
        setUIUserNotificationOptions()
        

//        if freeCoins == 1 {
//            UIApplication.sharedApplication().cancelLocalNotification(DailyNotification)
//        }
    }
    override func viewDidAppear(animated: Bool) {
        self.checkAdsOn()
    }
    override func shouldAutorotate() -> Bool {
        return true
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
        // Release any cached data, images, etc that aren't in use.
    }

    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func showLeaderboard(sender: UIButton) {
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.viewState = GKGameCenterViewControllerState.Leaderboards
        gc.viewState = GKGameCenterViewControllerState.Achievements
        
        gc.leaderboardIdentifier = "leaderboard.highest_level"
        Flurry.logEvent("Leaderboards Shown")
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    func setUIUserNotificationOptions() {
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [UIUserNotificationType.Badge, UIUserNotificationType.Sound, UIUserNotificationType.Alert], categories: nil))
    }
    
    func setupNofications() {
        DailyNotification.timeZone = NSTimeZone.localTimeZone()
        // confirms the alert dialog box action
        DailyNotification.hasAction = true
        // defines the notification alert body text
        DailyNotification.alertBody = "Come get your free daily coins!"
        // defines the daily time interval
        DailyNotification.repeatCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        DailyNotification.repeatInterval = .Day
        // defines the notification alert button text
        DailyNotification.alertAction = "Play"
        // defines the default sound for your notification
        DailyNotification.soundName = UILocalNotificationDefaultSoundName
        // increments the badge counter
        DailyNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        // defines your firedate tomorrow at 12am ( note: extension NSDate tomorrowAt12am at the bottom )
        DailyNotification.fireDate = NSDate().date12pm
        // lets set it up
        UIApplication.sharedApplication().scheduleLocalNotification(DailyNotification)
    }
    
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer()
        //let error = NSError()
        let leaderBoardIdentifier = NSString()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            } else if localPlayer.authenticated {
                print("Authenticated", terminator: "")
                GKNotificationBanner.showBannerWithTitle("Game Center", message: ("Welcome, " + String(format: localPlayer.displayName!)) , completionHandler: {
                    self.gameCenterEnabled = true
                })
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler{(viewController, error) -> Void in
                    if error != nil {
                        print(error, terminator: "")
                    } else {
                        self.leaderBoardID = leaderBoardIdentifier
                    }
                }
            } else {
                self.gameCenterEnabled = false
                print("Game Center Not Enabled", terminator: "")
            }
        }
    }
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func reportScore(identifier:NSString) {
        if GKLocalPlayer.localPlayer().authenticated == true{
            let highScore = defaults.integerForKey(DefaultKeys.Level.description)
            let scoreReporter = GKScore(leaderboardIdentifier: identifier as String)
            scoreReporter.value = Int64(highScore)
            let scoreArray: [GKScore] = [scoreReporter]
            print("report score \(scoreReporter)")
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                if error != nil {
                    NSLog(error!.localizedDescription)
                }
            })
        }
    }
    func loadAds() {
        self.appDelegate.adView.removeFromSuperview()
        self.appDelegate.adView.delegate = nil
        self.appDelegate.adView = ADBannerView(frame: CGRect.zero)
        self.appDelegate.adView.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height - self.appDelegate.adView.frame.size.height / 2)
        self.appDelegate.adView.delegate = self
        self.appDelegate.adView.hidden = true
        view.addSubview(self.appDelegate.adView)
    }
    func checkAdsOn() {
        let ads = defaults.integerForKey(DefaultKeys.Ads.description)
        print(ads, terminator: "")
        
        if ads == 0 {
            self.appDelegate.adView.hidden = false
        } else if ads == 1 {
            self.appDelegate.adView.hidden = true
            self.appDelegate.adView.removeFromSuperview()
        }
    }
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print(defaults.integerForKey(DefaultKeys.Ads.description), terminator: "")
        
        self.checkAdsOn()
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        print("bannerViewActionDidFinish")
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        print("didFailToReceiveAdWithError")
        self.appDelegate.adView.hidden = true
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
