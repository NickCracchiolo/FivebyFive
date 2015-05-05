//
//  GameScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 3/24/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import SpriteKit
import GameKit

//Integers
var total_tiles = Int()
var counter = 0
var Game_Level = 1
var current_coins = 0
var tut_Point = 0

//View Controller Variable
var gameVC = GameViewController()

//NODES
var hudNode = SKNode()
let tutNode = SKNode()
let titleNode = SKNode()
let gameOverNode = SKNode()
let labelNode = SKNode()

//Lists
var numbers_list = [Int]()
var boolList = [Bool]()
var topTiles = [SKSpriteNode]()
var backTiles = [SKSpriteNode]()

//UIImage
let oneText_UI = UIImage(named: "GreenOne.png")!
let twoText_UI = UIImage(named: "GreenTwo.png")!
let threeText_UI = UIImage(named: "GreenThree.png")!
let fourText_UI = UIImage(named: "GreenFour.png")!
let fiveText_UI = UIImage(named: "GreenFive.png")!
let bombText_UI = UIImage(named: "bomb.png")!
let yellow_UI = UIImage(named: "YellowSquare.png")!
let bomb_anim_UI = UIImage(named: "BombSquare.png")!

//Texture
let YellowSquare:SKTexture = SKTexture(image: yellow_UI)
let bombText:SKTexture = SKTexture(image: bombText_UI)
let bomb_anim_text:SKTexture = SKTexture(image:bomb_anim_UI)
let oneText:SKTexture = SKTexture(image: oneText_UI)
let twoText:SKTexture = SKTexture(image: twoText_UI)
let threeText:SKTexture = SKTexture(image: threeText_UI)
let fourText:SKTexture = SKTexture(image: fourText_UI)
let fiveText:SKTexture = SKTexture(image: fiveText_UI)


