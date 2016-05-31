//
//  Grid.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/2/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit

class Grid: SKNode {
    private var tiles:[Tile]           = []
    private var currentColValues:[Int] = [0,0,0,0,0]
    private var columnValues:[Int]     = []
    private var currentRowValues:[Int] = [0,0,0,0,0]
    private var rowValues:[Int]        = []
    private var rowBombs:[Int]         = []
    private var columnBombs:[Int]      = []
    
    private var level:Int
    var totalTilesFlipped:Int = 0
    var maxNumberedTiles:Int = 0
    
    override init() {
        self.level = 1
        super.init()
        createGrid()
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Touch in Grid")
        //calculateMaxColValues()
        //calculateMaxRowValues()
    }
    func hasWon() -> Bool {
        if (self.totalTilesFlipped == self.maxNumberedTiles) {
            return true
        }
        return false
    }
    func createGridForNextLevel() {
        self.removeAllChildren()
        self.level += 1
        self.tiles = []
        self.columnValues = []
        self.rowValues = []
        self.rowBombs = []
        self.columnBombs = []
        self.currentRowValues = [0,0,0,0,0]
        self.currentColValues = [0,0,0,0,0]
        createGrid()
    }
    
    func showAllTiles() {
        for tile in tiles {
            if !tile.isFlipped() {
                tile.flipWithoutConsequence()
            }
        }
    }
    
    func flipRow(atIndex:Int) {
        for y in atIndex.stride(to: 25, by: 5) {
            var total:Int = 0
            for x in y...y+5 {
                let value = tiles[x].flip()
                currentColValues[x-y] = currentColValues[x-y] + value
                total += value
            }
            currentRowValues[y] = total;
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
        calculateMaxRowValues()
        calculateMaxColValues()
        //showRowAndColumnValues()
        //showRowAndColumnBombs()
        showRowAndColBombsWithMax()
    }
    /* NOT BEING USED
    private func showRowAndColumnValues() {
        createLabel(columnValues, withName: "MaxColLabel", offset: 35, side: .Bottom, color: UIColor.redColor())
        createLabel(currentColValues, withName: "ColLabel", offset: 10, side: .Bottom, color: UIColor.blackColor())
        createLabel(rowValues, withName: "MaxRowLabel", offset: 10, side: .Left, color: UIColor.redColor())
        createLabel(currentRowValues, withName: "RowLabel", offset: 35, side: .Left, color: UIColor.blackColor())
    }
    private func showRowAndColumnBombs() {
        createLabel(columnBombs, withName: "ColLabel", offset: 10, side: .Bottom, color: UIColor.blackColor())
        createLabel(rowBombs, withName: "MaxRowLabel", offset: 10, side: .Left, color: UIColor.blackColor())
    }
    */
    private func showRowAndColBombsWithMax() {
        createLabel(columnValues, withName: "MaxColLabel", offset: 20, side: .Top, color: UIColor.blackColor())
        createLabel(columnBombs, withName: "ColBombLabel", offset: 10, side: .Bottom, color: UIColor.redColor())
        createLabel(rowValues, withName: "MaxRowLabel", offset: 20, side: .Right, color: UIColor.blackColor())
        createLabel(rowBombs, withName: "RowBombLabel", offset: 10, side: .Left, color: UIColor.redColor())
    }
    
    private func createLabel(forValues:[Int],withName:String,offset:CGFloat,side:Side,color:UIColor) {
        var counter = 0
        for val in forValues.reverse() {
            let label = SKLabelNode(text: String(val))
            label.fontSize = 20
            label.fontColor = color
            label.fontName = Constants.FontName.Game_Font
            label.name = withName+String(counter)

            switch side {
            case .Left:
                label.position = CGPointMake(-20-offset, CGFloat(counter)*50+25)
            case .Right:
                label.position = CGPointMake(250+offset, CGFloat(counter)*50+25)
            case .Bottom:
                label.position = CGPointMake(CGFloat(counter)*50+25, -20-offset)
            case .Top:
                label.position = CGPointMake(CGFloat(counter)*50+25, 250+offset)

            }
            
            self.addChild(label)
            counter += 1;
        }
    }
    
    func calculateCurrentColValues() {
        var index = 4
        for x in 0...4 {
            var total = 0
            for y in x.stride(to: x+24, by: 5) {
                if tiles[y].isFlipped() {
                    total += tiles[y].valueForTile()
                }
            }
            currentColValues[index] = total
            let colName = "ColLabel" + String(index)
            let colLabel = self.childNodeWithName(colName) as! SKLabelNode
            colLabel.text = String(currentColValues[index])
            index -= 1
        }
    }
    
    private func calculateMaxColValues() {
        columnValues = []
        columnBombs = []
        var index = 0
        for x in 0...4 {
            var total = 0
            var bombs = 0
            for y in x.stride(to: x+24, by: 5) {
                let value = tiles[y].valueForTile()
                total += value
                if value == 0 {
                    bombs += 1
                }
            }
            columnValues.append(total)
            columnBombs.append(bombs)
            index += 1
        }
    }
    
    func calculateCurrentRowValues() {
        var index = 4
        for y in 0.stride(to: 24, by: 5) {
            var total = 0
            for x in y...y+4 {
                if tiles[x].isFlipped() {
                    total += tiles[x].valueForTile()
                }
            }
            currentRowValues[index] = total
            let rowName = "RowLabel" + String(index)
            let rowLabel = self.childNodeWithName(rowName) as! SKLabelNode
            rowLabel.text = String(currentRowValues[index])
            index -= 1
        }
    }
    
    private func calculateMaxRowValues() {
        rowValues = []
        rowBombs = []
        for y in 0.stride(to: 24, by: 5) {
            var total = 0
            var bombs = 0
            for x in y...y+4 {
                let value = tiles[x].valueForTile()
                total += value
                if value == 0 {
                    bombs += 1
                }
            }
            rowValues.append(total)
            rowBombs.append(bombs)
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

enum Side {
    case Left
    case Right
    case Bottom
    case Top
}