//
//  GameKitHelper.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import GameKit

class GameKitHelper: NSObject, GKGameCenterControllerDelegate {
    //Singleton One Liner
    static let sharedGameKitHelper = GameKitHelper()
    var authenticationVC:UIViewController?
    private var gamecenter_enabled:Bool = true
    
    //private initalizer for singleton sake
    private override init() {
        super.init()
        
    }
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        if (localPlayer.authenticated) {
            print("Game Center Player Authenticated")
            GKNotificationBanner.showBannerWithTitle("Logged into Game Center", message: "Welcome " + localPlayer.displayName!, duration: 2.0, completionHandler: nil)
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.PLAYER_AUTH, object: nil)
            return
        }
        
        localPlayer.authenticateHandler = {(view_controller,error) -> Void in
            //self.setLastError(error)
            
            if (view_controller != nil) {
                self.setAuthenticationViewController(view_controller!)
            } else if (GKLocalPlayer.localPlayer().authenticated) {
                self.gamecenter_enabled = true
                print("Game Center Player Authenticated")
                //GKNotificationBanner.showBannerWithTitle("Logged into Game Center", message: "Welcome " + localPlayer.displayName!, duration: 2.0, completionHandler: nil)
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.PLAYER_AUTH, object: nil)
            } else {
                self.gamecenter_enabled = false
                print("Game Center Player Not Authenticated")
                
            }
        }
    }
    
    func setAuthenticationViewController(withVC:UIViewController?) {
        if (withVC != nil) {
            self.authenticationVC = withVC!
            let default_center = NSNotificationCenter()
            default_center.postNotificationName(Constants.Notifications.PRESENT_AUTH_VC, object: self)
        }
    }
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
          //self.view.dismissViewControllerAnimated(true, completion: nil)
    }
    func reportScore(score:Int) {
        let identifier = "leaderboard.highest_level"
        if GKLocalPlayer.localPlayer().authenticated == true{
            let highScore = NSUserDefaults.standardUserDefaults().integerForKey(DefaultKeys.Level.description)
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
    func showLeaderboard(withName:String) -> GKGameCenterViewController {
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.viewState = GKGameCenterViewControllerState.Leaderboards
        gc.viewState = GKGameCenterViewControllerState.Achievements
        gc.leaderboardIdentifier = withName
        return gc
    }
}
