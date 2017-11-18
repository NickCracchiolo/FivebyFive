//
//  GameKitHelper.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import GameKit

class GameKitHelper: NSObject {
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
        if (localPlayer.isAuthenticated) {
            print("Game Center Player Authenticated")
			GKNotificationBanner.show(withTitle: "Logged into Game Center", message: "Welcome " + localPlayer.displayName!, duration: 2.0, completionHandler: nil)
			NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.PLAYER_AUTH), object: nil)
            return
        }
        
        localPlayer.authenticateHandler = {(view_controller,error) -> Void in
            //self.setLastError(error)
            
            if (view_controller != nil) {
				self.setAuthenticationViewController(withVC: view_controller!)
            } else if (GKLocalPlayer.localPlayer().isAuthenticated) {
                self.gamecenter_enabled = true
                print("Game Center Player Authenticated")
                //GKNotificationBanner.showBannerWithTitle("Logged into Game Center", message: "Welcome " + localPlayer.displayName!, duration: 2.0, completionHandler: nil)
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.PLAYER_AUTH), object: nil)
            } else {
                self.gamecenter_enabled = false
                print("Game Center Player Not Authenticated")
                
            }
        }
    }
    
    func setAuthenticationViewController(withVC:UIViewController?) {
        if (withVC != nil) {
            self.authenticationVC = withVC!
            let default_center = NotificationCenter.default
			default_center.post(name: NSNotification.Name(rawValue: Constants.Notifications.PRESENT_AUTH_VC), object: self)
        }
    }
    func reportScore(score:Int) {
        let identifier = "leaderboard.highest_level"
        if GKLocalPlayer.localPlayer().isAuthenticated == true {
            let scoreReporter = GKScore(leaderboardIdentifier: identifier as String)
            scoreReporter.value = Int64(score)
            let scoreArray: [GKScore] = [scoreReporter]
            print("report score \(scoreReporter)")
			GKScore.report(scoreArray, withCompletionHandler: { (error) in
				if let e = error {
					print(e.localizedDescription)
				}
			})
        }
    }
    func getHighScore() -> Int {
        var score:Int64 = 1
        let leaderboard = GKLeaderboard()
        leaderboard.identifier = "leaderboard.highest_level"
		leaderboard.loadScores { (scores, error) in
			if let e = error {
				print("Error Loading Scores: ",e.localizedDescription)
			} else {
				score = leaderboard.localPlayerScore!.value
			}
		}
		return Int(score)
    }
}
