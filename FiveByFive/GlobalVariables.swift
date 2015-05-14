//
//  GlobalVariables.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 4/1/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import Foundation
import SpriteKit

//zPosition
let tutorial_zPosition:CGFloat = 50
let grid_zPosition:CGFloat = 2
let OVERLAYZ:CGFloat = 50
let OVERLAY_OBJZ:CGFloat = 51

//FONTS
let Game_Font = "Impact Label Reversed"
let HUD_Font = "Impact Label Reversed"
let Title_Font = "Impact Label Reversed"
let Game_Over_Font = "Impact Label"

//FONT COLOR
let backColor = UIColor(red: 61/255, green: 83/255, blue: 178/255, alpha: 1.0)
let titleClr = SKColor(red: 225/255, green: 205/255, blue: 58/255, alpha: 1.0)
let fontClr = SKColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1.0)
let blackColor = SKColor(red: 0, green: 0, blue: 0, alpha: 1.0)

//FONT SIZE
let DispFontSize:CGFloat = 30

//NSUSERDEFAULT
let defaults = NSUserDefaults.standardUserDefaults()
var money: NSInteger = 0
var highestLevel: NSInteger = 1
var tutorial: NSInteger = 0
var notifications_on: NSInteger = 0
var sounds_on: NSInteger = 0
var freeCoins: NSInteger = 0
var saved_year:NSInteger = 0
var saved_month:NSInteger = 0
var saved_day:NSInteger = 0
var adsOn:NSInteger = 0
var save_life:NSInteger = 0
var purchase_failed:Bool = false


func getData() {
    tutorial = defaults.integerForKey("tutorial")
    money = defaults.integerForKey("money")
    highestLevel = defaults.integerForKey("level")
    notifications_on = defaults.integerForKey("notif_bool")
    sounds_on = defaults.integerForKey("sounds_bool")
    freeCoins = defaults.integerForKey("freeCoins")
    saved_year = defaults.integerForKey("savedyear")
    saved_month = defaults.integerForKey("savedmonth")
    saved_day = defaults.integerForKey("savedday")
    adsOn = defaults.integerForKey("ads")
    save_life = defaults.integerForKey("save_life")
}

func saveData() {
    defaults.setInteger(money, forKey: "money")
    defaults.setInteger(highestLevel, forKey: "level")
    defaults.setInteger(tutorial, forKey: "tutorial")
    defaults.setInteger(notifications_on, forKey: "notif_bool")
    defaults.setInteger(sounds_on, forKey: "sounds_bool")
    defaults.setInteger(freeCoins, forKey: "freeCoins")
    defaults.setInteger(saved_year, forKey: "savedyear")
    defaults.setInteger(saved_month, forKey: "savedmonth")
    defaults.setInteger(saved_day, forKey: "savedday")
    defaults.setInteger(adsOn, forKey: "ads")
    defaults.setInteger(save_life, forKey: "save_life")
    defaults.synchronize()
}