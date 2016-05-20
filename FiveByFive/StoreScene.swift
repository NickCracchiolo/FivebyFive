//
//  StoreScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class StoreScene:SKScene, GameDataProtocol {
    var wheel:FFWheel = FFWheel()
    var gameData = GameData()
    
    override func didMoveToView(view: SKView) {
        gameData = loadInstance()
        setupGestures()
        setupScene()
    }
    override func update(currentTime: NSTimeInterval) {
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            let node = self.nodeAtPoint(location)
            if node.name == "Purchase Button" {
                let item = wheel.currentObject() as! PurchaseItem
                item.purchaseItem()
            }
            if node.name == "Back Button" {
                self.view?.presentScene(StartScene(size: self.size))
            }
        }
    }
    
    // MARK: Scene Setup
    private func setupScene() {
        self.backgroundColor = UIColor.whiteColor()
        let scale = self.frame.size.width/414.0
        
        wheel = FFWheel(withNodes: getPurchaseItems())
        wheel.setScale(scale)
        self.addChild(wheel)
        
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.setScale(scale)
        backButton.position = CGPointMake(CGRectGetMinX(self.frame)+backButton.frame.size.width, CGRectGetMaxY(self.frame)-backButton.frame.size.height)
        backButton.name = "Back Button"
        self.addChild(backButton)
        
        let purchaseButton = SKSpriteNode(imageNamed: "playButton")
        purchaseButton.setScale(scale)
        purchaseButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 150)
        self.addChild(purchaseButton)
        
        let coinsLabel = SKLabelNode(text: String(NSUserDefaults.standardUserDefaults().integerForKey(DefaultKeys.Money.description)))
        coinsLabel.setScale(scale)
        coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.75)
        coinsLabel.fontName = Constants.FontName.Title_Font
        coinsLabel.fontSize = Constants.FontSize.Title
        coinsLabel.fontColor = UIColor.blackColor()
        self.addChild(coinsLabel)
    }
    
    // MARK: Gesture Setup
    private func setupGestures() {
        let swipe_right = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipe_right.direction = UISwipeGestureRecognizerDirection.Right
        self.view?.addGestureRecognizer(swipe_right)
        
        let swipe_left = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipe_left.direction = UISwipeGestureRecognizerDirection.Left
        self.view?.addGestureRecognizer(swipe_left)
    }
    func swipeRight() {
        self.wheel.moveRight()
    }
    func swipeLeft() {
        self.wheel.moveLeft()
    }
    
    // MARK Purchase Items from Plist
    private func getPurchaseItems() -> [SKSpriteNode] {
        var purchases:[SKSpriteNode] = []
        if let plist = Plist(name: "PurchasesList") {
            let dict = plist.getValuesInPlist()!
            for (key,value) in dict {
                let subDict = value as! NSDictionary
                let coins = subDict["coins"] as! Int
                let cost = subDict["cost"] as! Float
                let image = subDict["image"] as! String
                let productID = subDict["purchaseID"] as! String
                let item = PurchaseItem(amountOfCoins: coins, forAPriceOf: cost, withID: productID, withImage: image)
                purchases.append(item)
                item.name = key as? String
                item.hidden = true
                item.zPosition = 0
                self.addChild(item)
            }
        } else {
            print("Unable to get Plist")
        }
        return purchases
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