class GameScene: SKScene, GKGameCenterControllerDelegate {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = backColor
        print(tutorial)
        print("\n")
        getData()
        print(tutorial)
        print("\n")
        startScreen()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch:AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            if let node = self.nodeAtPoint(location).name {
            
                if touch_enabled == true {
                    for var i = 0; i < 24; i++ {
                        let name = "Tile" + String(i)
                        if node == name {
                            textChange(i)
                            checkForBomb(&boolList[i],num: numbers_list[i],node: backTiles[i])
                        }
                    }
                    for var i = 0; i < 5; i++ {
                        let nameVal = i+1
                        let name = "Col" + String(nameVal) + "Unlock"
                        if node == name {
                            if money >= 25 {
                                money -= 25
                                textChange(i)
                                textChange(i+5)
                                textChange(i+10)
                                textChange(i+15)
                                textChange(i+20)
                                let num_list = [numbers_list[i],numbers_list[i+5],numbers_list[i+10],numbers_list[i+15],numbers_list[i+20]]
                                var bool_list = [boolList[i+0],boolList[i+5],boolList[i+10],boolList[i+15],boolList[i+20]]
                                checkPurchase(num_list, bools:&bool_list)
                                hudNode.removeFromParent()
                                hudNode = HUD()
                                self.addChild(hudNode)
                            }
                        }
                    }
                    for var i = 0; i < 5; i++ {
                        let nameVal = i+1
                        let name = "Row" + String(nameVal) + "Unlock"
                        if node == name {
                            if money >= 25 {
                                money -= 25
                                let inc = i*5
                                textChange(inc)
                                textChange(inc+1)
                                textChange(inc+2)
                                textChange(inc+3)
                                textChange(inc+4)
                                let num_list = [numbers_list[inc],numbers_list[inc+1],numbers_list[inc+2],numbers_list[inc+3],numbers_list[inc+4]]
                                var bool_list = [boolList[inc],boolList[inc+1],boolList[inc+2],boolList[inc+3],boolList[inc+4]]
                                checkPurchase(num_list, bools:&bool_list)
                                hudNode.removeFromParent()
                                hudNode = HUD()
                                self.addChild(hudNode)
                            }
                        }
                    }
                    if node == "Next Button" {
                        tutNode.removeAllChildren()
                        tutNode.removeFromParent()
                        tut_Point++
                        tutorialSetup()
                    }
                    if node == "nextButton" {
                        nextLevel()
                    }

                    if node == "Play Button" {
                        titleNode.removeFromParent()
                        Flurry.logEvent("User Playing", withParameters:nil, timed: true)
                        if tutorial == 0 {
                            setup()
                            tutorialSetup()
                            saveData()
                        } else {
                            setup()
                        }
                    }
                    if node == "Leader Button" {
                        showLeader()
                    }
                    if node == "Buy Button" {
                        for product in list {
                            var prodID = product.productIdentifier
                            if(prodID == "fbf.iap.add_money") {
                                p = product
                                gameVC.buyProduct()
                                break;
                            }
                        }
                    }
                }
                else {
                    if node == "New Game Button" {
                        touch_enabled = true
                        gameVC.reportScore("leaderboard.highest_level")
                        newGame()
                    }
                }
            }
        }
    }
    func showLeader() {
        var vc = self.view?.window?.rootViewController
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        gc.viewState = GKGameCenterViewControllerState.Leaderboards
        
        gc.leaderboardIdentifier = "leaderboard.highest_level"
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    func flipAnim(node:SKSpriteNode) {
        let xPos = self.frame.size.width/2.5 + node.position.x
        let yPos = self.frame.size.height/2.5 + node.position.y
        let anim_node = SKSpriteNode(texture: YellowSquare)
        anim_node.position = CGPointMake(xPos, yPos)
        anim_node.zPosition = 3
        self.addChild(anim_node)
        
        let flyAction = SKAction.moveToY(self.frame.size.height, duration: 0.5)
        let delete = SKAction.removeFromParent()
        let deleteAction = SKAction.runBlock({
            anim_node.removeAllActions()
            anim_node.removeFromParent()
            print("anim deleted")
            print("\n")
        })
        let seq = SKAction.sequence([flyAction,deleteAction])
        anim_node.runAction(seq)
        print("action ran")
        print("\n")
    }
    
    func bombAnim(node:SKSpriteNode) {
        let xPos = self.frame.size.width/2.5 + node.position.x
        let yPos = self.frame.size.height/2.5 + node.position.y
        let bombNode = SKNode()
        
        let node1 = SKSpriteNode(texture: bomb_anim_text)
        node1.position = CGPointMake(xPos, yPos)
        node1.zPosition = 3
        self.addChild(node1)
        
        let node2 = SKSpriteNode(texture: bomb_anim_text)
        node2.position = CGPointMake((xPos + 10), (yPos))
        node2.zPosition = 3
        self.addChild(node2)
        
        let node3 = SKSpriteNode(texture: bomb_anim_text)
        node3.position = CGPointMake((xPos + 20), (yPos))
        node3.zPosition = 3
        self.addChild(node3)
        
        let node4 = SKSpriteNode(texture: bomb_anim_text)
        node4.position = CGPointMake((xPos + 30), (yPos))
        node4.zPosition = 3
        self.addChild(node4)
        
        let node5 = SKSpriteNode(texture: bomb_anim_text)
        node5.position = CGPointMake((xPos + 40), (yPos))
        node5.zPosition = 3
        self.addChild(node5)
        
        let node6 = SKSpriteNode(texture: bomb_anim_text)
        node6.position = CGPointMake((xPos + 10), (yPos + 10))
        node6.zPosition = 3
        self.addChild(node6)
        
        let node7 = SKSpriteNode(texture: bomb_anim_text)
        node7.position = CGPointMake((xPos + 20), (yPos + 10))
        node7.zPosition = 3
        self.addChild(node7)
        
        let node8 = SKSpriteNode(texture: bomb_anim_text)
        node8.position = CGPointMake((xPos + 30), (yPos + 10))
        node8.zPosition = 3
        self.addChild(node8)
        
        let node9 = SKSpriteNode(texture: bomb_anim_text)
        node9.position = CGPointMake((xPos + 40), (yPos + 10))
        node9.zPosition = 3
        self.addChild(node9)
        
        let node10 = SKSpriteNode(texture: bomb_anim_text)
        node10.position = CGPointMake((xPos + 10), (yPos + 10))
        node10.zPosition = 3
        self.addChild(node10)
        
        let node11 = SKSpriteNode(texture: bomb_anim_text)
        node11.position = CGPointMake((xPos + 20), (yPos + 20))
        node11.zPosition = 3
        self.addChild(node11)
        
        let node12 = SKSpriteNode(texture: bomb_anim_text)
        node12.position = CGPointMake((xPos + 30), (yPos + 20))
        node12.zPosition = 3
        self.addChild(node12)
        
        let node13 = SKSpriteNode(texture: bomb_anim_text)
        node13.position = CGPointMake((xPos + 40), (yPos + 20))
        node13.zPosition = 3
        self.addChild(node13)
        
        let node14 = SKSpriteNode(texture: bomb_anim_text)
        node14.position = CGPointMake((xPos + 10), (yPos + 20))
        node14.zPosition = 3
        self.addChild(node14)
        
        let node15 = SKSpriteNode(texture: bomb_anim_text)
        node15.position = CGPointMake((xPos + 20), (yPos + 20))
        node15.zPosition = 3
        self.addChild(node15)
        
        let node16 = SKSpriteNode(texture: bomb_anim_text)
        node16.position = CGPointMake((xPos + 30), (yPos + 30))
        node16.zPosition = 3
        self.addChild(node16)
        
        let node17 = SKSpriteNode(texture: bomb_anim_text)
        node17.position = CGPointMake((xPos + 40), (yPos + 30))
        node17.zPosition = 3
        self.addChild(node17)
        
        let node18 = SKSpriteNode(texture: bomb_anim_text)
        node18.position = CGPointMake((xPos + 10), (yPos + 30))
        node18.zPosition = 3
        self.addChild(node18)
        
        let node19 = SKSpriteNode(texture: bomb_anim_text)
        node19.position = CGPointMake((xPos + 20), (yPos + 10*3))
        node19.zPosition = 3
        self.addChild(node19)
        
        let node20 = SKSpriteNode(texture: bomb_anim_text)
        node20.position = CGPointMake((xPos + 30), (yPos + 30))
        node20.zPosition = 3
        self.addChild(node20)
        
        let node21 = SKSpriteNode(texture: bomb_anim_text)
        node21.position = CGPointMake((xPos + 40), (yPos + 40))
        node21.zPosition = 3
        self.addChild(node21)
        
        let node22 = SKSpriteNode(texture: bomb_anim_text)
        node22.position = CGPointMake((xPos + 10), (yPos + 40))
        node22.zPosition = 3
        self.addChild(node22)
        
        let node23 = SKSpriteNode(texture: bomb_anim_text)
        node23.position = CGPointMake((xPos + 20), (yPos + 40))
        node23.zPosition = 3
        self.addChild(node23)
        
        let node24 = SKSpriteNode(texture: bomb_anim_text)
        node24.position = CGPointMake((xPos + 30), (yPos + 40))
        node24.zPosition = 3
        self.addChild(node24)
        
        let node25 = SKSpriteNode(texture: bomb_anim_text)
        node25.position = CGPointMake((xPos + 40), (yPos + 40))
        node25.zPosition = 3
        self.addChild(node25)
        
        let flyAction1 = SKAction.moveTo(CGPointMake(0, self.frame.size.height), duration: 1.0)
        let flyAction2 = SKAction.moveTo(CGPointMake(self.frame.size.width*0.25,self.frame.size.height), duration: 1.0)
        let flyAction3 = SKAction.moveToY(self.frame.size.height, duration: 1.0)
        let flyAction4 = SKAction.moveTo(CGPointMake(self.frame.size.width*0.75,self.frame.size.height), duration: 1.0)
        let flyAction5 = SKAction.moveTo(CGPointMake(self.frame.size.width, self.frame.size.height), duration: 1.0)
        let flyAction6 = SKAction.moveToX(0, duration: 1.0)
        let flyAction7 = SKAction.moveTo(CGPointMake(0, self.frame.size.height), duration: 2.0)
        let flyAction8 = SKAction.moveToY(self.frame.size.height, duration: 2.0)
        let flyAction9 = SKAction.moveTo(CGPointMake(self.frame.size.width, self.frame.size.height), duration: 2.0)
        let flyAction10 = SKAction.moveToX(self.frame.size.width, duration: 1.0)
        let flyAction11 = SKAction.moveToX(0, duration: 1.0)
        let flyAction12 = SKAction.moveToX(0, duration: 2.0)
        let flyAction13 = SKAction.moveToY(self.frame.size.height, duration: 3.0)
        let flyAction14 = SKAction.moveToX(self.frame.size.width, duration: 2.0)
        let flyAction15 = SKAction.moveToX(self.frame.size.width, duration: 1.0)
        let flyAction16 = SKAction.moveToX(0, duration: 1.0)
        let flyAction17 = SKAction.moveTo(CGPointMake(0, 0), duration: 2.0)
        let flyAction18 = SKAction.moveToY(0, duration: 2.0)
        let flyAction19 = SKAction.moveTo(CGPointMake(self.frame.size.width, 0), duration: 2.0)
        let flyAction20 = SKAction.moveToX(self.frame.size.width, duration: 1.0)
        let flyAction21 = SKAction.moveTo(CGPointMake(0, 0), duration: 1.0)
        let flyAction22 = SKAction.moveTo(CGPointMake(self.frame.size.width*0.25,0), duration: 1.0)
        let flyAction23 = SKAction.moveToY(0, duration: 1.0)
        let flyAction24 = SKAction.moveTo(CGPointMake(self.frame.size.width*0.75,0), duration: 1.0)
        let flyAction25 = SKAction.moveTo(CGPointMake(self.frame.size.width, 0), duration: 1.0)
        
        let deleteAction = SKAction.removeFromParent()
        let waitAction = SKAction.waitForDuration(0.75)
        
        let node1Action = (SKAction.sequence([flyAction1,deleteAction]))
        let node2Action = (SKAction.sequence([flyAction2,deleteAction]))
        let node3Action = (SKAction.sequence([flyAction3,deleteAction]))
        let node4Action = (SKAction.sequence([flyAction4,deleteAction]))
        let node5Action = (SKAction.sequence([flyAction5,deleteAction]))
        let node6Action = (SKAction.sequence([flyAction6,deleteAction]))
        let node7Action = (SKAction.sequence([flyAction7,deleteAction]))
        let node8Action = (SKAction.sequence([flyAction8,deleteAction]))
        let node9Action = (SKAction.sequence([flyAction9,deleteAction]))
        let node10Action = (SKAction.sequence([flyAction10,deleteAction]))
        let node11Action = (SKAction.sequence([flyAction11,deleteAction]))
        let node12Action = (SKAction.sequence([flyAction12,deleteAction]))
        let node13Action = (SKAction.sequence([flyAction13,deleteAction]))
        let node14Action = (SKAction.sequence([flyAction14,deleteAction]))
        let node15Action = (SKAction.sequence([flyAction15,deleteAction]))
        let node16Action = (SKAction.sequence([flyAction16,deleteAction]))
        let node17Action = (SKAction.sequence([flyAction17,deleteAction]))
        let node18Action = (SKAction.sequence([flyAction18,deleteAction]))
        let node19Action = (SKAction.sequence([flyAction19,deleteAction]))
        let node20Action = (SKAction.sequence([flyAction20,deleteAction]))
        let node21Action = (SKAction.sequence([flyAction21,deleteAction]))
        let node22Action = (SKAction.sequence([flyAction22,deleteAction]))
        let node23Action = (SKAction.sequence([flyAction23,deleteAction]))
        let node24Action = (SKAction.sequence([flyAction24,deleteAction]))
        let node25Action = (SKAction.sequence([flyAction25,deleteAction]))
        
        node1.runAction(node1Action)
        node2.runAction(node2Action)
        node3.runAction(node3Action)
        node4.runAction(node4Action)
        node5.runAction(node5Action)
        node6.runAction(node6Action)
        node7.runAction(node7Action)
        node8.runAction(node8Action)
        node9.runAction(node9Action)
        node10.runAction(node10Action)
        node11.runAction(node11Action)
        node12.runAction(node12Action)
        node13.runAction(node13Action)
        node14.runAction(node14Action)
        node15.runAction(node15Action)
        node16.runAction(node16Action)
        node17.runAction(node17Action)
        node18.runAction(node18Action)
        node19.runAction(node19Action)
        node20.runAction(node20Action)
        node21.runAction(node21Action)
        node22.runAction(node22Action)
        node23.runAction(node23Action)
        node24.runAction(node24Action)
        node25.runAction(node25Action)
    }
    
    func textChange(num:Int) {
        topTiles[num].hidden = true
        backTiles[num].hidden = false
    }
    
    func startScreen() {
        self.removeAllChildren()
        
        let playButton = SKSpriteNode(imageNamed: "PlayButton.png")
        playButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/1.85)
        playButton.zPosition = 30
        playButton.xScale = 0.5
        playButton.yScale = 0.5
        playButton.name = "Play Button"
        titleNode.addChild(playButton)
        
        let leaderButton = SKSpriteNode(imageNamed: "LeaderButton.png")
        leaderButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2.8)
        leaderButton.zPosition = 30
        leaderButton.xScale = 0.6
        leaderButton.yScale = 0.6
        leaderButton.name = "Leader Button"
        titleNode.addChild(leaderButton)
        
        let title1 = SKLabelNode(text: "Five")
        title1.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.86)
        title1.fontName = Title_Font
        title1.fontSize = 80
        title1.fontColor = titleClr
        title1.zPosition = 30
        titleNode.addChild(title1)
        
        let title2 = SKLabelNode(text: "by")
        title2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.78)
        title2.fontName = Title_Font
        title2.fontSize = 80
        title2.fontColor = titleClr
        title2.zPosition = 30
        titleNode.addChild(title2)
        
        let title3 = SKLabelNode(text: "Five")
        title3.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.7)
        title3.fontName = Title_Font
        title3.fontSize = 80
        title3.fontColor = titleClr
        title3.zPosition = 30
        titleNode.addChild(title3)
        
        let purchaseBtn = SKSpriteNode(imageNamed: "PurchaseButton.png")
        purchaseBtn.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/5)
        purchaseBtn.zPosition = 30
        purchaseBtn.name = "Buy Button"
        titleNode.addChild(purchaseBtn)
        
        let purchaseLabel = SKLabelNode(text: "Touch to add 100")
        purchaseLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/7.3)
        purchaseLabel.fontName = Title_Font
        purchaseLabel.fontSize = 25
        purchaseLabel.fontColor = blackColor
        purchaseLabel.zPosition = 30
        titleNode.addChild(purchaseLabel)
        
        let purchaseLabel2 = SKLabelNode(text: "coins for $0.99")
        purchaseLabel2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/8.5)
        purchaseLabel2.fontName = Title_Font
        purchaseLabel2.fontSize = 25
        purchaseLabel2.fontColor = blackColor
        purchaseLabel2.zPosition = 30
        titleNode.addChild(purchaseLabel2)
        
        self.addChild(titleNode)
    }
    func tutorialSetup() {
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        let tut1 = SKAction.runBlock({
            let arrow = SKSpriteNode(imageNamed: "tutArrow.png")
            arrow.position = CGPointMake(width*0.34, height*0.26)
            arrow.zPosition = tutorial_zPosition
            arrow.xScale = 0.75
            arrow.yScale = 0.75
            tutNode.addChild(arrow)
            
            let desc1 = SKLabelNode(text: "Shows the sum of the")
            desc1.fontName = Game_Font
            desc1.fontColor = blackColor
            desc1.fontSize = 20
            desc1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            desc1.position = CGPointMake(width*0.4, height*0.26)
            desc1.zPosition = tutorial_zPosition
            tutNode.addChild(desc1)
            
            let desc2 = SKLabelNode(text: "number behind each square")
            desc2.fontName = Game_Font
            desc2.fontColor = blackColor
            desc2.fontSize = 20
            desc2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            desc2.position = CGPointMake(width*0.4, height*0.24)
            desc2.zPosition = tutorial_zPosition
            tutNode.addChild(desc2)
            
            let desc3 = SKLabelNode(text: "in the row or column")
            desc3.fontName = Game_Font
            desc3.fontColor = blackColor
            desc3.fontSize = 20
            desc3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            desc3.position = CGPointMake(width*0.4, height*0.22)
            desc3.zPosition = tutorial_zPosition
            tutNode.addChild(desc3)
            
            let nextButton = SKLabelNode(text: "Next")
            nextButton.position = CGPointMake(width*0.6, height*0.13)
            nextButton.fontName = Game_Over_Font
            nextButton.fontSize = 40
            nextButton.fontColor = blackColor
            nextButton.zPosition = tutorial_zPosition
            nextButton.name = "Next Button"
            tutNode.addChild(nextButton)
            
            self.addChild(tutNode)
        })
        
        let tut2 = SKAction.runBlock({
            let arrow = SKSpriteNode(imageNamed: "tutArrow.png")
            arrow.position = CGPointMake(width*0.365, height*0.26)
            arrow.zPosition = tutorial_zPosition
            arrow.xScale = 0.75
            arrow.yScale = 0.75
            tutNode.addChild(arrow)
            
            let desc1 = SKLabelNode(text: "Shows the sum of")
            desc1.fontName = Game_Font
            desc1.fontColor = blackColor
            desc1.fontSize = 20
            desc1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            desc1.position = CGPointMake(width*0.4, height*0.26)
            desc1.zPosition = tutorial_zPosition
            tutNode.addChild(desc1)
            
            let desc2 = SKLabelNode(text: "all the bombs in")
            desc2.fontName = Game_Font
            desc2.fontColor = blackColor
            desc2.fontSize = 20
            desc2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            desc2.position = CGPointMake(width*0.4, height*0.24)
            desc2.zPosition = tutorial_zPosition
            tutNode.addChild(desc2)
            
            let desc3 = SKLabelNode(text: "the row or column")
            desc3.fontName = Game_Font
            desc3.fontColor = blackColor
            desc3.fontSize = 20
            desc3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            desc3.position = CGPointMake(width*0.4, height*0.22)
            desc3.zPosition = tutorial_zPosition
            tutNode.addChild(desc3)
            
            let nextButton = SKLabelNode(text: "Next")
            nextButton.position = CGPointMake(width*0.6, height*0.13)
            nextButton.fontName = Game_Over_Font
            nextButton.fontSize = 40
            nextButton.fontColor = blackColor
            nextButton.zPosition = tutorial_zPosition
            nextButton.name = "Next Button"
            tutNode.addChild(nextButton)
            
            self.addChild(tutNode)
        })
        
        let tut3 = SKAction.runBlock({
            let arrow = SKSpriteNode(imageNamed: "tutArrow.png")
            arrow.position = CGPointMake(width*0.4, height*0.2)
            arrow.zPosition = tutorial_zPosition
            arrow.xScale = 0.75
            arrow.yScale = 0.75
            tutNode.addChild(arrow)
            
            let desc1 = SKLabelNode(text: "For 25 coins you can")
            desc1.fontName = Game_Font
            desc1.fontColor = blackColor
            desc1.fontSize = 20
            desc1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            desc1.position = CGPointMake(width*0.42, height*0.26)
            desc1.zPosition = tutorial_zPosition
            tutNode.addChild(desc1)
            
            let desc2 = SKLabelNode(text: "reveal all the tiles")
            desc2.fontName = Game_Font
            desc2.fontColor = blackColor
            desc2.fontSize = 20
            desc2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            desc2.position = CGPointMake(width*0.42, height*0.24)
            desc2.zPosition = tutorial_zPosition
            tutNode.addChild(desc2)
            
            let desc3 = SKLabelNode(text: "in the specified row")
            desc3.fontName = Game_Font
            desc3.fontColor = blackColor
            desc3.fontSize = 20
            desc3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            desc3.position = CGPointMake(width*0.42, height*0.22)
            desc3.zPosition = tutorial_zPosition
            tutNode.addChild(desc3)
            
            let desc4 = SKLabelNode(text: "or column")
            desc4.fontName = Game_Font
            desc4.fontColor = blackColor
            desc4.fontSize = 20
            desc4.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            desc4.position = CGPointMake(width*0.42, height*0.20)
            desc4.zPosition = tutorial_zPosition
            tutNode.addChild(desc4)
            
            let nextButton = SKLabelNode(text: "Next")
            nextButton.position = CGPointMake(width*0.6, height*0.13)
            nextButton.fontName = Game_Over_Font
            nextButton.fontSize = 40
            desc1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            nextButton.fontColor = blackColor
            nextButton.zPosition = tutorial_zPosition
            nextButton.name = "Next Button"
            tutNode.addChild(nextButton)
            
            self.addChild(tutNode)
        })
        
        if tut_Point == 0 {
            self.runAction(tut1)
        } else if tut_Point == 1 {
            self.runAction(tut2)
        } else if tut_Point == 2 {
            self.runAction(tut3)
            tutorial = 1
            money+=50
            saveData()
            hudNode.removeFromParent()
            hudNode = HUD()
            self.addChild(hudNode)
        }
    }
    func GameOverScreen() {
        let GameOverLabel = SKLabelNode(text: "Game Over")
        GameOverLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.75)
        GameOverLabel.zPosition = 50
        GameOverLabel.fontName = Game_Over_Font
        GameOverLabel.fontColor = fontClr
        GameOverLabel.fontSize = 60
        gameOverNode.addChild(GameOverLabel)
        
        let newGameButton = SKLabelNode(text: "Play Again?")
        newGameButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height*0.2)
        newGameButton.zPosition = 50
        newGameButton.fontSize = 55
        newGameButton.fontName = Game_Over_Font
        newGameButton.fontColor = fontClr
        newGameButton.name = "New Game Button"
        gameOverNode.addChild(newGameButton)
        
        self.addChild(gameOverNode)
    }
    
    func HUD() -> SKNode {
        let hudNode = SKNode()
        
        let level_lbl = SKLabelNode(text: "Level")
        level_lbl.position = CGPointMake(self.frame.size.width*0.4, self.frame.size.height*0.925)
        level_lbl.fontColor = fontClr
        level_lbl.fontSize = 35
        level_lbl.fontName = HUD_Font
        level_lbl.zPosition = 3
        hudNode.addChild(level_lbl)
        
        let current_level_lbl = SKLabelNode(text: "Current:")
        current_level_lbl.position = CGPointMake(self.frame.size.width*0.4, self.frame.size.height*0.88)
        current_level_lbl.fontColor = fontClr
        current_level_lbl.fontSize = 25
        current_level_lbl.fontName = HUD_Font
        current_level_lbl.zPosition = 3
        hudNode.addChild(current_level_lbl)
        
        let current_level_num = SKLabelNode(text: String(Game_Level))
        current_level_num.position = CGPointMake(self.frame.size.width*0.47, self.frame.size.height*0.88)
        current_level_num.fontColor = fontClr
        current_level_num.fontSize = 25
        current_level_num.fontName = HUD_Font
        current_level_num.zPosition = 3
        hudNode.addChild(current_level_num)
        
        let high_level_lbl = SKLabelNode(text: "Best:")
        high_level_lbl.position = CGPointMake(self.frame.size.width*0.38, self.frame.size.height*0.845)
        high_level_lbl.fontColor = fontClr
        high_level_lbl.fontSize = 25
        high_level_lbl.fontName = HUD_Font
        high_level_lbl.zPosition = 3
        hudNode.addChild(high_level_lbl)
        
        let highest_level_num = SKLabelNode(text: String(highestLevel))
        highest_level_num.position = CGPointMake(self.frame.size.width*0.47, self.frame.size.height*0.845)
        highest_level_num.fontColor = fontClr
        highest_level_num.fontSize = 25
        highest_level_num.fontName = HUD_Font
        highest_level_num.zPosition = 3
        hudNode.addChild(highest_level_num)
        
        let money_lbl = SKLabelNode(text: "Money")
        money_lbl.position = CGPointMake(self.frame.size.width*0.58, self.frame.size.height*0.925)
        money_lbl.fontColor = fontClr
        money_lbl.fontSize = 35
        money_lbl.fontName = HUD_Font
        money_lbl.zPosition = 3
        hudNode.addChild(money_lbl)
        
        let current_money_lbl = SKLabelNode(text: "Current:")
        current_money_lbl.position = CGPointMake(self.frame.size.width*0.59, self.frame.size.height*0.88)
        current_money_lbl.fontColor = fontClr
        current_money_lbl.fontSize = 25
        current_money_lbl.fontName = HUD_Font
        current_money_lbl.zPosition = 3
        hudNode.addChild(current_money_lbl)
        
        let current_money_num = SKLabelNode(text: String(current_coins))
        current_money_num.position = CGPointMake(self.frame.size.width*0.67, self.frame.size.height*0.88)
        current_money_num.fontColor = fontClr
        current_money_num.fontSize = 25
        current_money_num.fontName = HUD_Font
        current_money_num.zPosition = 3
        hudNode.addChild(current_money_num)
        
        let high_money_lbl = SKLabelNode(text: "Total:")
        high_money_lbl.position = CGPointMake(self.frame.size.width*0.58, self.frame.size.height*0.845)
        high_money_lbl.fontColor = fontClr
        high_money_lbl.fontSize = 25
        high_money_lbl.fontName = HUD_Font
        high_money_lbl.zPosition = 3
        hudNode.addChild(high_money_lbl)
        
        let highest_money_num = SKLabelNode(text: String(money))
        highest_money_num.position = CGPointMake(self.frame.size.width*0.67, self.frame.size.height*0.845)
        highest_money_num.fontColor = fontClr
        highest_money_num.fontSize = 25
        highest_money_num.fontName = HUD_Font
        highest_money_num.zPosition = 3
        hudNode.addChild(highest_money_num)
        
        return hudNode
    }

    func createGrid() -> SKNode {
        let gridNode = SKNode()
        var row_tot = 0
        var counter:Int = 0
        var bombs = 0
        for var y = 0; y < 5; y++ {
            for var x = 0; x < 5; x++ {
                let name = ("Tile"+String(counter))
                let square = createSquare(x, y: y,in_name:name)
                
                var back_text: SKTexture?
                var rand = Int(arc4random_uniform(101))
                var number:Int = 0
                
                let zero_val = 10 + 2*Game_Level
                let diff = (100 - zero_val)/5
                let one_val = zero_val + diff
                let two_val = zero_val + diff*2
                let three_val = zero_val + diff*3
                let four_val = zero_val + diff*4
                let five_val = zero_val + diff*5
                
                if rand < zero_val {
                    back_text = bombText
                    number = 0
                } else if rand >= zero_val && rand < one_val {
                    back_text = oneText
                    number = 1
                } else if rand >= one_val && rand < two_val {
                    back_text = twoText
                    number = 2
                } else if rand >= two_val && rand < three_val {
                    back_text = threeText
                    number = 3
                } else if rand >= three_val && rand < four_val {
                    back_text = fourText
                    number = 4
                } else if rand >= four_val && rand < five_val {
                    back_text = fiveText
                    number = 5
                } else if back_text == nil {
                    back_text = bombText
                    number = 0
                }
                
                    
                let back_name = ("Back_Tile"+String(counter))
                let back_square = SKSpriteNode(texture: back_text)
                back_square.position = square.position
                back_square.zPosition = grid_zPosition
                back_square.hidden = true
                back_square.name = back_name
                    
                topTiles.append(square)
                backTiles.append(back_square)
                numbers_list.append(number)
                boolList.append(false)
                
                gridNode.addChild(square)
                gridNode.addChild(back_square)
                
                counter++
            }
        }
        return gridNode
    }
    
    func calculateTotTiles(input_list: [Int]) -> Int {
        var count:Int = 0
        for num in input_list {
            if num != 0 {
                count++
            }
        }
        return count
    }
    
    func createSquare(x:Int,y:Int,in_name:String) -> SKSpriteNode{
        let square_width:Int = 55
        let square_height:Int = 55
        let square = SKSpriteNode(imageNamed: "YellowSquare.png")
        let xPos = CGFloat(square_width*x)
        let yPos = CGFloat(square_height*(4-y))
        square.position = CGPointMake(xPos, yPos)
        square.name = in_name
        square.zPosition = 3
        return square
    }
    
    func getRowBombs(input_list: [Int]) -> [Int] {
        var bomb_list = [Int]()
        var bombs = 0
        for var i:Int = 0; i < 5; i++ {
            if input_list[i] == 0 {
                bombs++
            }
        }
        bomb_list.append(bombs)
        bombs = 0
        for var i:Int = 5; i < 10; i++ {
            if input_list[i] == 0 {
                bombs++
            }
        }
        bomb_list.append(bombs)
        bombs = 0
        for var i:Int = 10; i < 15; i++ {
            if input_list[i] == 0 {
                bombs++
            }
        }
        bomb_list.append(bombs)
        bombs = 0
        for var i:Int = 15; i < 20; i++ {
            if input_list[i] == 0 {
                bombs++
            }
        }
        bomb_list.append(bombs)
        bombs = 0
        for var i:Int = 20; i < 25; i++ {
            if input_list[i] == 0 {
                bombs++
            }
        }
        bomb_list.append(bombs)
        bombs = 0
        return bomb_list
    }
    
    func getColBombs(input_list: [Int]) -> [Int] {
        var bomb_list = [Int]()
        var bombs = 0
        for var i:Int = 0; i < 25; i += 5 {
            if input_list[i] == 0 {
                bombs++
            }
        }
        bomb_list.append(bombs)
        bombs = 0
        for var i:Int = 1; i < 25; i += 5 {
            if input_list[i] == 0 {
                bombs++
            }
        }
        bomb_list.append(bombs)
        bombs = 0
        for var i:Int = 2; i < 25; i += 5 {
            if input_list[i] == 0 {
                bombs++
            }
        }
        bomb_list.append(bombs)
        bombs = 0
        for var i:Int = 3; i < 25; i += 5 {
            if input_list[i] == 0 {
                bombs++
            }
        }
        bomb_list.append(bombs)
        bombs = 0
        for var i:Int = 4; i < 25; i += 5 {
            if input_list[i] == 0 {
                bombs++
            }
        }
        bomb_list.append(bombs)
        bombs = 0
        
        return bomb_list
    }
    
    func getColumns(input_list: [Int]) -> [Int] {
        let c1:Int = Int(input_list[0]) + Int(input_list[5]) + Int(input_list[10]) + Int(input_list[15]) + Int(input_list[20])
        let c2:Int = Int(input_list[1]) + Int(input_list[6]) + Int(input_list[11]) + Int(input_list[16]) + Int(input_list[21])
        let c3:Int = Int(input_list[2]) + Int(input_list[7]) + Int(input_list[12]) + Int(input_list[17]) + Int(input_list[22])
        let c4:Int = Int(input_list[3]) + Int(input_list[8]) + Int(input_list[13]) + Int(input_list[18]) + Int(input_list[23])
        let c5:Int = Int(input_list[4]) + Int(input_list[9]) + Int(input_list[14]) + Int(input_list[19]) + Int(input_list[24])
        let column_list:[Int] = [c1,c2,c3,c4,c5]
        return column_list
    }
    
    func getRows(input_list: [Int]) -> [Int] {
        let r1:Int = Int(input_list[0]) + Int(input_list[1]) + Int(input_list[2]) + Int(input_list[3]) + Int(input_list[4])
        let r2:Int = Int(input_list[5]) + Int(input_list[6]) + Int(input_list[7]) + Int(input_list[8]) + Int(input_list[9])
        let r3:Int = Int(input_list[10]) + Int(input_list[11]) + Int(input_list[12]) + Int(input_list[13]) + Int(input_list[14])
        let r4:Int = Int(input_list[15]) + Int(input_list[16]) + Int(input_list[17]) + Int(input_list[18]) + Int(input_list[19])
        let r5:Int = Int(input_list[20]) + Int(input_list[21]) + Int(input_list[22]) + Int(input_list[23]) + Int(input_list[24])
        let row_list:[Int] = [r1,r2,r3,r4,r5]
        return row_list
    }
    
    func displayNumbers(row_list: [Int],column_list: [Int]) -> SKNode {
        let colY:CGFloat = 0.76
        let colX:CGFloat = 0.40
        let rowY:CGFloat = 0.38
        let rowX:CGFloat = 0.34
        let node = SKNode()
        
        let col1 = SKLabelNode(text: String(column_list[0]))
        col1.position = CGPointMake(self.frame.size.width*colX, self.frame.size.height*colY)
        col1.fontSize = DispFontSize
        col1.fontName = Game_Font
        col1.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        col1.zPosition = 5
        node.addChild(col1)
        
        let col2 = SKLabelNode(text: String(column_list[1]))
        col2.position = CGPointMake(self.frame.size.width*(colX + 0.055), self.frame.size.height*colY)
        col2.fontSize = DispFontSize
        col2.fontName = Game_Font
        col2.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        col2.zPosition = 5
        node.addChild(col2)
        
        let col3 = SKLabelNode(text: String(column_list[2]))
        col3.position = CGPointMake(self.frame.size.width*(colX + 0.105), self.frame.size.height*colY)
        col3.fontSize = DispFontSize
        col3.fontName = Game_Font
        col3.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        col3.zPosition = 5
        node.addChild(col3)
        
        let col4 = SKLabelNode(text: String(column_list[3]))
        col4.position = CGPointMake(self.frame.size.width*(colX + 0.16), self.frame.size.height*colY)
        col4.fontSize = DispFontSize
        col4.fontName = Game_Font
        col4.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        col4.zPosition = 5
        node.addChild(col4)
        
        let col5 = SKLabelNode(text: String(column_list[4]))
        col5.position = CGPointMake(self.frame.size.width*(colX + 0.215), self.frame.size.height*colY)
        col5.fontSize = DispFontSize
        col5.fontName = Game_Font
        col5.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        col5.zPosition = 5
        node.addChild(col5)
        
        let row1 = SKLabelNode(text: String(row_list[0]))
        row1.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY + 0.29))
        row1.fontSize = DispFontSize
        row1.fontName = Game_Font
        row1.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        row1.zPosition = 5
        node.addChild(row1)
        
        let row2 = SKLabelNode(text: String(row_list[1]))
        row2.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY + 0.215))
        row2.fontSize = DispFontSize
        row2.fontName = Game_Font
        row2.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        row2.zPosition = 5
        node.addChild(row2)
        
        let row3 = SKLabelNode(text: String(row_list[2]))
        row3.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY + 0.15))
        row3.fontSize = DispFontSize
        row3.fontName = Game_Font
        row3.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        row3.zPosition = 5
        node.addChild(row3)
        
        let row4 = SKLabelNode(text: String(row_list[3]))
        row4.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY + 0.075))
        row4.fontSize = DispFontSize
        row4.fontName = Game_Font
        row4.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        row4.zPosition = 5
        node.addChild(row4)
        
        let row5 = SKLabelNode(text: String(row_list[4]))
        row5.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*rowY)
        row5.fontSize = DispFontSize
        row5.fontName = Game_Font
        row5.fontColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        row5.zPosition = 5
        node.addChild(row5)
        
        return node
    }
    
    func displayBombs(row_list: [Int],column_list: [Int]) -> SKNode {
        let colY:CGFloat = 0.73
        let colX:CGFloat = 0.4
        let rowY:CGFloat = 0.38
        let rowX:CGFloat = 0.365
        let node = SKNode()
        
        let col1 = SKLabelNode(text: String(column_list[0]))
        col1.position = CGPointMake(self.frame.size.width*colX, self.frame.size.height*colY)
        col1.fontSize = DispFontSize
        col1.fontName = Game_Font
        col1.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        col1.zPosition = 5
        node.addChild(col1)
        
        let col2 = SKLabelNode(text: String(column_list[1]))
        col2.position = CGPointMake(self.frame.size.width*(colX+0.055), self.frame.size.height*colY)
        col2.fontSize = DispFontSize
        col2.fontName = Game_Font
        col2.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        col2.zPosition = 5
        node.addChild(col2)
        
        let col3 = SKLabelNode(text: String(column_list[2]))
        col3.position = CGPointMake(self.frame.size.width*(colX+0.105), self.frame.size.height*colY)
        col3.fontSize = DispFontSize
        col3.fontName = Game_Font
        col3.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        col3.zPosition = 5
        node.addChild(col3)
        
        let col4 = SKLabelNode(text: String(column_list[3]))
        col4.position = CGPointMake(self.frame.size.width*(colX+0.16), self.frame.size.height*colY)
        col4.fontSize = DispFontSize
        col4.fontName = Game_Font
        col4.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        col4.zPosition = 5
        node.addChild(col4)
        
        let col5 = SKLabelNode(text: String(column_list[4]))
        col5.position = CGPointMake(self.frame.size.width*(colX+0.215), self.frame.size.height*colY)
        col5.fontSize = DispFontSize
        col5.fontName = Game_Font
        col5.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        col5.zPosition = 5
        node.addChild(col5)
        
        let row1 = SKLabelNode(text: String(row_list[0]))
        row1.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY+0.29))
        row1.fontSize = DispFontSize
        row1.fontName = Game_Font
        row1.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        row1.zPosition = 5
        node.addChild(row1)
        
        let row2 = SKLabelNode(text: String(row_list[1]))
        row2.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY+0.215))
        row2.fontSize = DispFontSize
        row2.fontName = Game_Font
        row2.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        row2.zPosition = 5
        node.addChild(row2)
        
        let row3 = SKLabelNode(text: String(row_list[2]))
        row3.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY+0.15))
        row3.fontSize = DispFontSize
        row3.fontName = Game_Font
        row3.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        row3.zPosition = 5
        node.addChild(row3)
        
        let row4 = SKLabelNode(text: String(row_list[3]))
        row4.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY+0.075))
        row4.fontSize = DispFontSize
        row4.fontName = Game_Font
        row4.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        row4.zPosition = 5
        node.addChild(row4)
        
        let row5 = SKLabelNode(text: String(row_list[4]))
        row5.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*rowY)
        row5.fontSize = DispFontSize
        row5.fontName = Game_Font
        row5.fontColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
        row5.zPosition = 5
        node.addChild(row5)
        
        return node
    }
    
    func displayUnlocks(row_list: [Int],column_list: [Int]) -> SKNode {
        let colY:CGFloat = 0.335
        let colX:CGFloat = 0.4
        let rowY:CGFloat = 0.40
        let rowX:CGFloat = 0.67
        let node = SKNode()
        
        let col1 = SKSpriteNode(imageNamed: "PurchaseRow.png")
        col1.position = CGPointMake(self.frame.size.width*colX, self.frame.size.height*colY)
        col1.xScale = 0.5
        col1.yScale = 0.5
        col1.zPosition = 6
        col1.name = "Col1Unlock"
        node.addChild(col1)
        
        let col2 = SKSpriteNode(imageNamed: "PurchaseRow.png")
        col2.position = CGPointMake(self.frame.size.width*(colX+0.055), self.frame.size.height*colY)
        col2.xScale = 0.5
        col2.yScale = 0.5
        col2.zPosition = 6
        col2.name = "Col2Unlock"
        node.addChild(col2)
        
        let col3 = SKSpriteNode(imageNamed: "PurchaseRow.png")
        col3.position = CGPointMake(self.frame.size.width*(colX+0.1075), self.frame.size.height*colY)
        col3.xScale = 0.5
        col3.yScale = 0.5
        col3.zPosition = 6
        col3.name = "Col3Unlock"
        node.addChild(col3)
        
        let col4 = SKSpriteNode(imageNamed: "PurchaseRow.png")
        col4.position = CGPointMake(self.frame.size.width*(colX+0.16), self.frame.size.height*colY)
        col4.xScale = 0.5
        col4.yScale = 0.5
        col4.zPosition = 6
        col4.name = "Col4Unlock"
        node.addChild(col4)
        
        let col5 = SKSpriteNode(imageNamed: "PurchaseRow.png")
        col5.position = CGPointMake(self.frame.size.width*(colX+0.215), self.frame.size.height*colY)
        col5.xScale = 0.5
        col5.yScale = 0.5
        col5.zPosition = 6
        col5.name = "Col5Unlock"
        node.addChild(col5)
        
        let row1 = SKSpriteNode(imageNamed: "PurchaseRow.png")
        row1.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY+0.29))
        row1.xScale = 0.5
        row1.yScale = 0.5
        row1.zPosition = 20
        row1.name = "Row1Unlock"
        node.addChild(row1)
        
        let row2 = SKSpriteNode(imageNamed: "PurchaseRow.png")
        row2.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY+0.22))
        row2.xScale = 0.5
        row2.yScale = 0.5
        row2.zPosition = 20
        row2.name = "Row2Unlock"
        node.addChild(row2)
        
        let row3 = SKSpriteNode(imageNamed: "PurchaseRow.png")
        row3.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY+0.145))
        row3.xScale = 0.5
        row3.yScale = 0.5
        row3.zPosition = 20
        row3.name = "Row3Unlock"
        node.addChild(row3)
        
        let row4 = SKSpriteNode(imageNamed: "PurchaseRow.png")
        row4.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*(rowY+0.075))
        row4.xScale = 0.5
        row4.yScale = 0.5
        row4.zPosition = 20
        row4.name = "Row4Unlock"
        node.addChild(row4)
        
        let row5 = SKSpriteNode(imageNamed: "PurchaseRow.png")
        row5.position = CGPointMake(self.frame.size.width*rowX, self.frame.size.height*rowY)
        row5.xScale = 0.5
        row5.yScale = 0.5
        row5.zPosition = 20
        row5.name = "Row5Unlock"
        node.addChild(row5)
        
        return node
    }
    
    //Improve upon Algorithm to add increase difficuty for Levels
    func BackTexture(level:Int) -> (SKTexture,Int) {
        var back_text = SKTexture()
        var rand = Int(arc4random_uniform(101))
        var number:Int = 0
        
        let zero_val = 8 + level
        let diff = (100 - zero_val)/5
        let one_val = zero_val + diff
        let two_val = zero_val + diff*2
        let three_val = zero_val + diff*3
        let four_val = zero_val + diff*4
        let five_val = zero_val + diff*5
        
        if rand < zero_val {
            back_text = bombText
            number = 0
        } else if rand >= zero_val && rand < one_val {
            back_text = oneText
            number = 1
        } else if rand >= one_val && rand < two_val {
            back_text = twoText
            number = 2
        } else if rand >= two_val && rand < three_val {
            back_text = threeText
            number = 3
        } else if rand >= three_val && rand < four_val {
            back_text = fourText
            number = 4
        } else if rand >= four_val && rand < five_val {
            back_text = fiveText
            number = 5
        }


        return (back_text,number)
    }
    
    func checkForBomb(inout selected:Bool,num:Int,node:SKSpriteNode) {
        if selected ==  false {
            if num == 0 {
                counter = 0
                bombAnim(node)
                touch_enabled = false
                GameOverScreen()
            } else {
                flipAnim(node)
                counter++
                checkCounter()
                selected = true

            }
        }
    }
    
    func checkPurchase(numbers:[Int],inout bools:[Bool]) {
        for var i = 0; i < 5; i++ {
            if numbers[i] != 0 {
                if bools[i] == false {
                    counter++
                    checkCounter()
                    bools[i] = true
                }
            }
        }
    }
    
    func checkCounter() {
        if counter == total_tiles {
            self.addChild(answeredCorrect())
        }
    }
    
    func answeredCorrect() -> SKNode {
        let node = SKNode()
        
        let nextButton = SKLabelNode(text: "Next Level")
        nextButton.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/5)
        nextButton.zPosition = 10
        nextButton.fontName = Game_Over_Font
        nextButton.fontColor = fontClr
        nextButton.fontSize = 60
        nextButton.name = "nextButton"
        node.addChild(nextButton)
        
        return node
    }

    func nextLevel() {
        if Game_Level > highestLevel {
            highestLevel = Game_Level
        }
        Game_Level++
        self.removeAllChildren()
        labelNode.removeAllChildren()
        labelNode.removeFromParent()
        resetLists()
        total_tiles = 0
        counter = 0
        current_coins = Int(pow(Float(2), Float(Game_Level)-1))
        saveData()
        setup()
    }
    
    func newGame() {
        //Save data and add collected money
        money += current_coins
        if Game_Level > highestLevel {
            highestLevel = Game_Level
        }
        saveData()
        self.removeAllChildren()
        total_tiles = 0
        counter = 0
        Game_Level = 1
        current_coins = 0
        Flurry.endTimedEvent("User Playing", withParameters:nil)
        startScreen()
    }
    
    func setup() {
        getData()
        if numbers_list.count != 0 {
            numbers_list = []
        }
        if boolList.count != 0 {
            boolList = []
        }
        if topTiles.count != 0 {
            topTiles = []
        }
        if backTiles.count != 0 {
            backTiles = []
        }
        
        let gridNode = createGrid()
        gridNode.position = CGPointMake(self.frame.size.width/2.5,self.frame.size.height/2.5)
        self.addChild(gridNode)
        
        let column_list = getColumns(numbers_list)
        let row_list = getRows(numbers_list)
        let row_bombs = getRowBombs(numbers_list)
        let col_bombs = getColBombs(numbers_list)
        
        total_tiles = calculateTotTiles(numbers_list)
        
        hudNode = HUD()
        let disNum = displayNumbers(row_list, column_list: column_list)
        let disBombs = displayBombs(row_bombs, column_list: col_bombs)
        let disUnlocks = displayUnlocks(row_list, column_list: column_list)
        
        self.addChild(hudNode)
        self.addChild(disNum)
        self.addChild(disBombs)
        self.addChild(disUnlocks)
    }
    func resetLists() {
        numbers_list = []
        boolList = []
        topTiles = []
        backTiles = []
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}
