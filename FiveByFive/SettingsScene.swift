//
//  SettingsScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class SettingsScene:SKScene {
	override func didMove(to view: SKView) {
        setupScene()
    }
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
			let location = (touch as! UITouch).location(in: self)
			let node = self.atPoint(location)
            if node.name == "Back Button" {
				let scene = StartScene(size:self.size)
                self.view?.presentScene(scene)
            }
        }
    }
	override func willMove(from view: SKView) {
        //Only sync when leaving view as to reduce calls to sync
		UserDefaults.standard.synchronize()
    }
    
    // MARK: Scene Setup
    private func setupScene() {
        let scale = self.frame.size.width/414.0
        self.backgroundColor = UIColor.white
        
        let titleLabel = SKLabelNode(text: "Settings")
        titleLabel.setScale(scale)
		titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.85)
        titleLabel.fontName = Constants.FontName.Title_Font
        titleLabel.fontColor = UIColor.black
        titleLabel.fontSize = Constants.FontSize.Title
        titleLabel.horizontalAlignmentMode = .center
        self.addChild(titleLabel)
        
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.setScale(scale)
        backButton.name = "Back Button"
		backButton.position = CGPoint(x: self.frame.midX+backButton.frame.size.width, y: self.frame.size.height*0.85+backButton.frame.size.height/2)
        self.addChild(backButton)
        
		addLabelAndSwitch(withName: "Sounds", defaultsKey: DefaultKeys.sound.description, height: 0.6)
		addLabelAndSwitch(withName: "Tutorial", defaultsKey: DefaultKeys.tutorial.description, height: 0.45)
		addLabelAndSwitch(withName: "Notifications", defaultsKey: DefaultKeys.notifications.description, height: 0.3)
        
    }
    private func addLabelAndSwitch(withName:String, defaultsKey:String,height:CGFloat) {
        let scale = self.frame.size.width/414.0
        let label = SKLabelNode(text: withName + ": ")
        label.setScale(scale)
		label.position = CGPoint(x: self.frame.size.width*0.65, y: self.frame.size.height*height-12.5)
        label.fontSize = Constants.FontSize.DispFontSize
		label.fontColor = UIColor.black
        label.fontName = Constants.FontName.Game_Font
        label.horizontalAlignmentMode = .right
        self.addChild(label)
        
        let labelSwitch = FFSwitch(withName: withName, keyForDefaultsItem: defaultsKey)
		labelSwitch.position = CGPoint(x: self.frame.size.width*0.75, y: self.frame.size.height*height)
        self.addChild(labelSwitch)
    }
    
}
