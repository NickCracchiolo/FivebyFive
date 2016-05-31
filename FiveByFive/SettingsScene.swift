//
//  SettingsScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class SettingsScene:SKScene {
    override func didMoveToView(view: SKView) {
        setupScene()
    }
    override func update(currentTime: NSTimeInterval) {
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            let node = self.nodeAtPoint(location)
            if node.name == "Back Button" {
                self.view?.presentScene(StartScene(size: self.size))
            }
        }
    }
    override func willMoveFromView(view: SKView) {
        //Only sync when leaving view as to reduce calls to sync
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // MARK: Scene Setup
    private func setupScene() {
        let scale = self.frame.size.width/414.0
        self.backgroundColor = UIColor.whiteColor()
        
        let titleLabel = SKLabelNode(text: "Settings")
        titleLabel.setScale(scale)
        titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.85)
        titleLabel.fontName = Constants.FontName.Title_Font
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.fontSize = Constants.FontSize.Title
        titleLabel.horizontalAlignmentMode = .Center
        self.addChild(titleLabel)
        
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.setScale(scale)
        backButton.name = "Back Button"
        backButton.position = CGPointMake(CGRectGetMinX(self.frame)+backButton.frame.size.width, self.frame.size.height*0.85+backButton.frame.size.height/2)
        self.addChild(backButton)
        
        addLabelAndSwitch("Sounds", defaultsKey: DefaultKeys.Sound.description, height: 0.6)
        addLabelAndSwitch("Tutorial", defaultsKey: DefaultKeys.Tutorial.description, height: 0.45)
        addLabelAndSwitch("Notifications", defaultsKey: DefaultKeys.Notifications.description, height: 0.3)
        
    }
    private func addLabelAndSwitch(withName:String, defaultsKey:String,height:CGFloat) {
        let scale = self.frame.size.width/414.0
        let label = SKLabelNode(text: withName + ": ")
        label.setScale(scale)
        label.position = CGPointMake(self.frame.size.width*0.65, self.frame.size.height*height-12.5)
        label.fontSize = Constants.FontSize.DispFontSize
        label.fontColor = UIColor.blackColor()
        label.fontName = Constants.FontName.Game_Font
        label.horizontalAlignmentMode = .Right
        self.addChild(label)
        
        let labelSwitch = FFSwitch(withName: withName, keyForDefaultsItem: defaultsKey)
        labelSwitch.position = CGPointMake(self.frame.size.width*0.75, self.frame.size.height*height)
        self.addChild(labelSwitch)
    }
    
}
