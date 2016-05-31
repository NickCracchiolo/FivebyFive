//
//  FFButton.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/13/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class FFButton: SKSpriteNode {
    let text:String
    
    init(text:String,name:String) {
        self.text = text
        let texture = SKTexture(imageNamed: "redButton")
        super.init(texture: texture, color: UIColor.whiteColor(), size: CGSizeMake(104, 54))
        self.zPosition = 0
        self.name = name
        addLabel()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addLabel() {
        let label = SKLabelNode(text: self.text)
        label.fontName = Constants.FontName.Game_Font
        label.fontSize = Constants.FontSize.DispFontSize
        label.fontSize *= modifyFontSize(label)
        label.fontColor = UIColor.whiteColor()
        label.horizontalAlignmentMode = .Center
        label.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-5)
        label.zPosition = 1
        label.userInteractionEnabled = false
        self.addChild(label)
    }
    private func modifyFontSize(withLabel:SKLabelNode) -> CGFloat {
        let buttonWidth = self.frame.size.width-10
        let labelWidth = withLabel.frame.size.width
        if (labelWidth > buttonWidth) {
            let buttonHeight = self.frame.size.height + 100
            let labelHeight = withLabel.frame.size.height
            return min((buttonWidth/labelWidth),(buttonHeight/labelHeight))
        }
        return 1
    }
}