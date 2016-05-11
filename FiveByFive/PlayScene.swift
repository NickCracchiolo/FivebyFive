//
//  PlayScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class PlayScene: SKScene {
    var grid:Grid = Grid()
    
    override func didMoveToView(view: SKView) {
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
        print("Touched in PlayScene")
        if (grid.hasWon()) {
            nextLevel()
        }
    }
    func endGame() {
        //play bomb animation (inside tile)
        //tile notifies this scene which calls this function. Notifies the user of the game ending,
        //level, if they got a high score, and then presents the main screen
        
        //GameKitHelper.sharedGameKitHelper.reportScore(grid.currentLevel())
        self.view?.presentScene(StartScene(size: self.size))
    }
    private func nextLevel() {
        let label = self.childNodeWithName("Level Label") as! SKLabelNode
        grid.createGridForNextLevel()
        label.text = String(grid.currentLevel())
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
    }
}
