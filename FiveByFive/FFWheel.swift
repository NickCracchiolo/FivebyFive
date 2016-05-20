//
//  ItemWheel.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/6/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class FFWheel: SKNode {
    private let objects:[SKSpriteNode]
    private var currentIndex = 0
    
    override init() {
        self.objects = []
        super.init()
    }
    init(withNodes:[SKSpriteNode]) {
        self.objects = withNodes
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func currentObject() -> SKSpriteNode {
        return self.objects[self.currentIndex]
    }
    func moveRight() {
        if currentIndex > 0 {
            currentIndex -= 1
            adjustWheel()
        }
    }
    func moveLeft() {
        if currentIndex < objects.count {
            currentIndex += 1
            adjustWheel()
        }
    }
    private func adjustWheel() {
        if currentIndex > 1 {
            objects[currentIndex-2].hidden = true
        }
        if currentIndex < objects.count-1 {
            objects[currentIndex+2].hidden = true
        }
        
        if currentIndex > 0 {
            
            let previousItem:SKSpriteNode = objects[currentIndex-1]
            previousItem.position = CGPointMake(CGRectGetMidX(self.frame)-previousItem.frame.size.width*0.8, CGRectGetMidY(self.frame))
            previousItem.hidden = false
            previousItem.setScale(0.7)
            previousItem.alpha = 0.5
            previousItem.zPosition = 1
        }
        
        let currentItem:SKSpriteNode = objects[currentIndex]
        currentItem.setScale(1.0)
        currentItem.hidden = false
        currentItem.alpha = 0.85
        currentItem.zPosition = 3
        currentItem.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        
        if currentIndex < objects.count {
            let nextItem:SKSpriteNode = objects[currentIndex+1]
            nextItem.position = CGPointMake(CGRectGetMidX(self.frame)+nextItem.frame.size.width*0.8, CGRectGetMidY(self.frame))
            nextItem.hidden = false
            nextItem.setScale(0.7)
            nextItem.alpha = 0.5
            nextItem.zPosition = 1
        }
    }

}
