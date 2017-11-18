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
    var introNode:SKNode = SKNode()
    var tilesNode:SKNode = SKNode()
    var sideNode:SKNode  = SKNode()
    var endNode:SKNode   = SKNode()
    var scaleFactor:CGFloat = 0
    var grid = Grid()
    
	override func didMove(to view: SKView) {
        scaleFactor = self.frame.size.width/414.0
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(nextState))
        swipeRight.direction = .right
        self.view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(previousState))
        swipeLeft.direction = .left
        self.view?.addGestureRecognizer(swipeLeft)
        
        setupScene()
        introNode.isHidden = false
        tilesNode.isHidden = true
        sideNode.isHidden = true
        endNode.isHidden = true
        self.addChild(introNode)
        self.addChild(tilesNode)
        self.addChild(sideNode)
        self.addChild(endNode)
        introStateSetup()
        tilesStateSetup()
        sideStateSetup()
        endStateSetup()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
			let location = (touch as! UITouch).location(in: self)
			let node = self.atPoint(location)
            
            if node.name == "Next Button" {
                nextState()
            } else if node.name == "Previous Button" {
                previousState()
            }
        }
    }
    
    func setupScene() {
        self.backgroundColor = UIColor.white
        
        let titleLabel = SKLabelNode(text: "How To Play")
        titleLabel.setScale(scaleFactor)
        titleLabel.fontName = Constants.FontName.Game_Font
        titleLabel.fontColor = UIColor.black
        titleLabel.fontSize = Constants.FontSize.Title
		titleLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.9)
        self.addChild(titleLabel)
        
        let nextButton = SKSpriteNode(imageNamed: "nextButton")
        nextButton.setScale(scaleFactor)
		nextButton.position = CGPoint(x: self.frame.midX-nextButton.frame.size.width, y: self.frame.size.height*0.075)
        nextButton.name = "Next Button"
        self.addChild(nextButton)
        
        let backButton = SKSpriteNode(imageNamed: "previousButton")
        backButton.setScale(scaleFactor)
		backButton.position = CGPoint(x: backButton.frame.size.width, y: self.frame.size.height*0.075)
        backButton.name = "Previous Button"
        self.addChild(backButton)
        
        grid.setScale(scaleFactor)
        let offset = 125*scaleFactor
		grid.position = CGPoint(x: self.frame.midX - offset, y: self.frame.midY - offset)
        self.addChild(grid)
    }
    
    @objc func nextState() {
        switch state {
        case .Intro:
            introNode.isHidden = true
            state = .TilesInfo
            tilesNode.isHidden = false
            grid.isHidden = true
        case .TilesInfo:
            tilesNode.isHidden = true
            state = .SideInfo
            sideNode.isHidden = false
            grid.isHidden = false
        case .SideInfo:
            sideNode.isHidden = true
            state = .End
            endNode.isHidden = false
            grid.isHidden = true
        case .End:
			let scene = PlayScene(size: self.size)
			scene.gameData = loadInstance()
            self.view?.presentScene(scene)
        }
    }
    @objc func previousState() {
        switch state {
        case .Intro:
            return
        case .TilesInfo:
            tilesNode.isHidden = true
            state = .Intro
            introNode.isHidden = false
            grid.isHidden = false
        case .SideInfo:
            sideNode.isHidden = true
            state = .TilesInfo
            tilesNode.isHidden = false
            grid.isHidden = true
        case .End:
            endNode.isHidden = true
            state = .SideInfo
            sideNode.isHidden = false
            grid.isHidden = false
        }
    }
    
    //----------------------------------------
    // MARK: State Scene Setups
    //----------------------------------------
    private func introStateSetup() {
        let text1 = SKLabelNode(text: "Flip tiles without hitting")
        text1.setScale(scaleFactor)
        text1.fontName = Constants.FontName.Game_Font
        text1.fontColor = UIColor.black
        text1.fontSize = Constants.FontSize.DispFontSize
		text1.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.825)
        introNode.addChild(text1)
        
        let text2 = SKLabelNode(text: "any hidden bombs")
        text2.setScale(scaleFactor)
        text2.fontName = Constants.FontName.Game_Font
        text2.fontColor = UIColor.black
        text2.fontSize = Constants.FontSize.DispFontSize
		text2.position = CGPoint(x: self.frame.midX, y: text1.position.y-text2.frame.size.height)
        introNode.addChild(text2)
        
    }
    private func tilesStateSetup() {
        let text1 = SKLabelNode(text: "This is a bomb tile, Don't ")
        text1.setScale(scaleFactor)
        text1.fontName = Constants.FontName.Game_Font
        text1.fontColor = UIColor.black
        text1.fontSize = Constants.FontSize.DispFontSize
		text1.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.75)
        tilesNode.addChild(text1)
        
        let text2 = SKLabelNode(text: "touch these and you'll do fine")
        text2.setScale(scaleFactor)
        text2.fontName = Constants.FontName.Game_Font
        text2.fontColor = UIColor.black
        text2.fontSize = Constants.FontSize.DispFontSize
		text2.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.75-text2.frame.size.height)
        tilesNode.addChild(text2)
        
        let bombTile = SKSpriteNode(imageNamed: "bombTile")
        bombTile.setScale(scaleFactor)
		bombTile.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.65)
        tilesNode.addChild(bombTile)
        
        let text3 = SKLabelNode(text: "These are numbered tiles,")
        text3.setScale(scaleFactor)
        text3.fontName = Constants.FontName.Game_Font
        text3.fontColor = UIColor.black
        text3.fontSize = Constants.FontSize.DispFontSize
		text3.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.4)
        tilesNode.addChild(text3)
        
        let text4 = SKLabelNode(text: "you want to flip them")
        text4.setScale(scaleFactor)
        text4.fontName = Constants.FontName.Game_Font
        text4.fontColor = UIColor.black
        text4.fontSize = Constants.FontSize.DispFontSize
		text4.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.4-text4.frame.size.height)
        tilesNode.addChild(text4)
        
        let blueOne = SKSpriteNode(imageNamed: "blueOne")
        blueOne.setScale(scaleFactor)
		blueOne.position = CGPoint(x: self.frame.midX - blueOne.frame.size.width*2-10, y: self.frame.size.height*0.3)
        tilesNode.addChild(blueOne)
        
        let blueTwo = SKSpriteNode(imageNamed: "blueTwo")
        blueTwo.setScale(scaleFactor)
		blueTwo.position = CGPoint(x: self.frame.midX - blueTwo.frame.size.width-5, y: self.frame.size.height*0.3)
        tilesNode.addChild(blueTwo)
        
        let blueThree = SKSpriteNode(imageNamed: "blueThree")
        blueThree.setScale(scaleFactor)
		blueThree.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.3)
        tilesNode.addChild(blueThree)
        
        let blueFour = SKSpriteNode(imageNamed: "blueFour")
        blueFour.setScale(scaleFactor)
		blueFour.position = CGPoint(x: self.frame.midX + blueFour.frame.size.width+5, y: self.frame.size.height*0.3)
        tilesNode.addChild(blueFour)
        
        let blueFive = SKSpriteNode(imageNamed: "blueFive")
        blueFive.setScale(scaleFactor)
		blueFive.position = CGPoint(x: self.frame.midX + blueFive.frame.size.width*2+10, y: self.frame.size.height*0.3)
        tilesNode.addChild(blueFive)
    }
    private func sideStateSetup() {
        let text1 = SKLabelNode(text: "The red numbers are")
        text1.setScale(scaleFactor)
        text1.fontName = Constants.FontName.Game_Font
        text1.fontColor = UIColor.red
        text1.fontSize = Constants.FontSize.DispFontSize
		text1.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.83)
        sideNode.addChild(text1)
        
        let subtext1 = SKLabelNode(text: "the number of bombs")
        subtext1.setScale(scaleFactor)
        subtext1.fontName = Constants.FontName.Game_Font
        subtext1.fontColor = UIColor.red
        subtext1.fontSize = Constants.FontSize.DispFontSize
		subtext1.position = CGPoint(x: self.frame.midX, y: text1.position.y-subtext1.frame.size.height)
        sideNode.addChild(subtext1)
        
        let text2 = SKLabelNode(text: "in the corresponding")
        text2.setScale(scaleFactor)
        text2.fontName = Constants.FontName.Game_Font
        text2.fontColor = UIColor.red
        text2.fontSize = Constants.FontSize.DispFontSize
		text2.position = CGPoint(x: self.frame.midX, y: subtext1.position.y-text2.frame.size.height)
        sideNode.addChild(text2)
        
        let subtext2 = SKLabelNode(text: "row or column")
        subtext2.setScale(scaleFactor)
        subtext2.fontName = Constants.FontName.Game_Font
        subtext2.fontColor = UIColor.red
        subtext2.fontSize = Constants.FontSize.DispFontSize
		subtext2.position = CGPoint(x: self.frame.midX, y: text2.position.y-subtext2.frame.size.height)
        sideNode.addChild(subtext2)
        
        let text3 = SKLabelNode(text: "The black numbers represent")
        text3.setScale(scaleFactor)
        text3.fontName = Constants.FontName.Game_Font
        text3.fontColor = UIColor.black
        text3.fontSize = Constants.FontSize.DispFontSize
		text3.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.2)
        sideNode.addChild(text3)
        
        let subtext3 = SKLabelNode(text: "the sum of tiles in")
        subtext3.setScale(scaleFactor)
        subtext3.fontName = Constants.FontName.Game_Font
        subtext3.fontColor = UIColor.black
        subtext3.fontSize = Constants.FontSize.DispFontSize
		subtext3.position = CGPoint(x: self.frame.midX, y: text3.position.y - subtext3.frame.size.height)
        sideNode.addChild(subtext3)
        
        let text4 = SKLabelNode(text: "each row or column")
        text4.setScale(scaleFactor)
        text4.fontName = Constants.FontName.Game_Font
        text4.fontColor = UIColor.black
        text4.fontSize = Constants.FontSize.DispFontSize
		text4.position = CGPoint(x: self.frame.midX, y: subtext3.position.y - text4.frame.size.height)
        sideNode.addChild(text4)
    }
    private func endStateSetup() {
        let text1 = SKLabelNode(text: "You are now ready to play!")
        text1.setScale(scaleFactor)
        text1.fontName = Constants.FontName.Game_Font
        text1.fontColor = UIColor.black
        text1.fontSize = Constants.FontSize.DispFontSize
		text1.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.75)
        endNode.addChild(text1)
        
        let text2 = SKLabelNode(text: "Try to get to the highest")
        text2.setScale(scaleFactor)
        text2.fontName = Constants.FontName.Game_Font
        text2.fontColor = UIColor.black
        text2.fontSize = Constants.FontSize.DispFontSize
		text2.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.7-text2.frame.size.height)
        endNode.addChild(text2)
        
        let text3 = SKLabelNode(text: "level without hitting a bomb.")
        text3.setScale(scaleFactor)
        text3.fontName = Constants.FontName.Game_Font
        text3.fontColor = UIColor.black
        text3.fontSize = Constants.FontSize.DispFontSize
		text3.position = CGPoint(x: self.frame.midX, y: text2.position.y-text3.frame.size.height)
        endNode.addChild(text3)
        
        let text4 = SKLabelNode(text: "You have 3 lives to start")
        text4.setScale(scaleFactor)
        text4.fontName = Constants.FontName.Game_Font
        text4.fontColor = UIColor.black
        text4.fontSize = Constants.FontSize.DispFontSize
		text4.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.55)
        endNode.addChild(text4)
        
        let subtext4 = SKLabelNode(text: "which can save you if")
        subtext4.setScale(scaleFactor)
        subtext4.fontName = Constants.FontName.Game_Font
        subtext4.fontColor = UIColor.black
        subtext4.fontSize = Constants.FontSize.DispFontSize
		subtext4.position = CGPoint(x: self.frame.midX, y: text4.position.y - subtext4.frame.size.height)
        endNode.addChild(subtext4)
        
        let text5 = SKLabelNode(text: "you uncover a bomb.")
        text5.setScale(scaleFactor)
        text5.fontName = Constants.FontName.Game_Font
        text5.fontColor = UIColor.black
        text5.fontSize = Constants.FontSize.DispFontSize
		text5.position = CGPoint(x: self.frame.midX, y: subtext4.position.y-text5.frame.size.height)
        endNode.addChild(text5)
        
        let saveLife = SKSpriteNode(imageNamed: "lifeIcon")
        saveLife.setScale(scaleFactor)
		saveLife.position = CGPoint(x: self.frame.midX, y: text5.position.y - 50)
        endNode.addChild(saveLife)
        
        let text6 = SKLabelNode(text: "You can purchase a.")
        text6.setScale(scaleFactor)
        text6.fontName = Constants.FontName.Game_Font
        text6.fontColor = UIColor.black
        text6.fontSize = Constants.FontSize.DispFontSize
		text6.position = CGPoint(x: self.frame.midX, y: saveLife.position.y - saveLife.frame.size.height/1.5)
        endNode.addChild(text6)
        
        let subtext6 = SKLabelNode(text: "life for 200 coins.")
        subtext6.setScale(scaleFactor)
        subtext6.fontName = Constants.FontName.Game_Font
        subtext6.fontColor = UIColor.black
        subtext6.fontSize = Constants.FontSize.DispFontSize
		subtext6.position = CGPoint(x: self.frame.midX, y: text6.position.y-subtext6.frame.size.height)
        endNode.addChild(subtext6)
        
        let text7 = SKLabelNode(text: "Hit Next to play!")
        text7.setScale(scaleFactor)
        text7.fontName = Constants.FontName.Game_Font
        text7.fontColor = UIColor.black
        text7.fontSize = Constants.FontSize.DispFontSize + 4
		text7.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.15)
        endNode.addChild(text7)
    }
}
