//
//  SettingsViewController.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/6/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import Foundation
import UIKit
import iAd



class SettingsViewController: UIViewController, ADBannerViewDelegate {
    @IBOutlet weak var ResetSwitchObject: UISwitch!
    @IBOutlet weak var NotSwitchObject: UISwitch!
    @IBOutlet weak var SoundsSwitchOutlet: UISwitch!
    @IBOutlet weak var SaveLifeOutlet: UISwitch!
    
    
    @IBOutlet weak var BackGesture: UIScreenEdgePanGestureRecognizer!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        var notif_bool:Bool = true
        var sounds_bool:Bool = true
        var save_bool:Bool = true
        
        if defaults.integerForKey(DefaultKeys.Notifications.description) == 0 {
            notif_bool = true
        } else if defaults.integerForKey(DefaultKeys.Notifications.description) == 1 {
            notif_bool = false
        }
        
        if defaults.integerForKey(DefaultKeys.Sound.description) == 0 {
            sounds_bool = true
        } else if defaults.integerForKey(DefaultKeys.Sound.description) == 1 {
            sounds_bool = false
        }
        
        if defaults.integerForKey(DefaultKeys.Life.description) == 0 {
            save_bool = true
        } else if defaults.integerForKey(DefaultKeys.Life.description) == 1 {
            save_bool = false
        }
        
        ResetSwitchObject.setOn(false, animated: true)
        ResetSwitchObject.transform = CGAffineTransformMakeScale(0.5, 0.5)
        ResetSwitchObject.addTarget(self, action: Selector("ResetAction"), forControlEvents: UIControlEvents.ValueChanged)
        
        NotSwitchObject.setOn(notif_bool, animated: true)
        NotSwitchObject.transform = CGAffineTransformMakeScale(0.5, 0.5)
        NotSwitchObject.addTarget(self, action: Selector("NotificationAction"), forControlEvents: UIControlEvents.ValueChanged)
        
        SoundsSwitchOutlet.setOn(sounds_bool, animated: true)
        SoundsSwitchOutlet.transform = CGAffineTransformMakeScale(0.5, 0.5)
        SoundsSwitchOutlet.addTarget(self, action: Selector("SoundsAction"), forControlEvents: UIControlEvents.ValueChanged)
        
        SaveLifeOutlet.setOn(save_bool, animated: true)
        SaveLifeOutlet.transform = CGAffineTransformMakeScale(0.5, 0.5)
        SaveLifeOutlet.addTarget(self, action: Selector("SaveLifeAction"), forControlEvents: UIControlEvents.ValueChanged)
        
        BackGesture = UIScreenEdgePanGestureRecognizer(target: self,
            action: "swipeBack:")
        BackGesture.edges = .Left
        view.addGestureRecognizer(BackGesture)
        
        self.checkAdsOn()
        
        Flurry.logEvent("Settings Page View")

    }
    
    override func viewDidAppear(animated: Bool) {
        self.checkAdsOn()
    }
    @IBAction func SLBButton(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/app/apple-store/id922641562?pt=68053800&ct=SLB%20from%20FBF&mt=8")!)
        Flurry.logEvent("Stoplight Buggies Link Clicked")
    }
    override func shouldAutorotate() -> Bool {
        return true
    }

    func swipeBack(sender: UIScreenEdgePanGestureRecognizer) {
        navigationController?.popViewControllerAnimated(true)
    }
    func ResetAction() {
        print("Reset Action", terminator: "")
        
        if ResetSwitchObject.on == true {
            defaults.setInteger(0, forKey: DefaultKeys.Tutorial.description)
            defaults.synchronize()
            ResetSwitchObject.setOn(true, animated: true)
            Flurry.logEvent("Reset Tutorial")
        }
    }
    func NotificationAction() {
        if NotSwitchObject.on == true {
            defaults.setInteger(0, forKey: DefaultKeys.Notifications.description)
            Flurry.logEvent("Notifications On")
            
        } else if NotSwitchObject.on == false {
            defaults.setInteger(1, forKey: DefaultKeys.Notifications.description)
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            Flurry.logEvent("Notifications Off")
        }
        defaults.synchronize()
    }
    func SoundsAction() {
        if SoundsSwitchOutlet.on == true {
            defaults.setInteger(0, forKey: DefaultKeys.Sound.description)
            Flurry.logEvent("Sounds On")

        } else if SoundsSwitchOutlet.on == false {
            defaults.setInteger(1, forKey: DefaultKeys.Sound.description)
            Flurry.logEvent("Sounds Off")
        }
        defaults.synchronize()
    }
    func SaveLifeAction() {
        if SaveLifeOutlet.on == true {
            defaults.setInteger(0, forKey: DefaultKeys.Life.description)
            Flurry.logEvent("Second Chance Alert On")
            
        } else if SaveLifeOutlet.on == false {
            defaults.setInteger(1, forKey: DefaultKeys.Life.description)
            Flurry.logEvent("Second Chance Alert Off")
        }
        defaults.synchronize()
    }
    @IBAction func BackBtn(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
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