//
//  IAP.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/06.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation

class SudokuIAP: Codable, Equatable {
    static func == (lhs: SudokuIAP, rhs: SudokuIAP) -> Bool {
        return lhs.chances == rhs.chances
    }
    var chances = [String]()
}
