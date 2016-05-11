//
//  StoreScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class StoreScene:SKScene {
    //var currentIndex = 0
    //var purchases:[PurchaseItem] = []
    var wheel:Wheel = Wheel()
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.whiteColor()
        setupGestures()
        setupScene()
        let plist = Plist(name: "PurchasesList")
        //let dict = plist!.getValuesInPlist()!
        //setupPurchaseItems()
        //print("count: ",self.purchases.count)
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
    func swipeRight() {
        self.wheel.moveRight()
        /*
        if currentIndex > 0 {
            currentIndex -= 1
            adjustWheel()
        }
         */
    }
    func swipeLeft() {
        self.wheel.moveLeft()
//        if currentIndex < purchases.count {
//            currentIndex += 1
//            adjustWheel()
//        }
    }
    private func setupScene() {
        //setupPurchaseItems()
        
        let back_button = SKSpriteNode(imageNamed: "")
        back_button.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame)-back_button.frame.size.height)
        self.addChild(back_button)
        
        let purchase_button = SKSpriteNode(imageNamed: "playButton")
        purchase_button.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 150)
        self.addChild(purchase_button)
        
        let coins_label = SKLabelNode(text: String(NSUserDefaults.standardUserDefaults().integerForKey(DefaultKeys.Money.description)))
        coins_label.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.75)
        coins_label.fontName = Constants.FontName.Title_Font
        coins_label.fontSize = Constants.FontSize.Title
        coins_label.fontColor = UIColor.blackColor()
        self.addChild(coins_label)
    }
    private func setupGestures() {
        let swipe_right = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipe_right.direction = UISwipeGestureRecognizerDirection.Right
        self.view?.addGestureRecognizer(swipe_right)
        
        let swipe_left = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipe_left.direction = UISwipeGestureRecognizerDirection.Left
        self.view?.addGestureRecognizer(swipe_left)
    }
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
}