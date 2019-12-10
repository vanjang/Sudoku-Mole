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
//        intro.frame = view.bounds
        view.addSubview(intro)
     
        var bttmConstant = CGFloat()
        
        if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "Simulator iPhone 8" || UIDevice.modelName == "Simulator iPhone 7" {
            bttmConstant = 50
        } else {
            bttmConstant = 0
        }
        
        
        intro.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: intro, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: bttmConstant)
        let leftConstraint = NSLayoutConstraint(item: intro, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: intro, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        self.view.addConstraints([bottomConstraint, leftConstraint, rightConstraint])
        
        
        
        if !isFromGameVC {
            progress = 0.00
//            progress = 0.06
        } else {
            progress = -0.20
        }
        DispatchQueue.main.async {
            self.intro.play(fromProgress: progress, toProgress: 0.33, loopMode: .none) { (played) in
//                self.intro.play(fromProgress: 0.14, toProgress: 0.34, loopMode: .loop, completion: nil)
            }//, completion: nil)
        }
        
        view.bringSubviewToFront(startButton)
    }
    
    func playLevelLottie(completion: @escaping ()-> Void) {
        intro.play(fromProgress: 0.355, toProgress: 0.42, loopMode: .none) { (played) in
            completion()
        }
    }
    
    func playSudoji(completion: @escaping ()-> Void) {
        intro.animationSpeed = 1.0
        intro.play(fromProgress: 0.45, toProgress: 0.94, loopMode: .none) { (played) in
            completion()
        }
    }
    
}
