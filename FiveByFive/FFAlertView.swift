//
//  FFAlertView.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/16/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class FFAlertView: SKSpriteNode {
    var message = "Use a life to keep playing"
    var lives:Int
    
    
    init(withLives:Int) {
        self.lives = withLives
        let texture = SKTexture(imageNamed: "")
        super.init(texture: texture, color: UIColor.blackColor(), size: CGSizeMake(10, 10))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            let node = self.nodeAtPoint(location)
            
            if node.name == "Yes" {
                
            } else if node.name == "No" {
                
            }
        }
    }
    func presentAlertView(scene:SKScene) {
        scene.addChild(self)
        animateUp()
    }
    func dismissAlertView(scene:SKScene) {
        
    }
    private func animateUp() {
        let upAction = SKAction.moveBy(CGVectorMake(0, self.frame.size.height), duration: 1.0)
        self.runAction(upAction)
    }
    private func animateDown() {
        let downAction = SKAction.moveBy(CGVectorMake(0, -self.frame.size.height), duration: 1.0)
        self.runAction(downAction)
    }
    private func setupButtons() {
        
    }
    
}
