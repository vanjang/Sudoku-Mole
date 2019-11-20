//
//  SudokuClass.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/15.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
//import UIKit

class SudokuClass {
//    var inProgress = false
    var grid: SudokuData! = SudokuData()
    
    // REQUIRED METHOD: Number stored at given row and column, with 0 indicating an empty cell or cell with penciled in values
    // 유저가 채워넣는 숫자
    // 정확히는 '선택한 셀의 숫자'
    // SudokuData의 plistPuzzle을 인스턴스로 가진 grid의 값을 확인한다 -> 한마디로 plistPuzzle -> 한마디로 어디선가 SudokuData의 plistPuzzle을 initialize하겠지
    // 0일 경우 빈칸 혹은 유저가 채워 넣은 칸으로 userPuzzle의 해당값([row][column])을 return한다
    // 0이 아닐 경우 plistPuzzle의 해당값([row][column])을 return한다
    func numberAt(row : Int, column : Int) -> Int {
        if grid.plistPuzzle[row][column] != 0 {
            return grid.plistPuzzle[row][column]
        } else {
            return grid.userPuzzle[row][column]
        }
    }
    
    // REQUIRED METHOD: Number was provided as part of the puzzle, and so cannot be changed
    // view의 mutuble 여부를 bool로 return하는 method
    func numberIsFixedAt(row : Int, column : Int) -> Bool {
        if grid.plistPuzzle[row][column] != 0 {
            return true
        } else {
            return false
        }
    } // end numberIsFixedAt
    
    // TODO
    // REQUIRED METHOD: Number conflicts with any other number in the same row, column, or 3 × 3 square?
    // isConflictingEntryAt이 call될 때 모든 row/col을 확인한다(loop)
    func isConflictingEntryAt(row : Int, column: Int) -> Bool  {
        // get n
        // 일단 현재값을 가져온다
        // 현재값이 0일 경우 n은 userPuzzle값
        // 현재값이 0이 아닐 경우 n은 plistPuzzle값
        var n: Int
        
        // 만약 현재 위치에 기본값이 있을 경우 n에 기본값을 넣어준다
        // 현재 위치에 기본값이 0일 경우 유저값을 넣어준다
        if grid.plistPuzzle[row][column] == 0 {
            n = grid.userPuzzle[row][column]
        } else {
            n = grid.plistPuzzle[row][column]
        }
        
        // if no value exists in entry -- no conflict
        // plistPuzzle값이 0일 경우(None-fixed) && 유저값이 0일 경우 - no conflict고 false return
        // 만약 유저값도 없을 경우 non conflict이다
        if n == 0 { return false }
        
        // check all columns - if same number as current number (except current location) -- conflict
        // 가로줄 9칸 확인 - 만약 현재값과 같은값이 있다면 오답
        // 사용자 현재값을 제외한 다른 모든 8 rows or 8 cols을 확인하면 된다
        for r in 0...8 {
            // 현재 looping값(r)이 현재값(row)와 같다면 이건 확인 안해도 되니 제외
            // plistPuzzle[row][column]의 row가 'r'이 되어야 할 거 같은데...
            if r != row && (grid.plistPuzzle[r][column] == n || grid.userPuzzle[r][column] == n) {
//                if r != row && (grid.plistPuzzle[row][column] == n || grid.userPuzzle[row][column] == n) {
                return true;
            }
        }
        
        // check all rows - if same number as current number (except current location) -- conflict
        for c in 0...8 {
//            if c == column && (grid.plistPuzzle[row][column] == n || grid.userPuzzle[row][column] == n) {
                if c != column && (grid.plistPuzzle[row][c] == n || grid.userPuzzle[row][c] == n) {
                return true;
            }
        }
        
        // check all 3x3s
        // row, col = (0,0)-(8,8)
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
                // if not the original square and contains the value n -- conflict
                if c != column && r != row && (grid.plistPuzzle[r][c] == n || grid.userPuzzle[r][c] == n) {
//                if c != column && r != row && (grid.plistPuzzle[row][column] == n || grid.userPuzzle[row][column] == n) {
                    return true
                } // end if
            } // end c
        } // end r
        
        // no conflicts
        return false
    } // end isConflictingEntryAt
 
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
    
    // setter
    // 유저값을 넣는 메소드
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
    // 유저값을 가져오는 메소드
    func userEntry(row: Int, column: Int) -> Int {
        return grid.userPuzzle[row][column]
    } // end userEntry
    
    // 유저가 언두하면 삭제/저장함
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
    
    // Penciling
    
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
    } // end anyPencilSetAt
        
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
//        grid.pencilStack.append(grid.pencilPuzzle)
        
        
    } // end userGrid

    // setter - blank
    func pencilGridBlank(n: Int, row: Int, col: Int) {
        grid.pencilPuzzle[row][col][n] = false
    } // end userGrid
    
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
    
//    func gameInProgress(set: Bool) {
//        inProgress = set
//    }
//    
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
            print("not all field has not been filled")
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
               // print(isSolved)
                if isSolved.contains(false) {
                    print("it is not solved")
                    gameChecker = 1
                } else {
                    print("it is solved")
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
