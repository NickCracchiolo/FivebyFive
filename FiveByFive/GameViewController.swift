//
//  GameViewController.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 3/24/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import UIKit
import SpriteKit
import iAd

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, ADBannerViewDelegate {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Ads On Value: " + String(defaults.integerForKey("ads")), terminator: "")
        if defaults.integerForKey("ads") == 0 {
            loadAds()
        } else if defaults.integerForKey("ads") == 1 {
            self.appDelegate.adView.removeFromSuperview()
        }
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.gViewController = self
            Flurry.logEvent("Game Page View")
            skView.presentScene(scene)
        }
    }
    override func viewDidAppear(animated: Bool) {
        print("Ads On Value: " + String(defaults.integerForKey("ads")), terminator: "")
        
        if defaults.integerForKey("ads") == 1 {
            self.appDelegate.adView.removeFromSuperview()
        }
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //iAd Shared Banner
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
        print((defaults.integerForKey("ads"), appeterminator: ""))
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
    }}