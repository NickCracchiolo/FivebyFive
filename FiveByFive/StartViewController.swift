//
//  StartViewController.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/5/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import UIKit
import GameKit

class StartViewController: UIViewController, GKGameCenterControllerDelegate, GameDataProtocol {
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
											   selector: #selector(presentAuthenticationVC),
											   name: NSNotification.Name(rawValue: Constants.Notifications.PRESENT_AUTH_VC), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showLeaderboard),
											   name: NSNotification.Name(rawValue: Constants.Notifications.PRESENT_LEADERBOARDS), object: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let scene = StartScene(fileNamed: "StartScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            scene.size = skView.bounds.size
            /* Set the scale mode to scale to fit the window */
			let os = ProcessInfo().operatingSystemVersion
            switch (os.majorVersion, os.minorVersion, os.patchVersion) {
            case (8, 0, _):
                print("iOS >= 8.0.0, < 8.1.0")
				scene.scaleMode = .fill
            case (8, _, _):
                print("iOS >= 8.1.0, < 9.0")
				scene.scaleMode = .aspectFill
            case (9, _, _):
                print("iOS >= 9.0.0")
				scene.scaleMode = .resizeFill
            default:
                // this code will have already crashed on iOS 7, so >= iOS 10.0
				scene.scaleMode = .resizeFill
                print("iOS >= 10.0.0")
            }
            
            skView.presentScene(scene)
        }
        
    }
	override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let skView = self.view as! SKView
        skView.presentScene(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Game Center Helper
    @objc func presentAuthenticationVC() {
        let helper = GameKitHelper.sharedGameKitHelper
		self.present(helper.authenticationVC!, animated: true, completion: nil)
    }
    
	@objc func showLeaderboard() {
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.viewState = GKGameCenterViewControllerState.leaderboards
        gc.viewState = GKGameCenterViewControllerState.achievements
        gc.leaderboardIdentifier = "leaderboards.highest_score"
		self.present(gc, animated: true, completion: nil)
    }
	func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
		self.dismiss(animated: true, completion: nil)
    }
    // MARK: Game Data Protocol
    func saveGame(withData:GameData) {
		let encodedData = NSKeyedArchiver.archiveRootObject(withData, toFile: GameData.archiveURL.path)
        if !encodedData {
            print("Save Failed")
        }
    }
    
    func loadInstance() -> GameData {
		let data = NSKeyedUnarchiver.unarchiveObject(withFile: GameData.archiveURL.path) as? GameData
        if data == nil {
            print("Data could not be loaded properly")
            return GameData()
        }
        return data!
    }
}
