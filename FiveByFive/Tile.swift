//
//  Tile.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/2/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

enum TileValue: Int {
    case Bomb  = 0
    case One   = 1
    case Two   = 2
    case Three = 3
    case Four  = 4
    case Five  = 5
}

class Tile: SKSpriteNode {
    private let value:Int
	lazy var backTexture:SKTexture = self.backTextureFrom(value: self.value)
    private var flipped = false
    
    init(withValue:Int) {
        let texture = SKTexture(imageNamed: "redTile")
        self.value = withValue
		super.init(texture: texture, color: UIColor.white, size: CGSize(width: 55, height:55))
		self.anchorPoint = CGPoint(x: 0, y:0)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
		self.value = aDecoder.decodeInteger(forKey: "value")
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
		aCoder.encode(self.value, forKey: "value")
		aCoder.encode(self.backTexture, forKey: "back_texture")
        super.encode(with: aCoder)
    }
    
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if flipped == false {
            let _ = flip()
        }
    }
    func valueForTile() -> Int {
        //0 means Bomb
        return self.value
    }
    
    func isFlipped() -> Bool {
        return self.flipped
    }
    
    func flip() -> Int {
        self.zPosition = 1
        pushAnimation()
        if value == 0 {
			if UserDefaults.standard.integer(forKey: DefaultKeys.sound.description) == 0 {
                let sound_action = SKAction.playSoundFileNamed("Blast.mp3", waitForCompletion: false)
				self.run(sound_action)
            }
            bombAnimation()
        } else {
            let grid = self.parent as! Grid
            //grid.calculateCurrentColValues()
            //grid.calculateCurrentRowValues()
            grid.totalTilesFlipped += 1;
        }
        return self.value
    }
    func flipWithoutConsequence() {
        self.zPosition = 1
        pushAnimation()
        //let grid = self.parent as! Grid
        //grid.calculateCurrentColValues()
        //grid.calculateCurrentRowValues()
    }
    
    private func pushAnimation() {
        if !self.flipped {
            let textures:[SKTexture] = [SKTexture(imageNamed:"redTile2"),SKTexture(imageNamed:"redTile3"),SKTexture(imageNamed:"redTile4"),
                                        SKTexture(imageNamed:"redTile5"),backTexture]
			let push = SKAction.animate(with: textures, timePerFrame:0.01)
			self.run(push)
			self.size = CGSize(width: 50, height: 50)
            self.flipped = true
        }
    }
    
    private func bombAnimation() {
        //Create Texture Sheet and call Animate with textures
        //let textures:[SKTexture] = []
        //let animate = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        //self.runAction(animate, completion: {
        //    NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.BOMB_SELECTED, object: nil)
        //})
		NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.Notifications.BOMB_SELECTED), object: nil)
    }
    
    private func backTextureFrom(value:Int) -> SKTexture {
        switch value {
        case 0:
            //Bomb
            return SKTexture(imageNamed: "bombTile")
        case 1:
            //One Tile
            return SKTexture(imageNamed: "blueOne")
        case 2:
            //Two Tile
            return SKTexture(imageNamed: "blueTwo")
        case 3:
            //Three Tile
            return SKTexture(imageNamed: "blueThree")
        case 4:
            //Four Tile
            return SKTexture(imageNamed: "blueFour")
        case 5:
            //Five Tile
            return SKTexture(imageNamed: "blueFive")
        default:
            return SKTexture(imageNamed: "bombTile")
        }
    }
}
