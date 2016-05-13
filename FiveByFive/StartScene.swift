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
        self.backgroundColor = UIColor.whiteColor()
        setupScene()
    }
    override func update(currentTime: NSTimeInterval) {
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if node.name == "Start Button" {
                self.view?.presentScene(PlayScene(size: self.size))
            } else if node.name == "Leaderboards Button" {
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.PRESENT_LEADERBOARDS, object: nil)
            } else if node.name == "Store Button" {
                self.view?.presentScene(StoreScene(size: self.size))
            } else if node.name == "Settings Button" {
                self.view?.presentScene(SettingsScene(size: self.size))
            }
        }
    }
    private func setupScene() {
        let height = self.frame.size.height
        
        let title_label = SKSpriteNode(imageNamed: "titleImage")
        title_label.position = CGPointMake(CGRectGetMidX(self.frame), height*0.8)
        title_label.name = "Title"
        self.addChild(title_label)
        
        let start_button = FFButton(text: "Play")
        start_button.position = CGPointMake(CGRectGetMidX(self.frame), height*0.6)
        start_button.name = "Start Button"
        self.addChild(start_button)
        
        let leader_button = FFButton(text: "Leaderboards")
        leader_button.position = CGPointMake(CGRectGetMidX(self.frame), height*0.45)
        leader_button.name = "Leaderboards Button"
        self.addChild(leader_button)
        
        let store_button = FFButton(text: "Coins")
        store_button.position = CGPointMake(CGRectGetMidX(self.frame), height*0.3)
        store_button.name = "Store Button"
        self.addChild(store_button)
         
        let settings_button = FFButton(text:"Settings")
        settings_button.position = CGPointMake(CGRectGetMidX(self.frame), height*0.15)
        settings_button.name = "Settings Button"
        self.addChild(settings_button)
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
