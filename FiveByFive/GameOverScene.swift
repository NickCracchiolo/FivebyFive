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
    var grid = Grid()
    
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
    
    // MARK: Scene Setup
    private func setupScene() {
        self.backgroundColor = UIColor.whiteColor()
        let scale = self.frame.size.width/414.0
        
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = Constants.FontSize.Title
        gameOverLabel.fontColor = UIColor.blackColor()
        gameOverLabel.fontName = Constants.FontName.Game_Font
        gameOverLabel.setScale(scale)
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.85)
        self.addChild(gameOverLabel)
        
        highScoreDisplay()
        
        self.grid.setScale(scale)
        let offset = 125*scale
        self.grid.position = CGPointMake(CGRectGetMidX(self.frame) - offset, CGRectGetMidY(self.frame) - offset)
        self.addChild(grid)
        grid.showAllTiles()
        
        let leaderButton = SKSpriteNode(imageNamed: "leaderboardsButton")
        leaderButton.setScale(scale)
        leaderButton.position = CGPointMake(CGRectGetMidX(self.frame)/2, self.frame.size.height*0.15)
        leaderButton.name = "Leaderboard Button"
        self.addChild(leaderButton)
        
        
        let mainButton = SKSpriteNode(imageNamed: "homeButton")
        mainButton.setScale(scale)
        mainButton.position = CGPointMake(CGRectGetMidX(self.frame)*1.5, self.frame.size.height*0.15)
        mainButton.name = "Main Menu Button"
        self.addChild(mainButton)
        
    }
    private func highScoreDisplay() {
        let scale = self.frame.size.width/414.0
        
        let levelLabel = SKLabelNode(text: "You made it to Level: " + String(currentLevel))
        levelLabel.fontSize = Constants.FontSize.DispFontSize
        levelLabel.fontName = Constants.FontName.Game_Font
        levelLabel.setScale(scale)
        levelLabel.fontColor = UIColor.blackColor()
        levelLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.8)
        self.addChild(levelLabel)
    }
    
    // MARK: Game Data Protocol
    func saveGame(withData:GameData) {
        let encodedData = NSKeyedArchiver.archiveRootObject(withData, toFile: GameData.archiveURL.path!)
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