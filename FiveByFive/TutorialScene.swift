//
//  TutorialScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/17/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit
import FirebaseAnalytics

enum TutorialState {
    case Intro
    case TilesInfo
    case SideInfo
    case End
}

class TutorialScene: SKScene {
    var state:TutorialState = .Intro
    var introNode:SKNode = SKNode()
    var tilesNode:SKNode = SKNode()
    var sideNode:SKNode  = SKNode()
    var endNode:SKNode   = SKNode()
    var scaleFactor:CGFloat = 0
    var grid = Grid()
    
    override func didMoveToView(view: SKView) {
        scaleFactor = self.frame.size.width/414.0
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(nextState))
        swipeRight.direction = .Right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(previousState))
        swipeLeft.direction = .Left
        self.view?.addGestureRecognizer(swipeLeft)
        
        setupScene()
        introNode.hidden = false
        tilesNode.hidden = true
        sideNode.hidden = true
        endNode.hidden = true
        self.addChild(introNode)
        self.addChild(tilesNode)
        self.addChild(sideNode)
        self.addChild(endNode)
        introStateSetup()
        tilesStateSetup()
        sideStateSetup()
        endStateSetup()
        FIRAnalytics.logEventWithName(kFIREventTutorialBegin, parameters: nil)

        
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
        self.backgroundColor = UIColor.whiteColor()
        
        let titleLabel = SKLabelNode(text: "How To Play")
        titleLabel.setScale(scaleFactor)
        titleLabel.fontName = Constants.FontName.Game_Font
        titleLabel.fontColor = UIColor.blackColor()
        titleLabel.fontSize = Constants.FontSize.Title
        titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.9)
        self.addChild(titleLabel)
        
        let nextButton = SKSpriteNode(imageNamed: "nextButton")
        nextButton.setScale(scaleFactor)
        nextButton.position = CGPointMake(CGRectGetMaxX(self.frame)-nextButton.frame.size.width, self.frame.size.height*0.075)
        nextButton.name = "Next Button"
        self.addChild(nextButton)
        
        let backButton = SKSpriteNode(imageNamed: "previousButton")
        backButton.setScale(scaleFactor)
        backButton.position = CGPointMake(backButton.frame.size.width, self.frame.size.height*0.075)
        backButton.name = "Previous Button"
        self.addChild(backButton)
        
        grid.setScale(scaleFactor)
        let offset = 125*scaleFactor
        grid.position = CGPointMake(CGRectGetMidX(self.frame) - offset, CGRectGetMidY(self.frame) - offset)
        self.addChild(grid)
    }
    
    func nextState() {
        switch state {
        case .Intro:
            introNode.hidden = true
            state = .TilesInfo
            tilesNode.hidden = false
            grid.hidden = true
        case .TilesInfo:
            tilesNode.hidden = true
            state = .SideInfo
            sideNode.hidden = false
            grid.hidden = false
        case .SideInfo:
            sideNode.hidden = true
            state = .End
            endNode.hidden = false
            grid.hidden = true
        case .End:
            FIRAnalytics.logEventWithName(kFIREventTutorialComplete, parameters: nil)
            self.view?.presentScene(PlayScene(size: self.size))
        }
    }
    func previousState() {
        switch state {
        case .Intro:
            return
        case .TilesInfo:
            tilesNode.hidden = true
            state = .Intro
            introNode.hidden = false
            grid.hidden = false
        case .SideInfo:
            sideNode.hidden = true
            state = .TilesInfo
            tilesNode.hidden = false
            grid.hidden = true
        case .End:
            endNode.hidden = true
            state = .SideInfo
            sideNode.hidden = false
            grid.hidden = false
        }
    }
    
    //----------------------------------------
    // MARK: State Scene Setups
    //----------------------------------------
    private func introStateSetup() {
        let text1 = SKLabelNode(text: "Flip tiles without hitting")
        text1.setScale(scaleFactor)
        text1.fontName = Constants.FontName.Game_Font
        text1.fontColor = UIColor.blackColor()
        text1.fontSize = Constants.FontSize.DispFontSize
        text1.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.825)
        introNode.addChild(text1)
        
        let text2 = SKLabelNode(text: "any hidden bombs")
        text2.setScale(scaleFactor)
        text2.fontName = Constants.FontName.Game_Font
        text2.fontColor = UIColor.blackColor()
        text2.fontSize = Constants.FontSize.DispFontSize
        text2.position = CGPointMake(CGRectGetMidX(self.frame), text1.position.y-text2.frame.size.height)
        introNode.addChild(text2)
        
    }
    private func tilesStateSetup() {
        let text1 = SKLabelNode(text: "This is a bomb tile, Don't ")
        text1.setScale(scaleFactor)
        text1.fontName = Constants.FontName.Game_Font
        text1.fontColor = UIColor.blackColor()
        text1.fontSize = Constants.FontSize.DispFontSize
        text1.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.75)
        tilesNode.addChild(text1)
        
        let text2 = SKLabelNode(text: "touch these and you'll do fine")
        text2.setScale(scaleFactor)
        text2.fontName = Constants.FontName.Game_Font
        text2.fontColor = UIColor.blackColor()
        text2.fontSize = Constants.FontSize.DispFontSize
        text2.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.75-text2.frame.size.height)
        tilesNode.addChild(text2)
        
        let bombTile = SKSpriteNode(imageNamed: "bombTile")
        bombTile.setScale(scaleFactor)
        bombTile.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.65)
        tilesNode.addChild(bombTile)
        
        let text3 = SKLabelNode(text: "These are numbered tiles,")
        text3.setScale(scaleFactor)
        text3.fontName = Constants.FontName.Game_Font
        text3.fontColor = UIColor.blackColor()
        text3.fontSize = Constants.FontSize.DispFontSize
        text3.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.4)
        tilesNode.addChild(text3)
        
        let text4 = SKLabelNode(text: "you want to flip them")
        text4.setScale(scaleFactor)
        text4.fontName = Constants.FontName.Game_Font
        text4.fontColor = UIColor.blackColor()
        text4.fontSize = Constants.FontSize.DispFontSize
        text4.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.4-text4.frame.size.height)
        tilesNode.addChild(text4)
        
        let blueOne = SKSpriteNode(imageNamed: "blueOne")
        blueOne.setScale(scaleFactor)
        blueOne.position = CGPointMake(CGRectGetMidX(self.frame) - blueOne.frame.size.width*2-10, self.frame.size.height*0.3)
        tilesNode.addChild(blueOne)
        
        let blueTwo = SKSpriteNode(imageNamed: "blueTwo")
        blueTwo.setScale(scaleFactor)
        blueTwo.position = CGPointMake(CGRectGetMidX(self.frame) - blueTwo.frame.size.width-5, self.frame.size.height*0.3)
        tilesNode.addChild(blueTwo)
        
        let blueThree = SKSpriteNode(imageNamed: "blueThree")
        blueThree.setScale(scaleFactor)
        blueThree.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.3)
        tilesNode.addChild(blueThree)
        
        let blueFour = SKSpriteNode(imageNamed: "blueFour")
        blueFour.setScale(scaleFactor)
        blueFour.position = CGPointMake(CGRectGetMidX(self.frame) + blueFour.frame.size.width+5, self.frame.size.height*0.3)
        tilesNode.addChild(blueFour)
        
        let blueFive = SKSpriteNode(imageNamed: "blueFive")
        blueFive.setScale(scaleFactor)
        blueFive.position = CGPointMake(CGRectGetMidX(self.frame) + blueFive.frame.size.width*2+10, self.frame.size.height*0.3)
        tilesNode.addChild(blueFive)
    }
    private func sideStateSetup() {
        let text1 = SKLabelNode(text: "The red numbers are")
        text1.setScale(scaleFactor)
        text1.fontName = Constants.FontName.Game_Font
        text1.fontColor = UIColor.redColor()
        text1.fontSize = Constants.FontSize.DispFontSize
        text1.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.83)
        sideNode.addChild(text1)
        
        let subtext1 = SKLabelNode(text: "the number of bombs")
        subtext1.setScale(scaleFactor)
        subtext1.fontName = Constants.FontName.Game_Font
        subtext1.fontColor = UIColor.redColor()
        subtext1.fontSize = Constants.FontSize.DispFontSize
        subtext1.position = CGPointMake(CGRectGetMidX(self.frame), text1.position.y-subtext1.frame.size.height)
        sideNode.addChild(subtext1)
        
        let text2 = SKLabelNode(text: "in the corresponding")
        text2.setScale(scaleFactor)
        text2.fontName = Constants.FontName.Game_Font
        text2.fontColor = UIColor.redColor()
        text2.fontSize = Constants.FontSize.DispFontSize
        text2.position = CGPointMake(CGRectGetMidX(self.frame), subtext1.position.y-text2.frame.size.height)
        sideNode.addChild(text2)
        
        let subtext2 = SKLabelNode(text: "row or column")
        subtext2.setScale(scaleFactor)
        subtext2.fontName = Constants.FontName.Game_Font
        subtext2.fontColor = UIColor.redColor()
        subtext2.fontSize = Constants.FontSize.DispFontSize
        subtext2.position = CGPointMake(CGRectGetMidX(self.frame), text2.position.y-subtext2.frame.size.height)
        sideNode.addChild(subtext2)
        
        let text3 = SKLabelNode(text: "The black numbers represent")
        text3.setScale(scaleFactor)
        text3.fontName = Constants.FontName.Game_Font
        text3.fontColor = UIColor.blackColor()
        text3.fontSize = Constants.FontSize.DispFontSize
        text3.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.2)
        sideNode.addChild(text3)
        
        let subtext3 = SKLabelNode(text: "the sum of tiles in")
        subtext3.setScale(scaleFactor)
        subtext3.fontName = Constants.FontName.Game_Font
        subtext3.fontColor = UIColor.blackColor()
        subtext3.fontSize = Constants.FontSize.DispFontSize
        subtext3.position = CGPointMake(CGRectGetMidX(self.frame), text3.position.y - subtext3.frame.size.height)
        sideNode.addChild(subtext3)
        
        let text4 = SKLabelNode(text: "each row or column")
        text4.setScale(scaleFactor)
        text4.fontName = Constants.FontName.Game_Font
        text4.fontColor = UIColor.blackColor()
        text4.fontSize = Constants.FontSize.DispFontSize
        text4.position = CGPointMake(CGRectGetMidX(self.frame), subtext3.position.y - text4.frame.size.height)
        sideNode.addChild(text4)
    }
    private func endStateSetup() {
        let text1 = SKLabelNode(text: "You are now ready to play!")
        text1.setScale(scaleFactor)
        text1.fontName = Constants.FontName.Game_Font
        text1.fontColor = UIColor.blackColor()
        text1.fontSize = Constants.FontSize.DispFontSize
        text1.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.75)
        endNode.addChild(text1)
        
        let text2 = SKLabelNode(text: "Try to get to the highest")
        text2.setScale(scaleFactor)
        text2.fontName = Constants.FontName.Game_Font
        text2.fontColor = UIColor.blackColor()
        text2.fontSize = Constants.FontSize.DispFontSize
        text2.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.7-text2.frame.size.height)
        endNode.addChild(text2)
        
        let text3 = SKLabelNode(text: "level without hitting a bomb.")
        text3.setScale(scaleFactor)
        text3.fontName = Constants.FontName.Game_Font
        text3.fontColor = UIColor.blackColor()
        text3.fontSize = Constants.FontSize.DispFontSize
        text3.position = CGPointMake(CGRectGetMidX(self.frame), text2.position.y-text3.frame.size.height)
        endNode.addChild(text3)
        
        let text4 = SKLabelNode(text: "You have 3 lives to start")
        text4.setScale(scaleFactor)
        text4.fontName = Constants.FontName.Game_Font
        text4.fontColor = UIColor.blackColor()
        text4.fontSize = Constants.FontSize.DispFontSize
        text4.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.55)
        endNode.addChild(text4)
        
        let subtext4 = SKLabelNode(text: "which can save you if")
        subtext4.setScale(scaleFactor)
        subtext4.fontName = Constants.FontName.Game_Font
        subtext4.fontColor = UIColor.blackColor()
        subtext4.fontSize = Constants.FontSize.DispFontSize
        subtext4.position = CGPointMake(CGRectGetMidX(self.frame), text4.position.y - subtext4.frame.size.height)
        endNode.addChild(subtext4)
        
        let text5 = SKLabelNode(text: "you uncover a bomb.")
        text5.setScale(scaleFactor)
        text5.fontName = Constants.FontName.Game_Font
        text5.fontColor = UIColor.blackColor()
        text5.fontSize = Constants.FontSize.DispFontSize
        text5.position = CGPointMake(CGRectGetMidX(self.frame), subtext4.position.y-text5.frame.size.height)
        endNode.addChild(text5)
        
        let saveLife = SKSpriteNode(imageNamed: "lifeIcon")
        saveLife.setScale(scaleFactor)
        saveLife.position = CGPointMake(CGRectGetMidX(self.frame), text5.position.y - 50)
        endNode.addChild(saveLife)
        
        let text6 = SKLabelNode(text: "You can purchase a.")
        text6.setScale(scaleFactor)
        text6.fontName = Constants.FontName.Game_Font
        text6.fontColor = UIColor.blackColor()
        text6.fontSize = Constants.FontSize.DispFontSize
        text6.position = CGPointMake(CGRectGetMidX(self.frame), saveLife.position.y - saveLife.frame.size.height/1.5)
        endNode.addChild(text6)
        
        let subtext6 = SKLabelNode(text: "life for 200 coins.")
        subtext6.setScale(scaleFactor)
        subtext6.fontName = Constants.FontName.Game_Font
        subtext6.fontColor = UIColor.blackColor()
        subtext6.fontSize = Constants.FontSize.DispFontSize
        subtext6.position = CGPointMake(CGRectGetMidX(self.frame), text6.position.y-subtext6.frame.size.height)
        endNode.addChild(subtext6)
        
        let text7 = SKLabelNode(text: "Hit Next to play!")
        text7.setScale(scaleFactor)
        text7.fontName = Constants.FontName.Game_Font
        text7.fontColor = UIColor.blackColor()
        text7.fontSize = Constants.FontSize.DispFontSize + 4
        text7.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.15)
        endNode.addChild(text7)
    }
}
