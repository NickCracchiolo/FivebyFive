//
//  GameOverScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene, GameDataProtocol {
    var gameData = GameData()
    var currentLevel = 0
    var highscore:Bool = false
    
    override func didMoveToView(view: SKView) {
        gameData = loadInstance()
        setupScene()
    }
    override func update(currentTime: NSTimeInterval) {
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if node.name == "Main Menu Button" {
                self.view?.presentScene(StartScene(size: self.size))
            } else if node.name == "Leaderboard Button" {
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.PRESENT_LEADERBOARDS, object: nil)
            }
        }
    }
    private func setupScene() {
        self.backgroundColor = UIColor.whiteColor()
        
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = Constants.FontSize.Title
        gameOverLabel.fontColor = UIColor.blackColor()
        gameOverLabel.fontName = Constants.FontName.Game_Font
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.75)
        self.addChild(gameOverLabel)
        
        highScoreDisplay()
        
        let leaderButton = FFButton(text: "Leaderboards")
        leaderButton.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.5)
        leaderButton.name = "Leaderboard Button"
        self.addChild(leaderButton)
        
        
        let mainButton = FFButton(text:"Main Menu")
        mainButton.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.3)
        mainButton.name = "Main Menu Button"
        self.addChild(mainButton)
        
    }
    private func highScoreDisplay() {
        let levelLabel = SKLabelNode(fontNamed: Constants.FontName.Game_Font)
        levelLabel.fontSize = Constants.FontSize.DispFontSize
        levelLabel.fontColor = UIColor.blackColor()
        levelLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.6)

        if highscore {
            levelLabel.text = "You only made it to \n Level: " + String(currentLevel)
        } else {
            levelLabel.text = "You Reached Your Highest \n Level Yet of " + String(currentLevel)
        }
        self.addChild(levelLabel)
    }
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