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
    lazy var backTexture:SKTexture = self.backTextureFrom(self.value)
    private var flipped = false
    
    init(withValue:Int) {
        let texture = SKTexture(imageNamed: "redTile")
        self.value = withValue
        super.init(texture: texture, color: UIColor.whiteColor(), size: CGSizeMake(55, 55))
        self.anchorPoint = CGPointMake(0, 0)
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.value = aDecoder.decodeIntegerForKey("value")
        super.init(coder: aDecoder)
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.value, forKey: "value")
        aCoder.encodeObject(self.backTexture, forKey: "back_texture")
        super.encodeWithCoder(aCoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if flipped == false {
            flip()
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
            if NSUserDefaults.standardUserDefaults().integerForKey(DefaultKeys.Sound.description) == 0 {
                let sound_action = SKAction.playSoundFileNamed("Blast.mp3", waitForCompletion: false)
                self.runAction(sound_action)
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
            let push = SKAction.animateWithTextures(textures, timePerFrame:0.01)
            self.runAction(push)
            self.size = CGSizeMake(50,50)
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
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.BOMB_SELECTED, object: nil)
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
