//
//  StartScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    var gameData:GameData?
    
	override func didMove(to view: SKView) {
        gameData = loadInstance()
        setupScene()
    }
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
			let location = (touch as! UITouch).location(in: self)
			let node = self.atPoint(location)
            
            if node.name == "Start Button" {
				let defaults = UserDefaults.standard
				if (defaults.integer(forKey: DefaultKeys.tutorial.description) == 0) {
					defaults.set(1, forKey: DefaultKeys.tutorial.description)
                    self.view?.presentScene(TutorialScene(size: self.size))
                } else {
					let scene = PlayScene(size: self.size)
					scene.gameData = self.gameData
                    self.view?.presentScene(scene)
                }
            } else if node.name == "Leaderboards Button" {
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.PRESENT_LEADERBOARDS), object: nil)
            } else if node.name == "Store Button" {
				let scene = StoreScene(size: self.size)
				scene.gameData = self.gameData
                self.view?.presentScene(scene)
            } else if node.name == "Settings Button" {
				let scene = SettingsScene(size: self.size)
                self.view?.presentScene(scene)
            }
//			else if node.name == "Ad Button" {
//                saveGame(gameData)
//                gameData.printData()
//                NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.PRESENT_INTERSTITIAL, object: nil)
//          }
        }
    }
    
    // MARK: Scene Setup
    private func setupScene() {
        let scale = self.frame.size.width/414.0
        
        self.backgroundColor = UIColor.white
        let height = self.frame.size.height
        
        let titleLabel = SKSpriteNode(imageNamed: "titleImage")
        titleLabel.setScale(scale)
		titleLabel.position = CGPoint(x: self.frame.midX, y: height*0.8)
        titleLabel.name = "Title"
        self.addChild(titleLabel)

        let startButton = SKSpriteNode(imageNamed: "playButton")
        startButton.setScale(scale)
		startButton.position = CGPoint(x: self.frame.midX, y: height*0.6)
        startButton.name = "Start Button"
        self.addChild(startButton)
        
        let leaderButton = SKSpriteNode(imageNamed: "leaderboardsButton")
        leaderButton.setScale(scale)
		leaderButton.position = CGPoint(x: self.frame.midX, y: height*0.45)
        leaderButton.name = "Leaderboards Button"
        self.addChild(leaderButton)
        
        let storeButton = SKSpriteNode(imageNamed: "storeButton")
        storeButton.setScale(scale)
		storeButton.position = CGPoint(x: self.frame.midX, y: height*0.3)
        storeButton.name = "Store Button"
        self.addChild(storeButton)
        
        let adButton = SKSpriteNode(imageNamed: "adButton")
        adButton.setScale(scale)
		adButton.position = CGPoint(x: self.frame.midX, y: height*0.15)
        adButton.name = "Ad Button"
        //self.addChild(adButton)
        
        let adLabel = SKLabelNode(text: "Watch a video ad for 25 coins")
        adLabel.fontName = Constants.FontName.Game_Font
        adLabel.fontSize = Constants.FontSize.DispFontSize
        adLabel.fontColor = UIColor.black
        adLabel.setScale(scale)
		adLabel.position = CGPoint(x: self.frame.midX, y: height*0.075)
        //self.addChild(adLabel)
        
        let settingsButton = SKSpriteNode(imageNamed:"settingsButton")
        settingsButton.setScale(scale)
		settingsButton.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 125)
        settingsButton.name = "Settings Button"
        self.addChild(settingsButton)
    }
}
