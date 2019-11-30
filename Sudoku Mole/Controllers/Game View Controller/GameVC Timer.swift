//
//  GameVC Timer.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController {
    @objc func timerStateInAction() {
        let play = UIImage(named: "icTimePlay.png")
        let pause = UIImage(named: "icTimeStop.png")
        
        isPlaying = !isPlaying
        if isPlaying == true {
            timerImageView.image = pause
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            timerImageView.image = play
            timer.invalidate()
        }
    }
    
    @objc func updateTimer() {
        counter = counter + 1
        seconds = counter % 60
        minutes = (counter / 60) % 60
        hours = (counter / 3600)
        record = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        timerOutlet.text = record
    }
}
