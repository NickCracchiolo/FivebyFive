//
//  NCSwitch.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class FFSwitch:SKSpriteNode {
    //A tile that acts as Switch. Down is on, Up is off
    var switchOn:Bool = false
    let key:String
    
    init(withName:String,keyForDefaultsItem:String) {
        let texture = SKTexture(imageNamed: "switch")
        self.key = keyForDefaultsItem
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        self.name = withName
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        animate()
    }
    func isOn() -> Bool {
        return switchOn
    }
    func updateSwitchValue() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(valueForSwitch(), forKey: key)
        return defaults.synchronize() //Possibly change to happen when leaving the scene
    }
    func valueForSwitch() -> Int {
        if switchOn {
            return 1
        } else {
            return 0
        }
    }
    private func animate() {
        if switchOn {
            let textures:[SKTexture] = [SKTexture(imageNamed:"redTile5"),SKTexture(imageNamed:"redTile4"),SKTexture(imageNamed:"redTile3"),
                                        SKTexture(imageNamed:"redTile2"),SKTexture(imageNamed:"redTile")]
            let turn_off = SKAction.animateWithTextures(textures, timePerFrame: 0.5)
            self.runAction(turn_off)
            self.switchOn = false
        } else {
            let textures:[SKTexture] = [SKTexture(imageNamed:"redTile2"),SKTexture(imageNamed:"redTile3"),SKTexture(imageNamed:"redTile4"),
                                        SKTexture(imageNamed:"redTile5"),SKTexture(imageNamed:"blueOne")]
            let turn_on = SKAction.animateWithTextures(textures, timePerFrame: 0.01)
            self.runAction(turn_on)
            self.switchOn = true
        }
    }
}
