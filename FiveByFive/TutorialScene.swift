//
//  TutorialScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/17/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

enum TutorialState {
    case Intro
    case TilesInfo
    case SideInfo
    case End
}

class TutorialScene: SKScene {
    var state:TutorialState = .Intro
    
    override func didMoveToView(view: SKView) {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(nextState))
        swipeRight.direction = .Right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(previousState))
        swipeLeft.direction = .Left
        self.view?.addGestureRecognizer(swipeLeft)
        
        setupScene()
    }
    override func update(currentTime: NSTimeInterval) {
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if node.name == "Next Button" {
                nextState()
            } else if node.name == "Previous Button" {
                previousState()
            }
        }
    }
    
    func setupScene() {
        let scale = self.frame.size.width/414.0
        self.backgroundColor = UIColor.whiteColor()
        let titleLabel = SKLabelNode(text: "How To Play")
        titleLabel.setScale(scale)
        titleLabel.fontName = Constants.FontName.Game_Font
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.fontSize = Constants.FontSize.Title
        titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.85)
        self.addChild(titleLabel)
        
        let introStringOne = "Welcome to Five by Five, here's how to play"
        let introLabelOne = FFLabel(text: introStringOne, bounds: self.size)
        introLabelOne.setScale(scale)
        introLabelOne.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        introLabelOne.fontName = Constants.FontName.Game_Font
        introLabelOne.fontColor = UIColor.blackColor()
        introLabelOne.fontSize = 14
        self.addChild(introLabelOne)
        
        /*
        let introStringTwo = "here's how to play"
        let introLabelTwo = FFLabel(text: introStringTwo, bounds: self.size)
        introLabelTwo.setScale(scale)
        introLabelTwo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-introLabelOne.frame.size.height)
        introLabelTwo.fontName = Constants.FontName.Game_Font
        introLabelTwo.fontColor = UIColor.blackColor()
        introLabelTwo.fontSize = 14
        self.addChild(introLabelTwo)
        */
        
        let nextLabel = SKLabelNode(text:"Next")
        nextLabel.setScale(scale)
        nextLabel.fontName = Constants.FontName.Game_Font
        nextLabel.fontColor = UIColor.blackColor()
        nextLabel.fontSize = 20
        nextLabel.name = "Next Button"
        nextLabel.position = CGPointMake(CGRectGetMaxX(self.frame)-nextLabel.frame.size.width, self.frame.size.height*0.1)
        self.addChild(nextLabel)
        
        
    }
    func nextState() {
        switch state {
        case .Intro:
            state = .TilesInfo
        case .TilesInfo:
            state = .SideInfo
        case .SideInfo:
            state = .End
        case .End:
            return
        }
    }
    func previousState() {
        switch state {
        case .Intro:
            return
        case .TilesInfo:
            state = .Intro
        case .SideInfo:
            state = .TilesInfo
        case .End:
            state = .SideInfo
        }
    }
}
