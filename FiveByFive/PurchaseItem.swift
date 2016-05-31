//
//  PurchaseItem.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit
import StoreKit

class PurchaseItem:SKSpriteNode {
    let purchaseID:String
    let value:String
    let purchasePrice:Float
    
    init(value:String, forAPriceOf:Float, withID:String, withImage:String) {
        self.purchaseID = withID
        self.value = value
        self.purchasePrice = forAPriceOf
        let texture = SKTexture(imageNamed: withImage)
        super.init(texture: texture, color: UIColor.whiteColor(), size: CGSizeMake(100, 100))
    }
    required init?(coder aDecoder: NSCoder) {
        self.purchaseID = aDecoder.decodeObjectForKey("purchaseID") as! String
        self.value = aDecoder.decodeObjectForKey("value") as! String
        self.purchasePrice = aDecoder.decodeFloatForKey("purchasePoint")
        super.init(coder: aDecoder)
    }
}
