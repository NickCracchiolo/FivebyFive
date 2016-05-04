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
    var totalTilesFlipped:Int = 0
    var maxNumberedTiles:Int = 0
    
    override init() {
        self.level = 0
        super.init()
        createGrid()
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func hasWon() -> Bool {
        if (self.totalTilesFlipped == self.maxNumberedTiles) {
            return true
        }
        return false
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
            self.totalTilesFlipped += 1
        }
    }
    func flipRow(atIndex:Int) {
        for y in atIndex.stride(to: 25, by: 5) {
            for x in y...y+5 {
                tiles[x].flip()
            }
        }
    }
    func flipColumn(atIndex:Int) {
        var index = 0
        for x in 0...4 {
            var total = 0
            for y in x.stride(to: x+25, by: 5) {
                total += tiles[y].valueForTile()
            }
            columnValues[index] = total
            index += 1
        }
    }
    func currentLevel() -> Int {
        return self.level
    }
    private func createGrid() {
        var z:CGFloat = 5
        let indexes:[Int] = [4,3,2,1,0]
        for row in indexes {
            for column in indexes {
                let randNum = createRandomValue()
                let tile = Tile(withValue: randNum)
                tile.position = CGPointMake(CGFloat(column)*50,
                                            CGFloat(row)*50)
                tile.zPosition = 2
                tile.name = "Tile-" + String(row) + "-" + String(column)
                self.addChild(tile)
                self.tiles.append(tile)
            }
            z -= 1
        }
        calculateRowValues()
        calculateColumnValues()


    }
    private func calculateColumnValues() {
        columnValues = []
        var index = 0
        for x in 0...4 {
            var total = 0
            for y in x.stride(to: x+24, by: 5) {
                total += tiles[y].valueForTile()
            }
            columnValues.append(total)
            index += 1
        }
    }
    private func calculateRowValues() {
        rowValues = []
        for y in 0.stride(to: 20, by: 5) {
            var total = 0
            for x in y...y+5 {
                total += tiles[x].valueForTile()
            }
            rowValues.append(total)
        }
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
            self.maxNumberedTiles += 1
            return 1
        } else if rand >= one_val && rand < two_val {
            self.maxNumberedTiles += 1
            return 2
        } else if rand >= two_val && rand < three_val {
            self.maxNumberedTiles += 1
            return 3
        } else if rand >= three_val && rand < four_val {
            self.maxNumberedTiles += 1
            return 4
        } else if rand >= four_val && rand < five_val {
            self.maxNumberedTiles += 1
            return 5
        } else {
            return 0
        }

    }
}