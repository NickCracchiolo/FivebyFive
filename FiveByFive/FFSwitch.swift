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
    private var switchOn:Bool = false
    let key:String
    
    init(withName:String,keyForDefaultsItem:String) {
        let texture = SKTexture(imageNamed: "redTile")
        self.key = keyForDefaultsItem
        super.init(texture: texture, color: UIColor.white, size: texture.size())
        self.name = withName
		self.isUserInteractionEnabled = true
        switchOn = setInitalSwitchValue()
        animate()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if switchOn {
            turnOff()
        } else {
            turnOn()
        }
        updateSwitchValue()
        animate()
    }
    func isOn() -> Bool {
        return switchOn
    }
    func valueForSwitch() -> Int {
        if switchOn {
            return 1
        } else {
            return 0
        }
    }
    func saveSwitchValue() {
        UserDefaults.standard.synchronize()
    }
    private func turnOff() {
        switchOn = false
    }
    private func turnOn() {
        switchOn = true
    }
    private func setInitalSwitchValue() -> Bool {
		let num = UserDefaults.standard.integer(forKey: key)
        if num == 1 {
            return true
        } else {
            return false
        }
    }
    private func updateSwitchValue() {
        let defaults = UserDefaults.standard
		defaults.set(valueForSwitch(), forKey: key)
    }
    
    private func animate() {
        if switchOn {
            let textures:[SKTexture] = [SKTexture(imageNamed:"redTile5"),SKTexture(imageNamed:"redTile4"),SKTexture(imageNamed:"redTile3"),
                                        SKTexture(imageNamed:"redTile2"),SKTexture(imageNamed:"redTile")]
			let turn_off = SKAction.animate(with: textures, timePerFrame: 0.02)
			self.run(turn_off)
        } else {
            let textures:[SKTexture] = [SKTexture(imageNamed:"redTile2"),SKTexture(imageNamed:"redTile3"),SKTexture(imageNamed:"redTile4"),
                                        SKTexture(imageNamed:"redTile5"),SKTexture(imageNamed:"blueOne")]
			let turn_on = SKAction.animate(with: textures, timePerFrame: 0.02)
			self.run(turn_on)
        }
    }
}
