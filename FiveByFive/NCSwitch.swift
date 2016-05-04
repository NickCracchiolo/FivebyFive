//
//  NCSwitch.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class NCSwitch:SKSpriteNode {
    var switchOn:Bool = false
    
    init() {
        let texture = SKTexture(imageNamed: "switch")
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        animate()
    }
    private func animate() {
        if switchOn {
            let turn_off = SKAction.animateWithTextures([], timePerFrame: 0.5)
            self.runAction(turn_off)
            self.switchOn = false
        } else {
            let turn_on = SKAction.animateWithTextures([], timePerFrame: 0.5)
            self.runAction(turn_on)
            self.switchOn = true
        }
    }
}
