//
//  PlayScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit
import GameKit
import FirebaseAnalytics

class PlayScene: SKScene, GameDataProtocol {
    var grid:Grid = Grid()
    var gameData = GameData()
    
    override func didMoveToView(view: SKView) {
        gameData = loadInstance()
        self.userInteractionEnabled = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveLife), name: Constants.Notifications.BOMB_SELECTED, object: nil)
        
        setupScene()
    }
    
    override func update(currentTime: NSTimeInterval) {
        if (grid.hasWon()) {
            nextLevel()
        }
    }
    
    // MARK: Scene Setup
    private func setupScene() {
        self.backgroundColor = UIColor.whiteColor()
        let scale = self.frame.size.width/414.0
        
        let highLevelLabel = SKLabelNode(text: "Highest Level: " + String(gameData.getHighestLevel()))
        highLevelLabel.setScale(scale)
        highLevelLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.85)
        highLevelLabel.fontColor = UIColor.blackColor()
        highLevelLabel.fontSize = Constants.FontSize.DispFontSize
        highLevelLabel.fontName = Constants.FontName.Game_Font
        highLevelLabel.name = "Highest Level Label"
        self.addChild(highLevelLabel)
        
        let levelLabel = SKLabelNode(text: "Current Level: " + String(self.grid.currentLevel()))
        levelLabel.setScale(scale)
        levelLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.80)
        levelLabel.fontColor = UIColor.blackColor()
        levelLabel.fontSize = Constants.FontSize.DispFontSize
        levelLabel.fontName = Constants.FontName.Game_Font
        levelLabel.name = "Level Label"
        self.addChild(levelLabel)
        
        let coinsLabel = SKLabelNode(text: String(gameData.getCoins()))
        coinsLabel.setScale(scale)
        coinsLabel.horizontalAlignmentMode = .Left
        coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame)-coinsLabel.frame.size.width/1.5, self.frame.size.height*0.15)
        coinsLabel.fontColor = UIColor.blackColor()
        coinsLabel.fontSize = Constants.FontSize.DispFontSize
        coinsLabel.fontName = Constants.FontName.Game_Font
        coinsLabel.name = "Coins Label"
        self.addChild(coinsLabel)
        
        let coinsIcon = SKSpriteNode(imageNamed: "thousandCoins")
        coinsIcon.setScale(0.25*scale)
        coinsIcon.position = CGPointMake(CGRectGetMidX(self.frame)+coinsIcon.frame.size.width, coinsLabel.position.y+coinsIcon.frame.size.height/2)
        self.addChild(coinsIcon)
        
        let lifeLabel = SKLabelNode(text: String(gameData.getLives()))
        lifeLabel.setScale(scale)
        lifeLabel.position = CGPointMake(CGRectGetMidX(self.frame)-lifeLabel.frame.size.width, self.frame.size.height*0.1)
        lifeLabel.fontColor = UIColor.blackColor()
        lifeLabel.fontSize = Constants.FontSize.DispFontSize
        lifeLabel.fontName = Constants.FontName.Game_Font
        lifeLabel.name = "Life Label"
        self.addChild(lifeLabel)
        
        let lifeIcon = SKSpriteNode(imageNamed: "lifeIcon")
        lifeIcon.setScale(0.25*scale)
        lifeIcon.position = CGPointMake(lifeLabel.position.x+1.5*lifeIcon.frame.size.width, lifeLabel.position.y+lifeIcon.frame.size.height/2)
        self.addChild(lifeIcon)
        
        grid.setScale(scale)
        let offset = 125*scale
        self.grid.position = CGPointMake(CGRectGetMidX(self.frame) - offset, CGRectGetMidY(self.frame) - offset)
        self.addChild(grid)
    }
    
    // MARK: Next Level
    private func nextLevel() {
        updateLabels()
        FIRAnalytics.logEventWithName(kFIREventLevelUp, parameters: [kFIRParameterLevel:grid.currentLevel() as NSNumber])
    }
    private func coinsForLevel() -> Int {
        return 10
    }
    private func updateLabels() {
        let label:SKLabelNode = self.childNodeWithName("Level Label") as! SKLabelNode
        grid.createGridForNextLevel()
        label.text = "Current Level: " + String(grid.currentLevel())
        gameData.addCoins(coinsForLevel())
        let coinsLabel:SKLabelNode = self.childNodeWithName("Coins Label") as! SKLabelNode
        coinsLabel.text =  String(gameData.getCoins())
        let lifeLabel = self.childNodeWithName("Life Label") as! SKLabelNode
        lifeLabel.text = String(gameData.getLives())
    }
    // MARK: End Game methods and helpers
    func endGame() {
        self.checkMigration()
        gameData.addLevel(grid.currentLevel())
        saveGame(self.gameData)
        let scene:GameOverScene = GameOverScene(size: self.size)
        scene.currentLevel = grid.currentLevel()
        scene.highscore = gotHighScore()
        grid.removeFromParent()
        scene.grid = grid
        self.view?.presentScene(scene)
    }
    
    // MARK: Save Life
    func saveLife() {
        if gameData.getLives() > 0 {
            showSaveLifeAlert()
        } else {
            endGame()
        }
    }
    func showSaveLifeAlert() {
        let alert_controller = UIAlertController(title: "Save Life", message: "You have " + String(gameData.getLives()) + " to use.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let dismiss_action = UIAlertAction(title: "No Thanks.", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.endGame()
        }
        let purchase_action = UIAlertAction(title: "Save Me", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //inAppPurchases.defaultHelper.saveLife()
            self.gameData.useLife()
            self.saveGame(self.gameData)
            FIRAnalytics.logEventWithName("Save Life Used", parameters: nil)
        }
        alert_controller.addAction(purchase_action)
        alert_controller.addAction(dismiss_action)
        self.scene?.view?.window?.rootViewController?.presentViewController(alert_controller, animated: true, completion: nil)
    }

    private func gotHighScore() -> Bool {
        return gameData.getHighestLevel() < grid.currentLevel()
    }
    
    // MARK: Migration: Helper to migrate users NSUserDefaults to GameData archiving
    private func checkMigration() {
        if GKLocalPlayer.localPlayer().authenticated {
            let defaults = NSUserDefaults.standardUserDefaults()
            if defaults.integerForKey(DefaultKeys.Migrate.description) == 0 {
                let coins = defaults.integerForKey(DefaultKeys.Money.description)
                gameData.addCoins(coins)
                defaults.setInteger(0, forKey: DefaultKeys.Money.description)
                let highscore = GameKitHelper.sharedGameKitHelper.getHighScore()
                gameData.addLevel(highscore)
                saveGame(self.gameData)
                defaults.setInteger(1, forKey: DefaultKeys.Migrate.description)
                defaults.synchronize()
            }
        }
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
