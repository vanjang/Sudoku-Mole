//
//  GameVC Gesture Recognisers.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController {
    @objc func singleTapped(sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: sudokuView)
        let gridSize = sudokuView.bounds.width
        let gridOrigin = CGPoint(x: (sudokuView.bounds.width - gridSize)/2, y: (sudokuView.bounds.height - gridSize)/2)
        let d = gridSize/9
        let col = Int((tapPoint.x - gridOrigin.x)/d)
        let row = Int((tapPoint.y - gridOrigin.y)/d)
        
        if  0 <= col && col < 9 && 0 <= row && row < 9 {
            makeTipView()
            sudokuView.isUserInteractionEnabled = false
            
            let tipViewKey = "TipViewShownOnce6" // FLAGED "TipViewShownOnce"
            let userDefault = appDelegate.userDefault
            var count = Int()
            
            guard let tipViewCount = userDefault.value(forKey: tipViewKey) as? Int else {
                userDefault.set(1, forKey: tipViewKey)
                return
            }
            count = tipViewCount + 1
            userDefault.set(count, forKey: tipViewKey)
        }
    }
    
    @objc func doubleTapped(sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: sudokuView)
        let gridSize = sudokuView.bounds.width
        let gridOrigin = CGPoint(x: (sudokuView.bounds.width - gridSize)/2, y: (sudokuView.bounds.height - gridSize)/2)
        let d = gridSize/9
        let col = Int((tapPoint.x - gridOrigin.x)/d)
        let row = Int((tapPoint.y - gridOrigin.y)/d)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = appDelegate.sudoku
        
        if  0 <= col && col < 9 && 0 <= row && row < 9 {
            if (!puzzle.numberIsFixedAt(row: row, column: col)) {
                if puzzle.grid?.userPuzzle[row][col] != 0 {
                    playSound(soundFile: "inGameMenuAndButtons", lag: 0.0, numberOfLoops: 0)
                    appDelegate.sudoku.userGrid(n: 0, row: row, col: col)
                    refresh()
                }
            }
        }
    }
    
}
