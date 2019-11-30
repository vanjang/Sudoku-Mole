//
//  SudokuClass.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/15.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation

class SudokuClass {
    var grid: SudokuData! = SudokuData()
    
    // REQUIRED METHOD: Number stored at given row and column, with 0 indicating an empty cell or cell with penciled in values
    func numberAt(row : Int, column : Int) -> Int {
        if grid.plistPuzzle[row][column] != 0 {
            return grid.plistPuzzle[row][column]
        } else {
            return grid.userPuzzle[row][column]
        }
    }
    
    // REQUIRED METHOD: Number was provided as part of the puzzle, and so cannot be changed
    func numberIsFixedAt(row : Int, column : Int) -> Bool {
        if grid.plistPuzzle[row][column] != 0 {
            return true
        } else {
            return false
        }
    }
    
    // TODO
    // REQUIRED METHOD: Number conflicts with any other number in the same row, column, or 3 × 3 square?
    func isConflictingEntryAt(row : Int, column: Int) -> Bool  {
        var n: Int
        
        if grid.plistPuzzle[row][column] == 0 {
            n = grid.userPuzzle[row][column]
        } else {
            n = grid.plistPuzzle[row][column]
        }
        
        // if no value exists in entry -- no conflict
        if n == 0 { return false }
        
        // check all columns - if same number as current number (except current location) -- conflict --> vertical check
        for r in 0...8 {
            if r != row && (grid.plistPuzzle[r][column] == n || grid.userPuzzle[r][column] == n) {
                return true;
            }
        }
        
        // check all rows - if same number as current number (except current location) -- conflict
        for c in 0...8 {
            if c != column && (grid.plistPuzzle[row][c] == n || grid.userPuzzle[row][c] == n) {
                return true;
            }
        }
        
        // check all 3x3s - row, col = (0,0)-(8,8)
        let threeByThreeRow : Int = row / 3 // forced division
        let threeByThreeCol : Int = column / 3 // forced division
        // 0-2 = 0, 3-5 = 1, 6-8 = 2  ----> 0 + (0*3), 1 + (0*3), 2 + (0*3)
        // check rows and columns in these areas
        let startRow = threeByThreeRow * 3
        let startCol = threeByThreeCol * 3
        let endRow = 2 + (threeByThreeRow * 3)
        let endCol = 2 + (threeByThreeCol * 3)
        for r in startRow...endRow {
            for c in startCol...endCol {
                if c != column && r != row && (grid.plistPuzzle[r][c] == n || grid.userPuzzle[r][c] == n) {
                    return true
                }
            }
        }
        return false
    }
    
    // load game from plist
    func plistToPuzzle(plist: String, toughness: String) -> [[Int]] {
        // init initial puzzle
        var puzzle = [[Int]] (repeating: [Int] (repeating: 0, count: 9), count: 9)
        // replace . with 0
        let plistZeroed = plist.replacingOccurrences(of: ".", with: "0")
        
        // create puzzle
        var col: Int = 0
        var row: Int = 0
        for c in plistZeroed {
            puzzle[row][col] = Int(String(c))!
            row = row + 1
            if row == 9 {
                row = 0
                col = col + 1
                if col == 9 {
                    return puzzle
                }
            }
        }
        return puzzle
    }
    
    // Setter
    func userGrid(n: Int, row: Int, col: Int) {
        grid.userPuzzle[row][col] = n
        if !grid.undonePuzzle.isEmpty {
            for i in grid.undonePuzzle {
                grid.puzzleStack.append(i)
            }
            grid.puzzleStack.append(grid.userPuzzle)
            grid.undonePuzzle.removeAll()
        } else {
            grid.puzzleStack.append(grid.userPuzzle)
        }
    }
    
    // Is the piece a user piece
    func userEntry(row: Int, column: Int) -> Int {
        return grid.userPuzzle[row][column]
    }
    
    // User undo
    func undoGrid() {//row: Int, col: Int) {
        if !grid.puzzleStack.isEmpty {
            grid.undonePuzzle.insert(grid.puzzleStack.removeLast(), at: 0)
            if !grid.puzzleStack.isEmpty {
                grid.userPuzzle = grid.puzzleStack.last!
            } else {
                clearUserPuzzle()
            }
        }
    }
    
