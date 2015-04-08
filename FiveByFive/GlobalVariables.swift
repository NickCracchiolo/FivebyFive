//
//  GlobalVariables.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 4/1/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import Foundation
import SpriteKit
//GameStates
var touch_enabled = true

//zPosition
let tutorial_zPosition:CGFloat = 50
let grid_zPosition:CGFloat = 2

//FONTS
let Game_Font = "Impact Label Reversed"
let HUD_Font = "Impact Label Reversed"
let Title_Font = "Impact Label Reversed"
let Game_Over_Font = "Impact Label"

//FONT COLOR
let backColor = SKColor(red: 61/255, green: 83/255, blue: 178/255, alpha: 1.0)
let titleClr = SKColor(red: 225/255, green: 205/255, blue: 58/255, alpha: 1.0)
let fontClr = SKColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
let blackColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)

//FONT SIZE
let DispFontSize:CGFloat = 30

//Texture
let YellowSquare:SKTexture = SKTexture(imageNamed: "YellowSquare.png")
let bombText:SKTexture = SKTexture(imageNamed: "bomb.png")
let oneText:SKTexture = SKTexture(imageNamed: "GreenOne.png")
let twoText:SKTexture = SKTexture(imageNamed: "GreenTwo.png")
let threeText:SKTexture = SKTexture(imageNamed: "GreenThree.png")

//NSUSERDEFAULT
let defaults = NSUserDefaults.standardUserDefaults()
var money: NSInteger = 0
var highestLevel: NSInteger = 1
var tutorial:NSInteger = 0


func getData() {
    tutorial = defaults.integerForKey("tutorial")
    money = defaults.integerForKey("money")
    highestLevel = defaults.integerForKey("level")
}

func saveData() {
    defaults.setInteger(money, forKey: "money")
    defaults.setInteger(highestLevel, forKey: "level")
    defaults.setInteger(tutorial, forKey: "tutorial")
    defaults.synchronize()
}