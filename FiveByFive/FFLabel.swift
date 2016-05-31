//
//  FFLabel.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/17/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class FFLabel: SKNode {
    /* POSITIONING IS A LITTLE WEIRD BUT LINE WRAPPING WORKS*/
    
    var bounds:CGSize
    var newLineOn:Bool
    var text:String = "" {
        didSet {
            wrapText()
            //drawBounds()
        }
    }
    var fontSize:CGFloat = 30
    var fontName:String = Constants.FontName.Game_Font
    var fontColor:UIColor = UIColor.blackColor()
    var horizontalAlignmentMode:SKLabelHorizontalAlignmentMode = .Left
    var verticalAlignmentMode:SKLabelVerticalAlignmentMode = .Baseline
    
    init(bounds:CGSize) {
        self.bounds = bounds
        self.newLineOn = false
        super.init()
    }
    
    init(text:String,bounds:CGSize) {
        self.bounds = bounds
        self.newLineOn = false
        self.text = text
        super.init()
        
    }
    init(text:String, bounds:CGSize, useNewLine:Bool) {
        self.bounds = bounds
        self.newLineOn = useNewLine
        self.text = text
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func wrapText() {
        self.removeAllChildren()
        let frameWidth = self.bounds.width
        let label = SKLabelNode(text: self.text)
        let labelWidth = label.frame.size.width
        var str = ""
        var initalPosition = CGPointMake(0,0)
        if (labelWidth > frameWidth) {
            for word in text.words() {
                let tempString = str + word + " "
                if checkLength(tempString) {
                    createSubLabel(str, belowHeight: initalPosition.y)
                    initalPosition.y = initalPosition.y - label.frame.size.height
                    str = word
                } else {
                    str = tempString
                }
            }
        } else {
            createSingleLineLabel(initalPosition)
        }
    }
    //Returns true if length is >= the bounds set in init
    private func checkLength(str:String) -> Bool {
        let tempLabel = SKLabelNode(text: str)
        if tempLabel.frame.size.width >= self.bounds.width {
            return true
        }
        return false
    }
    private func createSingleLineLabel(atPosition:CGPoint) {
        let label = SKLabelNode(text: self.text)
        label.position = atPosition
        label.fontName = self.fontName
        label.fontSize = self.fontSize
        label.fontColor = self.fontColor
        label.zPosition = 1
        label.horizontalAlignmentMode = self.horizontalAlignmentMode
        //label.verticalAlignmentMode = self.verticalAlignmentMode
        self.addChild(label)
    }
    private func createSubLabel(text:String, belowHeight:CGFloat) {
        let subLabel = SKLabelNode(text: text)
        subLabel.position = CGPointMake(0/*-CGRectGetMidX(self.frame)*/, belowHeight - subLabel.frame.size.height)
        subLabel.fontName = self.fontName
        subLabel.fontSize = self.fontSize
        subLabel.fontColor = self.fontColor
        subLabel.zPosition = 1
        subLabel.horizontalAlignmentMode = self.horizontalAlignmentMode
        //subLabel.verticalAlignmentMode = self.verticalAlignmentMode
        self.addChild(subLabel)
    }
    //Debugging method to check positioning and node's bounds
    private func drawBounds() {
        let rect =  SKShapeNode(rectOfSize: self.bounds)
        rect.position = CGPointMake(0, 0)
        rect.lineWidth = 2
        rect.strokeColor = UIColor.blackColor()
        rect.fillColor = UIColor.blueColor()
        rect.zPosition = 0
        self.addChild(rect)
        print("Debugging Rect Added")
    }
}
