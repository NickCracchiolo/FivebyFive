//
//  StartScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/3/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    override func didMoveToView(view: SKView) {
        <#code#>
    }
    override func update(currentTime: NSTimeInterval) {
        <#code#>
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        <#code#>
    }
    private func setupScene() {
        let title_label = SKLabelNode(text: "Five by Five")
        title_label.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.75)
        title_label.fontName = Constants.FontName.Title_Font
        title_label.fontSize = Constants.FontSize.DispFontSize
    }
}
