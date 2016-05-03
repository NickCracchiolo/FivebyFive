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
        let texture = SKTexture(imageNamed: "YellowSquare.png")
        self.value = withValue
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        self.anchorPoint = CGPointMake(0, 0)
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
            
        }
    }
    func valueForTile() -> Int {
        //0 means Bomb
        return self.value
    }
    
    func isFlipped() -> Bool {
        return self.flipped
    }
    
    func flip() {
        pushAnimation()
        if value == 0 {
            if NSUserDefaults.standardUserDefaults().integerForKey(DefaultKeys.Sound.description) == 1 {
                let sound_action = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
                self.runAction(sound_action)
            }
            bombAnimation()
        }
    }
    private func showSaveLifeAlert() {
        let alert_controller = UIAlertController(title: "Free Coins", message: "Want a Second Chance for $0.99?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let dismiss_action = UIAlertAction(title: "No Thanks.", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //counter = 0
            //self.touch_enabled = false
            //self.GameOverScreen()
        }
        let stop_asking_action = UIAlertAction(title: "Don't Ask Again", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //self.defaults.setInteger(1, forKey: DefaultKeys.Life.description)
            //counter = 0
            //self.touch_enabled = false
            //self.GameOverScreen()
        }
        let purchase_action = UIAlertAction(title: "Yes Please!", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            inAppPurchases.defaultHelper.saveLife()
            
        }
        alert_controller.addAction(purchase_action)
        alert_controller.addAction(dismiss_action)
        alert_controller.addAction(stop_asking_action)
        self.scene?.view?.window?.rootViewController?.presentViewController(alert_controller, animated: true, completion: nil)

    }
    
    private func pushAnimation() {
        if !self.flipped {
            let push = SKAction.animateWithTextures([/*textures*/], timePerFrame:0.1 )
            self.runAction(push)
            self.flipped = true
        }
    }
    
    private func bombAnimation() {
        //Create Texture Sheet and call Animate with textures
    }
    
    private func backTextureFrom(value:Int) -> SKTexture {
        switch value {
        case 0:
            //Bomb
            return SKTexture(imageNamed: "BombSquare.png")
        case 1:
            //One Tile
            return SKTexture(imageNamed: "GreenOne.png")
        case 2:
            //Two Tile
            return SKTexture(imageNamed: "GreenTwo.png")
        case 3:
            //Three Tile
            return SKTexture(imageNamed: "GreenThree.png")
        case 4:
            //Four Tile
            return SKTexture(imageNamed: "GreenFour.png")
        case 5:
            //Five Tile
            return SKTexture(imageNamed: "GreenFive.png")
        default:
            return SKTexture(imageNamed: "BombSquare.png")
        }
    }
}
