//
//  Grid.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/2/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class Grid: SKNode {
    var tiles:[Tile] = []
    var columnValues:[Int] = []
    var rowValues:[Int] = []
    var level:Int
    
    override init() {
        self.level = 0
        super.init()
        createGrid()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createGridForNextLevel() {
        self.level += 1
        self.tiles = []
        createGrid()
        
    }
    func flipTile(atIndex:Int) {
        let tile = tiles[atIndex]
        if tile.isFlipped() {
            tiles[atIndex].flip()
        }
    }
    func flipRow(atIndex:Int) {
        
    }
    func flipColumn(atIndex:Int) {
        
    }
    private func createGrid() {
        for row in 0...4 {
            for column in 0...4 {
                let randNum = createRandomValue()
                let tile = Tile(withValue: randNum)
                tile.position = CGPointMake(CGFloat(column)*tile.frame.size.width,
                                            CGFloat(row)*tile.frame.size.height)
                tile.name = "Tile-" + String(row) + "-" + String(column)
                self.addChild(tile)
                self.tiles.append(tile)
            }
        }
    }
    private func calculateColumnValues() {
        var total = 0
        for i in 0.stride(to: 25, by: 5) {
            
        }
    }
    private func calculateRowValues() {
        
    }
    private func createRandomValue() -> Int {
        let rand = Int(arc4random_uniform(101))
        let zero_val = 8 + self.level
        let diff = (100 - zero_val)/5
        let one_val = zero_val + diff
        let two_val = zero_val + diff*2
        let three_val = zero_val + diff*3
        let four_val = zero_val + diff*4
        let five_val = zero_val + diff*5
        
        if rand < zero_val {
            return 0
        } else if rand >= zero_val && rand < one_val {
            return 1
        } else if rand >= one_val && rand < two_val {
            return 2
        } else if rand >= two_val && rand < three_val {
            return 3
        } else if rand >= three_val && rand < four_val {
            return 4
        } else if rand >= four_val && rand < five_val {
            return 5
        } else {
            return 0
        }

    }
}