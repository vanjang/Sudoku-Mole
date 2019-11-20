//
//  SudokuMenu.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation

enum MenuState {
    case collapsed
    case expanded
    case fullyExpanded
}

enum MenuOptionSelected {
    case recordView
    case instructionView
    case iapView
    case none
}

enum HomeViewControllerTransition {
    case start
    case level
    case sudoji
}

enum GameSolvedButtons {
    case refreshTapped
    case homeTapped
    case SNSTapped
    case none
}

enum DialogOption {
    case oneButton
    case twoButtons
    case threeButtons
}

enum PurchasingIAP {
    case ADRemover
    case Chances
    case none
}
