//
//  File.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/25.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation

struct SudokuData: Codable {
    var gameDiff: String = "simple" // this is from prepareForSegue() Main Menu
    var plistPuzzle: [[Int]] = [[Int]] (repeating: [Int] (repeating: 0, count: 9), count: 9) // the loaded puzzle
    var pencilPuzzle: [[[Bool]]] = [[[Bool]]] (repeating: [[Bool]] (repeating: [Bool] (repeating: false, count: 10), count: 9), count: 9) // penciled values - 3x array of booleans
    var userPuzzle: [[Int]] = [[Int]] (repeating: [Int] (repeating: 0, count: 9), count: 9) // user entries to puzzle
}
