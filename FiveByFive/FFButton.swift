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
		super.init(texture: texture, color: UIColor.white, size: CGSize.init(width: 104, height: 54))
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
		label.fontSize *= modifyFontSize(withLabel: label)
        label.fontColor = UIColor.white
        label.horizontalAlignmentMode = .center
		label.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 5)
        label.zPosition = 1
        label.isUserInteractionEnabled = false
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
