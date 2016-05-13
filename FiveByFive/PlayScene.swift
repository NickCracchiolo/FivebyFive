//
//  PlayScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene, GameDataProtocol {
    var grid:Grid = Grid()
    var gameData = GameData()
    
    override func didMoveToView(view: SKView) {
        gameData = loadInstance()
        self.userInteractionEnabled = true
        self.backgroundColor = UIColor.whiteColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(endGame), name: Constants.Notifications.BOMB_SELECTED, object: nil)
        
        setupScene()
    }
    override func update(currentTime: NSTimeInterval) {
        if (grid.hasWon()) {
            nextLevel()
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            let node = self.nodeAtPoint(location)
            if node.name == "End Game Button" {
                endGame()
            }
        }
    }
    func endGame() {
        
        gameData.addLevel(grid.currentLevel())
        saveGame()
        let scene:GameOverScene = GameOverScene(size: self.size)
        scene.currentLevel = grid.currentLevel()
        scene.highscore = gotHighScore()
        self.view?.presentScene(scene)
    }
    private func saveLife() {
        if gameData.getLives() > 0 {
            
        }
    }
    private func nextLevel() {
        let label = self.childNodeWithName("Level Label") as! SKLabelNode
        grid.createGridForNextLevel()
        label.text = "Level: " + String(grid.currentLevel())
    }
    func showSaveLifeAlert() {
        let alert_controller = UIAlertController(title: "Free Coins", message: "Want a Second Chance for $0.99?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let dismiss_action = UIAlertAction(title: "No Thanks.", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //counter = 0
            //self.touch_enabled = false
            //self.GameOverScreen()
        }
        let stop_asking_action = UIAlertAction(title: "Don't Ask Again", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //self.defaults.setInteger(1, forKey: DefaultKeys.Life.description)
            //counter = 0
            //self.touch_enabled = false
            //self.GameOverScreen()
        }
        let purchase_action = UIAlertAction(title: "Yes Please!", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //inAppPurchases.defaultHelper.saveLife()
            
        }
        alert_controller.addAction(purchase_action)
        alert_controller.addAction(dismiss_action)
        alert_controller.addAction(stop_asking_action)
        self.scene?.view?.window?.rootViewController?.presentViewController(alert_controller, animated: true, completion: nil)
    }
    private func setupScene() {
        let level_label = SKLabelNode(text: "Level: " + String(self.grid.currentLevel()))
        level_label.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.75)
        level_label.fontColor = UIColor.blackColor()
        level_label.fontSize = Constants.FontSize.DispFontSize
        level_label.fontName = Constants.FontName.Game_Font
        level_label.name = "Level Label"
        self.addChild(level_label)
        
        self.grid.position = CGPointMake(CGRectGetMidX(self.frame) - 125, CGRectGetMidY(self.frame) - 125)
        self.addChild(grid)
        
        let endGameBtn = SKSpriteNode(imageNamed: "playButton")
        endGameBtn.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.2)
        endGameBtn.name = "End Game Button"
        self.addChild(endGameBtn)
    }
    private func gotHighScore() -> Bool {
        return gameData.getHighestLevel() < grid.currentLevel()
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
