//
//  StoreScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class StoreScene:SKScene {
    var purchases:[PurchaseItem] = []
    
    override func didMoveToView(view: SKView) {
        setupGestures()
    }
    override func update(currentTime: NSTimeInterval) {
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    func swipeRight() {
        
    }
    func swipeLeft() {
        
    }
    private func setupGestures() {
        let swipe_right = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipe_right.direction = UISwipeGestureRecognizerDirection.Right
        self.view?.addGestureRecognizer(swipe_right)
        
        let swipe_left = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipe_left.direction = UISwipeGestureRecognizerDirection.Left
        self.view?.addGestureRecognizer(swipe_left)
    }
    private func setupPurchaseItems() {
        //get from iCloud or p-list
        //let item = PurchaseItem(amountOfCoins: , forAPriceOf: , withID: , withImage: )
        
    }
}
