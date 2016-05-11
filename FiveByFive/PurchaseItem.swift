//
//  PurchaseItem.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class PurchaseItem:SKSpriteNode {
    let purchaseID:String
    let coinAmount:Int
    let purchasePrice:Float
    
    init(amountOfCoins:Int, forAPriceOf:Float, withID:String, withImage:String) {
        self.purchaseID = withID
        self.coinAmount = amountOfCoins
        self.purchasePrice = forAPriceOf
        let texture = SKTexture(imageNamed: withImage)
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
    }
    required init?(coder aDecoder: NSCoder) {
        self.purchaseID = aDecoder.decodeObjectForKey("purchaseID") as! String
        self.coinAmount = aDecoder.decodeIntegerForKey("coinAmount")
        self.purchasePrice = aDecoder.decodeFloatForKey("purchasePoint")
        super.init(coder: aDecoder)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //IAP.sharedIAP
    }
    func purchaseItem() -> Int {
        return self.coinAmount
    }
}
