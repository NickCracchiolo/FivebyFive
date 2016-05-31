//
//  GameData.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/2/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import Foundation

protocol GameDataProtocol {
    func saveGame(withData:GameData)
    func loadInstance() -> GameData
}

class GameData: NSObject, NSCoding {
    // MARK: Singleton (NO LONGER IN USE)
    //static let sharedGameData = GameData()
    
    // MARK: Archiving Paths
    static let documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let archiveURL = documentsDirectory.URLByAppendingPathComponent("gamedata")
    
    // MARK: GameKeys
    struct GameKeys {
        static let highestLevel = "highest level"
        static let levels       = "levels"
        static let lives        = "lives"
        static let ads          = "ads"
        static let coins        = "coins"
    }
    
    // MARK: Properties
    private var highestLevel:Int = 1 
    private var levels:[Int] = []
    private var adsOn:Bool = true
    private var lives:Int = 3
    private var coins:Int = 0
    
    override init() {
        super.init()
    }
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.highestLevel = aDecoder.decodeIntegerForKey(GameKeys.highestLevel)
        self.levels = aDecoder.decodeObjectForKey(GameKeys.levels) as! [Int]
        self.adsOn = aDecoder.decodeBoolForKey(GameKeys.ads)
        self.lives = aDecoder.decodeIntegerForKey(GameKeys.lives)
        self.coins = aDecoder.decodeIntegerForKey(GameKeys.coins)

    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.highestLevel, forKey: GameKeys.highestLevel)
        aCoder.encodeObject(self.levels, forKey: GameKeys.levels)
        aCoder.encodeInteger(self.lives, forKey: GameKeys.lives)
        aCoder.encodeBool(self.adsOn, forKey: GameKeys.ads)
        aCoder.encodeInteger(self.coins, forKey: GameKeys.coins)
    }
    // MARK: Property Specific Methods
    func getHighestLevel() -> Int {
        return self.highestLevel
    }
    func getLives() -> Int {
        return self.lives
    }
    func getCoins() -> Int {
        return self.coins
    }
    func addLevel(num:Int) {
        if num > self.highestLevel {
            print("New Highscore set")
            self.highestLevel = num
        }
        self.levels.append(num)
        self.levels.sortInPlace()
    }
    func removeCoins(value:Int) {
        if (coins-value) > 0 {
            coins -= value
        }
    }
    func addCoins(value:Int) {
        coins += value
    }
    func addLife() {
        lives += 1
    }
    func useLife() {
        if (lives > 0) {
            lives -= 1
        }
    }
    
    // MARK: Print Helper
    func printData() {
        print("Highest Level: ",self.highestLevel)
        print("levels: ", self.levels)
        print("adsOn: ",self.adsOn)
        print("lives: ", self.lives)
        print("coins: ",self.coins)
    }
}