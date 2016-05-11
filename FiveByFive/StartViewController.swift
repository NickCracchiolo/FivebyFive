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

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(presentAuthenticationVC), name: Constants.Notifications.PRESENT_AUTH_VC, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showLeaderboard), name: Constants.Notifications.PRESENT_LEADERBOARDS, object: nil)
        setUpDailyNotifications()
        
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
        
        //self.checkAdsOn()
        
        setUIUserNotificationOptions()
        

//        if freeCoins == 1 {
//            UIApplication.sharedApplication().cancelLocalNotification(DailyNotification)
//        }
    }
    override func viewDidAppear(animated: Bool) {
        //self.checkAdsOn()
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    private func setUpDailyNotifications() {
        let defaults = NSUserDefaults.standardUserDefaults()
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
    }
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
