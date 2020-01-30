//
//  Game VC SaveAndLoad.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2020/01/14.
//  Copyright © 2020 cochipcho. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController {
    // It ONLY autosaves game data in temporary Model (SudokuData), NOT LocalStorage
    func autoSaving() {
        self.appDelegate.sudoku.grid.savedTime = counter
        self.appDelegate.sudoku.grid.savedOutletTime = record
        self.appDelegate.sudoku.grid.lifeRemained = lives
        self.appDelegate.sudoku.grid.savedRow = self.puzzleArea.selected.row
        self.appDelegate.sudoku.grid.savedCol = self.puzzleArea.selected.column
        //Keypad data is being saved directly from keypad ibaction when needing its state update
    }
    
    // New & Saved game data load - ALL DATA IS INITIALISED IN Home VC
    func loadGameData() {
        timerView.bringSubviewToFront(timerOutlet)
        timerView.bringSubviewToFront(timerSwitch)
        
        let grid = appDelegate.sudoku.grid
        timerOutlet.text = grid?.savedOutletTime
        counter = grid!.savedTime
        lives = grid!.lifeRemained
        sudokuView.selected.row = grid!.savedRow
        sudokuView.selected.column = grid!.savedCol
        timerStateInAction()
    }
    
    func saveRecord() {
        // timer 종료
        timer.invalidate()
        
        // 기존 기록 로드할 인스턴스
        var load = [Record]()
        
        // level 인스턴스
        let level = appDelegate.sudoku.grid.gameDiff
        
        // 기존 기록이 존재할 경우, 각 기록의 new기록 flag를 false로 변경 후 다시 기존 기록으로 저장 (new 기록을 흰색으로 바꿔야 하기 때문)
        if let records = Record.loadRecord(forKey: level) {
            for r in records {
                r.isNew = false
                load.append(r)
            }
        }
        
        // convert hours/minuntes to seconds
        let secondsCombined = seconds + (minutes*60) + ((hours*60)*60)
        
        // initialize Record() then append to load array
        let save = Record(record: record, recordInSecond: secondsCombined, isNew: true)
        load.append(save)
        
        // sort it out in big to small order
        let sorted = load.sorted { $0.recordInSecond < $1.recordInSecond }
        
        Record.saveRecord(record: sorted, forKey: level)
    }
}
