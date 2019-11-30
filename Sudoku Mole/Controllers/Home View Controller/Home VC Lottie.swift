//
//  Home VC Lottie.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController {
    func playStartLottie() {
        var progress = CGFloat()
        intro.contentMode = .scaleAspectFit
        intro.frame = view.bounds
        view.addSubview(intro)
        if !isFromGameVC {
            progress = 0.0
        } else {
            progress = 0.06
        }
        intro.play(fromProgress: progress, toProgress: 0.33, loopMode: .none, completion: nil)
        view.bringSubviewToFront(startButton)
    }
    
    func playLevelLottie(completion: @escaping ()-> Void) {
        intro.play(fromProgress: 0.33, toProgress: 0.38, loopMode: .none) { (played) in
            completion()
        }
    }
    
    func playSudoji(completion: @escaping ()-> Void) {
        intro.animationSpeed = 1.5
        intro.play(fromProgress: 0.45, toProgress: 0.92, loopMode: .none) { (played) in
            completion()
        }
    }
    
}
