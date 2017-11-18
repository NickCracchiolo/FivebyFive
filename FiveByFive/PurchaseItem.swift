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
		super.init(texture: texture, color: UIColor.white, size: CGSize(width: 100, height: 100))
    }
    required init?(coder aDecoder: NSCoder) {
		self.purchaseID = aDecoder.decodeObject(forKey: "purchaseID") as! String
		self.value = aDecoder.decodeObject(forKey: "value") as! String
		self.purchasePrice = aDecoder.decodeFloat(forKey: "purchasePoint")
        super.init(coder: aDecoder)
    }
}
