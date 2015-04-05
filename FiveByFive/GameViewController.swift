//
//  GameViewController.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 3/24/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import iAd

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}
var bannerView = ADBannerView()
var gameCenterEnabled = false
var leaderBoardID = NSString()

class GameViewController: UIViewController, ADBannerViewDelegate, GKGameCenterControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frme = CGRectMake(0, self.view.frame.size.height-50, 320, 50)
        bannerView = ADBannerView(frame: frme)
        var frame:CGRect = CGRectZero
        frame.size = bannerView.frame.size;
        frame.origin = CGPointMake(0.0, self.view.frame.size.height-bannerView.frame.size.height);
        bannerView.frame = frame
        bannerView.delegate = self
        self.view.addSubview(bannerView)
        
        self.authenticateLocalPlayer()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        bannerView.hidden = false;
    }
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
    }
    
    //ADD GAME CENTER AND iAD AND IN APP PURCHASES
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer()
        let viewController = UIViewController()
        let error = NSError()
        let leaderBoardIdentifier = NSString()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.presentViewController(viewController, animated: true, completion: nil)
            } else {
                if (localPlayer.authenticated) {
                    GKNotificationBanner.showBannerWithTitle("Game Center", message: ("Welcome, " + String(format: localPlayer.displayName)) , completionHandler: {
                        gameCenterEnabled = true
                    })
                    localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler{(viewController, error) -> Void in
                        if error != nil {
                            print(error)
                        } else {
                            leaderBoardID = leaderBoardIdentifier
                        }
                    }
                }
                else {
                    gameCenterEnabled = false
                }
            }
        }
    }
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func reportScore(identifier:NSString) {
        if GKLocalPlayer.localPlayer().authenticated == true{
            var highScore = defaults.integerForKey("level")
            var scoreReporter = GKScore(leaderboardIdentifier: identifier)
            scoreReporter.value = Int64(highScore)
            var scoreArray: [GKScore] = [scoreReporter]
            println("report score \(scoreReporter)")
            GKScore.reportScores(scoreArray, {(error : NSError!) -> Void in
                if error != nil {
                    NSLog(error.localizedDescription)
                }
            })
            
            
        }
    }
}