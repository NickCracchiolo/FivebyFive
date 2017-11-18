//
//  PlayScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit
import GameKit

class PlayScene: SKScene {
    var grid:Grid = Grid()
	var gameData:GameData?
	
	override func didMove(to view: SKView) {
        self.isUserInteractionEnabled = true
		NotificationCenter.default.addObserver(self, selector: #selector(saveLife), name: NSNotification.Name(rawValue: Constants.Notifications.BOMB_SELECTED), object: nil)
        
        setupScene()
    }
	
	override func update(_ currentTime: TimeInterval) {
        if (grid.hasWon()) {
            nextLevel()
        }
    }
    
    // MARK: Scene Setup
    private func setupScene() {
        self.backgroundColor = UIColor.white
        let scale = self.frame.size.width/414.0
		guard let data = self.gameData else {
			return
		}
        let highLevelLabel = SKLabelNode(text: "Highest Level: " + String(data.getHighestLevel()))
        highLevelLabel.setScale(scale)
		highLevelLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.85)
        highLevelLabel.fontColor = UIColor.black
        highLevelLabel.fontSize = Constants.FontSize.DispFontSize
        highLevelLabel.fontName = Constants.FontName.Game_Font
        highLevelLabel.name = "Highest Level Label"
        self.addChild(highLevelLabel)
        
        let levelLabel = SKLabelNode(text: "Current Level: " + String(self.grid.currentLevel()))
        levelLabel.setScale(scale)
		levelLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.80)
        levelLabel.fontColor = UIColor.black
        levelLabel.fontSize = Constants.FontSize.DispFontSize
        levelLabel.fontName = Constants.FontName.Game_Font
        levelLabel.name = "Level Label"
        self.addChild(levelLabel)
        
        let coinsLabel = SKLabelNode(text: String(data.getCoins()))
        coinsLabel.setScale(scale)
		coinsLabel.horizontalAlignmentMode = .left
		coinsLabel.position = CGPoint(x: self.frame.midX-coinsLabel.frame.size.width/1.5, y: self.frame.size.height*0.15)
        coinsLabel.fontColor = UIColor.black
        coinsLabel.fontSize = Constants.FontSize.DispFontSize
        coinsLabel.fontName = Constants.FontName.Game_Font
        coinsLabel.name = "Coins Label"
        self.addChild(coinsLabel)
        
        let coinsIcon = SKSpriteNode(imageNamed: "thousandCoins")
        coinsIcon.setScale(0.25*scale)
		coinsIcon.position = CGPoint(x: self.frame.midX+coinsIcon.frame.size.width, y: coinsLabel.position.y+coinsIcon.frame.size.height/2)
        self.addChild(coinsIcon)
        
        let lifeLabel = SKLabelNode(text: String(data.getLives()))
        lifeLabel.setScale(scale)
		lifeLabel.position = CGPoint(x: self.frame.midY-lifeLabel.frame.size.width, y: self.frame.size.height*0.1)
        lifeLabel.fontColor = UIColor.black
        lifeLabel.fontSize = Constants.FontSize.DispFontSize
        lifeLabel.fontName = Constants.FontName.Game_Font
        lifeLabel.name = "Life Label"
        self.addChild(lifeLabel)
        
        let lifeIcon = SKSpriteNode(imageNamed: "lifeIcon")
        lifeIcon.setScale(0.25*scale)
		lifeIcon.position = CGPoint(x: lifeLabel.position.x+1.5*lifeIcon.frame.size.width, y: lifeLabel.position.y+lifeIcon.frame.size.height/2)
        self.addChild(lifeIcon)
        
        grid.setScale(scale)
        let offset = 125*scale
		self.grid.position = CGPoint(x: self.frame.midX - offset, y: self.frame.midY - offset)
        self.addChild(grid)
    }
    
    // MARK: Next Level
    private func nextLevel() {
        updateLabels()
    }
    private func coinsForLevel() -> Int {
        return 10
    }
    private func updateLabels() {
		if let data = self.gameData {
			let label:SKLabelNode = self.childNode(withName: "Level Label") as! SKLabelNode
			grid.createGridForNextLevel()
			label.text = "Current Level: " + String(grid.currentLevel())
			data.addCoins(value: coinsForLevel())
			let coinsLabel:SKLabelNode = self.childNode(withName: "Coins Label") as! SKLabelNode
			coinsLabel.text =  String(describing: data.getCoins())
			let lifeLabel = self.childNode(withName: "Life Label") as! SKLabelNode
			lifeLabel.text = String(describing: data.getLives())
		}
    }
    // MARK: End Game methods and helpers
    func endGame() {
        self.checkMigration()
		if let data = gameData {
			data.addLevel(num: grid.currentLevel())
			saveGame(withData: data)
		}
        let scene:GameOverScene = GameOverScene(size: self.size)
        scene.currentLevel = grid.currentLevel()
        scene.highscore = gotHighScore()
        grid.removeFromParent()
        scene.grid = grid
		scene.gameData = self.gameData
        self.view?.presentScene(scene)
    }
    
    // MARK: Save Life
    @objc func saveLife() {
        if let data = gameData, data.getLives() > 0 {
            showSaveLifeAlert()
        } else {
            endGame()
        }
    }
    func showSaveLifeAlert() {
		var lives = 0
		if let data = gameData {
			lives = data.getLives()
		}
		let alert_controller = UIAlertController(title: "Save Life", message: "You have " + String(lives) + " to use.", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let dismiss_action = UIAlertAction(title: "No Thanks.", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.endGame()
        }
		let purchase_action = UIAlertAction(title: "Save Me", style: UIAlertActionStyle.default) {
            UIAlertAction in
            //inAppPurchases.defaultHelper.saveLife()
			if let data = self.gameData {
            	data.useLife()
				self.saveGame(withData: data)
			}
        }
        alert_controller.addAction(purchase_action)
        alert_controller.addAction(dismiss_action)
		self.scene?.view?.window?.rootViewController?.present(alert_controller, animated: true, completion: nil)
    }

    private func gotHighScore() -> Bool {
		if let data = gameData {
			return data.getHighestLevel() < grid.currentLevel()
		}
        return false
    }
    
    // MARK: Migration: Helper to migrate users NSUserDefaults to GameData archiving
    private func checkMigration() {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let defaults = UserDefaults.standard
			if defaults.integer(forKey: DefaultKeys.migrate.description) == 0 {
				guard let data = self.gameData else {
					return
				}
				let coins = defaults.integer(forKey: DefaultKeys.money.description)
				data.addCoins(value: coins)
				defaults.set(0, forKey: DefaultKeys.money.description)
                let highscore = GameKitHelper.sharedGameKitHelper.getHighScore()
				data.addLevel(num: highscore)
				saveGame(withData: data)
				defaults.set(1, forKey: DefaultKeys.migrate.description)
            }
        }
    }
}
