//
//  StartScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    override func didMoveToView(view: SKView) {
        //self.backgroundColor = UIColor(red: 16/255, green: 151/255, blue: 255/255, alpha: 1.0)
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
        /*
        let title_label = SKLabelNode(text: "Five by Five")
        title_label.position = CGPointMake(CGRectGetMidX(self.frame), height*0.75)
        title_label.fontName = Constants.FontName.Title_Font
        title_label.fontSize = Constants.FontSize.Title
        title_label.fontColor = Constants.FontColor.titleClr
        self.addChild(title_label)
        */
        let title_label = SKSpriteNode(imageNamed: "titleImage")
        title_label.position = CGPointMake(CGRectGetMidX(self.frame), height*0.8)
        title_label.name = "Title"
        self.addChild(title_label)
        
        let start_button = SKSpriteNode(imageNamed: "playButton")
        start_button.position = CGPointMake(CGRectGetMidX(self.frame), height*0.6)
        start_button.name = "Start Button"
        self.addChild(start_button)
        
        let leader_button = SKSpriteNode(imageNamed: "leaderboardsButton")
        leader_button.position = CGPointMake(CGRectGetMidX(self.frame), height*0.45)
        leader_button.name = "Leaderboards Button"
        self.addChild(leader_button)
        
        let store_button = SKSpriteNode(imageNamed: "storeButton")
        store_button.position = CGPointMake(CGRectGetMidX(self.frame), height*0.3)
        store_button.name = "Store Button"
        self.addChild(store_button)
         
        let settings_button = SKSpriteNode(imageNamed: "settingsButton")
        settings_button.position = CGPointMake(CGRectGetMidX(self.frame), height*0.15)
        settings_button.name = "Settings Button"
        self.addChild(settings_button)
    }
}
