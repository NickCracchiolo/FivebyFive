//
//  ItemWheel.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/6/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class FFWheel: SKNode {
    private var objects:[PurchaseItem] {
        didSet {
            
        }
    }
    private var currentIndex = 0
    private var priceLabel:SKLabelNode = SKLabelNode(text: "")
    
    override init() {
        self.objects = []
        super.init()
        //setupScene()
    }
    init(withNodes:[PurchaseItem]) {
        self.objects = withNodes
        super.init()
        for node in self.objects {
            node.isHidden = true
            self.addChild(node)
        }
        adjustWheel()
        setupScene()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupScene() {
        var str = ""
        if objects[currentIndex].purchaseID == ProductIDs.saveLife {
            str = objects[currentIndex].value + " for 200 Coins"
        } else {
            str = objects[currentIndex].value + " for $" + String(objects[currentIndex].purchasePrice)
        }
        priceLabel = SKLabelNode(text: str)
        priceLabel.fontSize = Constants.FontSize.DispFontSize
        priceLabel.fontColor = UIColor.black
        priceLabel.fontName = Constants.FontName.Game_Font
		priceLabel.position = CGPoint(x: 0, y: -100)
        self.addChild(priceLabel)
        
    }

    func currentObject() -> SKSpriteNode {
        return self.objects[self.currentIndex]
    }
    func moveRight() {
        if currentIndex > 0 {
            currentIndex -= 1
            adjustWheel()
            var str = ""
            if objects[currentIndex].purchaseID == ProductIDs.saveLife {
                str = objects[currentIndex].value + " for 200 Coins"
            } else {
                str = objects[currentIndex].value + " for $" + String(objects[currentIndex].purchasePrice)
            }
            priceLabel.text = str
        }
    }
    func moveLeft() {
        if currentIndex < objects.count-1 {
            currentIndex += 1
            adjustWheel()
            var str = ""
            if objects[currentIndex].purchaseID == ProductIDs.saveLife {
                str = objects[currentIndex].value + " for 200 Coins"
            } else {
                str = objects[currentIndex].value + " for $" + String(objects[currentIndex].purchasePrice)
            }
            priceLabel.text = str
        }
    }
    private func adjustWheel() {

        if currentIndex > 1 {
            objects[currentIndex-2].isHidden = true
        }
        if currentIndex < objects.count-2 {
            objects[currentIndex+2].isHidden = true
        }
        
        if currentIndex > 0 {
            
            let previousItem:SKSpriteNode = objects[currentIndex-1]
			previousItem.position = CGPoint(x: -previousItem.frame.size.width*0.8, y: 0)
            previousItem.isHidden = false
            previousItem.setScale(0.7)
            previousItem.alpha = 0.5
            previousItem.zPosition = 1
        }
        let currentItem:SKSpriteNode = objects[currentIndex]
        currentItem.setScale(1.0)
        currentItem.isHidden = false
        currentItem.alpha = 0.95
        currentItem.zPosition = 3
		currentItem.position = CGPoint(x: 0, y: 0)
        
        if currentIndex < objects.count-1 {
            let nextItem:SKSpriteNode = objects[currentIndex+1]
			nextItem.position = CGPoint(x: nextItem.frame.size.width*0.8, y: 0)
            nextItem.isHidden = false
            nextItem.setScale(0.7)
            nextItem.alpha = 0.5
            nextItem.zPosition = 1
        }
    }

}
