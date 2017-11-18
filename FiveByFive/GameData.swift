//
//  GameData.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/2/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameDataProtocol {
    func saveGame(withData:GameData)
    func loadInstance() -> GameData
}

extension SKScene {
	func saveGame(withData:GameData) {
		let encodedData = NSKeyedArchiver.archiveRootObject(withData, toFile: GameData.archiveURL.path)
		if !encodedData {
			print("Save Failed")
		}
	}
	
	func loadInstance() -> GameData {
		if let data = NSKeyedUnarchiver.unarchiveObject(withFile: GameData.archiveURL.path) as? GameData {
			return data
		} else {
			print("Data could not be loaded properly")
			return GameData()
		}
	}
}

class GameData: NSObject, NSCoding {
    // MARK: Archiving Paths
	static var documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    //static let archiveURL = documentsDirectory.URLByAppendingPathComponent("gamedata")
	static let archiveURL = documentsDirectory.appendingPathComponent("gamedata")
    
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
		self.highestLevel = aDecoder.decodeInteger(forKey: GameKeys.highestLevel)
		self.levels = aDecoder.decodeObject(forKey: GameKeys.levels) as! [Int]
		self.adsOn = aDecoder.decodeBool(forKey: GameKeys.ads)
		self.lives = aDecoder.decodeInteger(forKey: GameKeys.lives)
		self.coins = aDecoder.decodeInteger(forKey: GameKeys.coins)

    }
    func encode(with aCoder: NSCoder) {
		aCoder.encode(self.highestLevel, forKey: GameKeys.highestLevel)
		aCoder.encode(self.levels, forKey: GameKeys.levels)
		aCoder.encode(self.lives, forKey: GameKeys.lives)
		aCoder.encode(self.adsOn, forKey: GameKeys.ads)
		aCoder.encode(self.coins, forKey: GameKeys.coins)
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
		self.levels.sort()
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
