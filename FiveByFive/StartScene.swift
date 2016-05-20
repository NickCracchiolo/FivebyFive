//
//  StartScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class StartScene: SKScene, GameDataProtocol {
    var gameData:GameData = GameData()
    
    override func didMoveToView(view: SKView) {
        gameData = loadInstance()
        gameData.printData()
        setupScene()
        //NSUserDefaults.standardUserDefaults().setInteger(1, forKey: DefaultKeys.Tutorial.description)
        //NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    override func update(currentTime: NSTimeInterval) {
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if node.name == "Start Button" {
                let defaults = NSUserDefaults.standardUserDefaults()
                if (defaults.integerForKey(DefaultKeys.Tutorial.description) == 1) {
                    //Turn Tutorial off for next play
                    print("Tutorial == 1")
                    defaults.setInteger(0, forKey: DefaultKeys.Tutorial.description)
                    defaults.synchronize()
                    self.view?.presentScene(TutorialScene(size: self.size))
                } else {
                    self.view?.presentScene(PlayScene(size: self.size))
                }
            } else if node.name == "Leaderboards Button" {
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.PRESENT_LEADERBOARDS, object: nil)
            } else if node.name == "Store Button" {
                self.view?.presentScene(StoreScene(size: self.size))
            } else if node.name == "Settings Button" {
                self.view?.presentScene(SettingsScene(size: self.size))
            } else if node.name == "Ad Button" {
                saveGame()
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.PRESENT_INTERSTITIAL, object: nil)
            }
        }
    }
    
    // MARK: Scene Setup
    private func setupScene() {
        let scale = self.frame.size.width/414.0
        
        self.backgroundColor = UIColor.whiteColor()
        let height = self.frame.size.height
        
        let titleLabel = SKSpriteNode(imageNamed: "titleImage")
        titleLabel.setScale(scale)
        titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), height*0.8)
        titleLabel.name = "Title"
        self.addChild(titleLabel)
        
        let startButton = FFButton(text: "Game Time")
        startButton.setScale(scale)
        startButton.position = CGPointMake(CGRectGetMidX(self.frame), height*0.6)
        startButton.name = "Start Button"
        self.addChild(startButton)
        
        let leaderButton = FFButton(text: "Rankings")
        leaderButton.setScale(scale)
        leaderButton.position = CGPointMake(CGRectGetMidX(self.frame), height*0.45)
        leaderButton.name = "Leaderboards Button"
        self.addChild(leaderButton)
        
        let storeButton = FFButton(text: "Market")
        storeButton.setScale(scale)
        storeButton.position = CGPointMake(CGRectGetMidX(self.frame), height*0.3)
        storeButton.name = "Store Button"
        self.addChild(storeButton)
        
        let adButton = FFButton(text: "Ad For Coins?")
        adButton.setScale(scale)
        adButton.position = CGPointMake(CGRectGetMidX(self.frame), height*0.15)
        adButton.name = "Ad Button"
        self.addChild(adButton)
         
        let settingsButton = SKSpriteNode(imageNamed:"settingsButton")
        settingsButton.setScale(scale)
        settingsButton.position = CGPointMake(CGRectGetMaxX(self.frame)-35, CGRectGetMaxY(self.frame)-50)
        settingsButton.name = "Settings Button"
        self.addChild(settingsButton)
    }
    
    // MARK: Google Ads Infrastructure
    func addCoinsFromAd(value:Int) {
        print("Before: ",gameData.printData())
        gameData.addCoins(value)
        print("Coins Added")
        saveGame()
        print("After: ", gameData.printData())
    }
    
    // MARK: Game Data Protocol
    func saveGame() {
        let encodedData = NSKeyedArchiver.archiveRootObject(gameData, toFile: GameData.archiveURL.path!)
        if !encodedData {
            print("Save Failed")
        }
    }
    
    func loadInstance() -> GameData {
        let data = NSKeyedUnarchiver.unarchiveObjectWithFile(GameData.archiveURL.path!) as? GameData
        if data == nil {
            print("Data could not be loaded properly")
            return GameData()
        }
        return data!
    }
}