    func redoGrid() -> [[[Int]]] {
        let last = grid.undonePuzzle
        return last
    }
    
    func undoPencil() {
        if !grid.pencilStack.isEmpty {
            grid.undonePencil.insert(grid.pencilStack.removeLast(), at: 0)
            if !grid.pencilStack.isEmpty {
                grid.pencilPuzzle = grid.pencilStack.last!
            } else {
                clearPencilPuzzle()
            }
        }
    }
    
    func redoPencil() -> [[[[Bool]]]] {
        let last = grid.undonePencil
        return last
    }
    
    // REQUIRED METHOD: Are the any penciled in values at the given cell?
    func anyPencilSetAt(row : Int, column : Int) -> Bool {
        for n in 0...9 {
            if grid.pencilPuzzle[row][column][n] == true {
                return true
            }
        }
        return false
    }
    
    // REQUIRED METHOD: Is value n penciled in?
    func isSetPencil(n : Int, row : Int, column : Int) -> Bool {
        return grid.pencilPuzzle[row][column][n]
    }
    
    // setter - reverse
    func pencilGrid(n: Int, row: Int, col: Int) {
        grid.pencilPuzzle[row][col][n] = !grid.pencilPuzzle[row][col][n]
        
        if !grid.undonePencil.isEmpty {
            for i in grid.undonePencil {
                grid.pencilStack.append(i)
            }
            grid.pencilStack.append(grid.pencilPuzzle)
            grid.undonePencil.removeAll()
        } else {
            grid.pencilStack.append(grid.pencilPuzzle)
        }
    }
    
    // setter - blank
    func pencilGridBlank(n: Int, row: Int, col: Int) {
        grid.pencilPuzzle[row][col][n] = false
    }
    
    func clearPlistPuzzle() {
        grid.plistPuzzle = [[Int]] (repeating: [Int] (repeating: 0, count: 9), count: 9) // the loaded puzzle
    }
    
    func clearPencilPuzzle() {
        grid.pencilPuzzle = [[[Bool]]] (repeating: [[Bool]] (repeating: [Bool] (repeating: false, count: 10), count: 9), count: 9)
    }
    
    func clearUserPuzzle() {
        grid.userPuzzle = [[Int]] (repeating: [Int] (repeating: 0, count: 9), count: 9)
    }
    
    func clearConflicts() {
        for r in 0...8 {
            for c in 0...8 {
                if isConflictingEntryAt(row: r, column: c) {
                    grid.userPuzzle[r][c] = 0
                }
            }
        }
    }
    
    // Check if game is set
    func isGameSet(row : Int, column: Int) -> Int {
        // 1. 0 : game not finished / 1 : game finished but not correctly / 2 : game finished and correct
        var gameChecker = 0
        
        // 2. Instantiate current plist & user puzzle
        let plist = grid.plistPuzzle
        var userPuzzle = grid.userPuzzle
        
        // 3. userPuzzle에 plist puzzle값을 바꿔서 넣어주기
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                if plist[r][c] != 0 {
                    userPuzzle[r][c] = 10 // 10은 단지 구분하기 위한 숫자
                }
            }
        }
        
        // 4. userPuzzle에 default값인 '0'이 있는지 check
        // 모든 r/c값을 확인 후 bool값을 array에 추가함
        var isAllUserFieldFilled = [Bool]()
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                if userPuzzle[r][c] == 0 {
                    isAllUserFieldFilled.append(false)
                } else {
                    isAllUserFieldFilled.append(true)
                }
            }
        }
        
        // 5. gameset check
        if isAllUserFieldFilled.contains(false) {
            gameChecker = 0
        } else {
            var isSolved = [Bool]()
            for r in 0 ..< 9 {
                for c in 0 ..< 9 {
                    if !isConflictingEntryAt(row: r, column: c) {
                        isSolved.append(true)
                    } else {
                        isSolved.append(false)
                    }
                }
                if isSolved.contains(false) {
                    gameChecker = 1
                } else {
                    gameChecker = 2
                }
            }
        }
        return gameChecker
    }
    
    func correctAnswerForSelectedBox(row: Int, col: Int) -> Int {
        return grid.puzzleAnswer[row][col]
    }  
}
