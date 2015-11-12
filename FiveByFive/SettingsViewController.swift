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
    
    
    @IBOutlet var BackGesture: UIScreenEdgePanGestureRecognizer!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        getData()
        var notif_bool:Bool = true
        var sounds_bool:Bool = true
        var save_bool:Bool = true
        
        if defaults.integerForKey("notif_bool") == 0 {
            notif_bool = true
        } else if defaults.integerForKey("notif_bool") == 1 {
            notif_bool = false
        }
        
        if defaults.integerForKey("sounds_bool") == 0 {
            sounds_bool = true
        } else if defaults.integerForKey("sounds_bool") == 1 {
            sounds_bool = false
        }
        
        if defaults.integerForKey("save_life") == 0 {
            save_bool = true
        } else if defaults.integerForKey("save_life") == 1 {
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
        
        print("Ads On Value: " + String(defaults.integerForKey("ads")), terminator: "")
        
        if defaults.integerForKey("ads") == 0 {
            loadAds()
        } else if defaults.integerForKey("ads") == 1 {
            self.appDelegate.adView.removeFromSuperview()
        }
        Flurry.logEvent("Settings Page View")

    }
    
    override func viewDidAppear(animated: Bool) {
        print("Ads On Value: " + String(defaults.integerForKey("ads")), terminator: "")
        
        if defaults.integerForKey("ads") == 1 {
            self.appDelegate.adView.removeFromSuperview()
        }
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
            tutorial = 0
            saveData()
            print(tutorial, separator: "")
            ResetSwitchObject.setOn(true, animated: true)
            Flurry.logEvent("Reset Tutorial")
        }
    }
    func NotificationAction() {
        if NotSwitchObject.on == true {
            notifications_on = 0
            saveData()
            Flurry.logEvent("Notifications On")
            
        } else if NotSwitchObject.on == false {
            notifications_on = 1
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            saveData()
            Flurry.logEvent("Notifications Off")
        }
    }
    func SoundsAction() {
        if SoundsSwitchOutlet.on == true {
            sounds_on = 0
            saveData()
            Flurry.logEvent("Sounds On")

        } else if SoundsSwitchOutlet.on == false {
            sounds_on = 1
            saveData()
            Flurry.logEvent("Sounds Off")
        }
    }
    func SaveLifeAction() {
        if SaveLifeOutlet.on == true {
            save_life = 0
            saveData()
            Flurry.logEvent("Second Chance Alert On")
            
        } else if SaveLifeOutlet.on == false {
            save_life = 1
            saveData()
            Flurry.logEvent("Second Chance Alert Off")
        }
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
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print(defaults.integerForKey("ads"), terminator: "")
        
        if defaults.integerForKey("ads") == 0 {
            self.appDelegate.adView.hidden = false
        } else if defaults.integerForKey("ads") == 1 {
            self.appDelegate.adView.hidden = true
            self.appDelegate.adView.removeFromSuperview()
        }
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        print("bannerViewActionDidFinish")
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        print("didFailToReceiveAdWithError")
        self.appDelegate.adView.hidden = true
    }
}