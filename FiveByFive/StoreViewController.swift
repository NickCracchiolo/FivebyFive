//
//  StoreViewController.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/5/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import Foundation
import StoreKit
import iAd

class StoreViewController: UIViewController, ADBannerViewDelegate {
    @IBOutlet weak var MoneyLabel: UILabel!
    @IBOutlet var BackGesture: UIScreenEdgePanGestureRecognizer!
    var p = SKProduct()
    var list = [SKProduct]()
    var startVC = StartViewController()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var FreeButton: UIButton!
    
    override func viewDidLoad() {
        getData()
        MoneyLabel.text = String(money)
        inAppPurchases.defaultHelper.setViewController(self)
        inAppPurchases.defaultHelper.getProducts()
        BackGesture = UIScreenEdgePanGestureRecognizer(target: self,
            action: "swipeBack:")
        BackGesture.edges = .Left
        view.addGestureRecognizer(BackGesture)
        
        print("Ads On Value: " + String(defaults.integerForKey("ads")))
        if defaults.integerForKey("ads") == 0 {
            loadAds()
        } else if defaults.integerForKey("ads") == 1 {
            self.appDelegate.adView.removeFromSuperview()
        }
        Flurry.logEvent("Store Page View")

    }
    override func viewDidAppear(animated: Bool) {
        print("Ads On Value: " + String(defaults.integerForKey("ads")))

        if defaults.integerForKey("ads") == 1 {
            self.appDelegate.adView.removeFromSuperview()
        }
    }
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    func swipeBack(sender: UIScreenEdgePanGestureRecognizer) {
        navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func BackButton(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func FreeCoinsBtn(sender: UIButton) {
        if freeCoins == 0 {
            let added_money = randomFreeCoins()
            if added_money == 25 {
                let img = UIImage(named: "Store25.png")
                FreeButton.setImage(img, forState: UIControlState.Normal)
            } else if added_money == 50 {
                let img = UIImage(named: "Store50.png")
                FreeButton.setImage(img, forState: UIControlState.Normal)
            } else if added_money == 100 {
                let img = UIImage(named: "Store100.png")
                FreeButton.setImage(img, forState: UIControlState.Normal)
            } else if added_money == 200 {
                let img = UIImage(named: "Store200.png")
                FreeButton.setImage(img, forState: UIControlState.Normal)
            }
            money += added_money
            freeCoins = 1
            let flags: NSCalendarUnit = .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
            let date = NSDate()
            let components = NSCalendar.currentCalendar().components(flags, fromDate: date)
            if defaults.integerForKey("notif_on") == 0 {
                UIApplication.sharedApplication().cancelAllLocalNotifications()
                startVC.setupNofications()
            }
            saved_year = components.year
            saved_month = components.month
            saved_day = components.day
            saveData()
            MoneyLabel.text = String(money)
        } else {
            let alertController = UIAlertController(title: "Free Coins", message:
                "Already got your coins, try again later", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            Flurry.logEvent("Tried to get Free Coins but already did")
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func CoinsBtnOne(sender: UIButton) {
        inAppPurchases.defaultHelper.CoinsBtnOne()

    }
    @IBAction func CoinsBtnFive(sender: UIButton) {
        inAppPurchases.defaultHelper.CoinsBtnFive()
    }
    
    @IBAction func CoinsBtnThousand(sender: UIButton) {
        inAppPurchases.defaultHelper.CoinsBtnThousand()
    }
    
    @IBAction func RemoveAds(sender: UIButton) {
        inAppPurchases.defaultHelper.RemoveAds()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    @IBAction func RestoreBtn(sender: UIButton) {
        print("Restore Button Pressed")
        inAppPurchases.defaultHelper.RestorePurchase()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    //StoreKit
    func randomFreeCoins() -> Int {
        let num = Int(arc4random_uniform(101))
        var value = 0
        if num >= 0 && num <= 75 {
            value =  25
        } else if num > 75 && num < 95 {
            value = 50
        } else if num >= 95 && num <= 99 {
            value = 100
        } else if num == 100 {
            value = 200
        } else {
            value = 25
        }
        Flurry.logEvent("Got Free Coins", withParameters: ["Free Coins":value])
        return value
    }

    func loadAds() {
        self.appDelegate.adView.removeFromSuperview()
        self.appDelegate.adView.delegate = nil
        self.appDelegate.adView = ADBannerView(frame: CGRect.zeroRect)
        self.appDelegate.adView.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height - self.appDelegate.adView.frame.size.height / 2)
        self.appDelegate.adView.delegate = self
        self.appDelegate.adView.hidden = true
        view.addSubview(self.appDelegate.adView)
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        print(defaults.integerForKey("ads"))
        if defaults.integerForKey("ads") == 0 {
            self.appDelegate.adView.hidden = false
        } else if defaults.integerForKey("ads") == 1 {
            self.appDelegate.adView.hidden = true
            self.appDelegate.adView.removeFromSuperview()
        }
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        println("bannerViewActionDidFinish")
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        println("didFailToReceiveAdWithError")
        self.appDelegate.adView.hidden = true
    }
}