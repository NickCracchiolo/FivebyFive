//
//  GameOverScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
	var gameData:GameData?
    var currentLevel = 0
    var highscore:Bool = false
    var grid = Grid()
    
	override func didMove(to view: SKView) {
        gameData = loadInstance()
        setupScene()
    }

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
			let location = (touch as! UITouch).location(in: self)
			let node = self.atPoint(location)
            
            if node.name == "Main Menu Button" {
				let scene = StartScene(size: self.size)
				scene.gameData = self.gameData
                self.view?.presentScene(scene)
            } else if node.name == "Leaderboard Button" {
				NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.PRESENT_LEADERBOARDS), object: nil)
            }
        }
    }
    
    // MARK: Scene Setup
    private func setupScene() {
		self.backgroundColor = UIColor.white
        let scale = self.frame.size.width/414.0
        
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontSize = Constants.FontSize.Title
        gameOverLabel.fontColor = UIColor.black
        gameOverLabel.fontName = Constants.FontName.Game_Font
        gameOverLabel.setScale(scale)
		gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.85)
        self.addChild(gameOverLabel)
        
        highScoreDisplay()
        
        self.grid.setScale(scale)
        let offset = 125*scale
		self.grid.position = CGPoint(x: self.frame.midX - offset, y: self.frame.midY - offset)
        self.addChild(grid)
        grid.showAllTiles()
        
        let leaderButton = SKSpriteNode(imageNamed: "leaderboardsButton")
        leaderButton.setScale(scale)
		leaderButton.position = CGPoint(x: self.frame.midX/2, y: self.frame.size.height*0.15)
        leaderButton.name = "Leaderboard Button"
        self.addChild(leaderButton)
        
        
        let mainButton = SKSpriteNode(imageNamed: "homeButton")
        mainButton.setScale(scale)
		mainButton.position = CGPoint(x: self.frame.midX*1.5, y: self.frame.size.height*0.15)
        mainButton.name = "Main Menu Button"
        self.addChild(mainButton)
        
    }
    private func highScoreDisplay() {
        let scale = self.frame.size.width/414.0
        
        let levelLabel = SKLabelNode(text: "You made it to Level: " + String(currentLevel))
        levelLabel.fontSize = Constants.FontSize.DispFontSize
        levelLabel.fontName = Constants.FontName.Game_Font
        levelLabel.setScale(scale)
        levelLabel.fontColor = UIColor.black
		levelLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.8)
        self.addChild(levelLabel)
    }
}
