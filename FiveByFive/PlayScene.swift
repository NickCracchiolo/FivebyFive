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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /*
        for touch:AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            let node = self.nodeAtPoint(location)
        }
        */
    }
    
    // MARK: Scene Setup
    private func setupScene() {
        self.backgroundColor = UIColor.whiteColor()
        let scale = self.frame.size.width/414.0
        
        let level_label = SKLabelNode(text: "Level: " + String(self.grid.currentLevel()))
        level_label.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.75)
        level_label.fontColor = UIColor.blackColor()
        level_label.fontSize = Constants.FontSize.DispFontSize
        level_label.fontName = Constants.FontName.Game_Font
        level_label.name = "Level Label"
        self.addChild(level_label)
        
        grid.setScale(scale)
        let offset = 125*scale
        self.grid.position = CGPointMake(CGRectGetMidX(self.frame) - offset, CGRectGetMidY(self.frame) - offset)
        self.addChild(grid)
    }
    
    // MARK: Next Level
    private func nextLevel() {
        let label = self.childNodeWithName("Level Label") as! SKLabelNode
        grid.createGridForNextLevel()
        label.text = "Level: " + String(grid.currentLevel())
        gameData.addCoins(coinsForLevel())
    }
    private func coinsForLevel() -> Int {
        return 20*(grid.currentLevel() - 1)
    }
    
    // MARK: End Game methods and helpers
    func endGame() {
        print("End Game")
        self.checkMigration()
        gameData.addLevel(grid.currentLevel())
        saveGame()
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
            print("Lives > 0")
            //endGame()
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
            self.saveGame()
            
        }
        alert_controller.addAction(purchase_action)
        alert_controller.addAction(dismiss_action)
        self.scene?.view?.window?.rootViewController?.presentViewController(alert_controller, animated: true, completion: nil)
    }

    private func gotHighScore() -> Bool {
        let str = String(gameData.getHighestLevel()) + " < " + String(grid.currentLevel())
        print(str)
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
                print("Highscore: ",highscore)
                gameData.addLevel(highscore)
                saveGame()
                defaults.setInteger(1, forKey: DefaultKeys.Migrate.description)
                defaults.synchronize()
            }
        }
    }
    
    // MARK: Game Data Protocol
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
