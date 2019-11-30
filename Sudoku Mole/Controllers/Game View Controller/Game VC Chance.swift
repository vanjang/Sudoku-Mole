//
//  Game VC Chance.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit
import Lottie

extension GameViewController {
    @objc func chanceSetup() {
        if !(appDelegate.item?.chances.isEmpty)! {
            if (appDelegate.item?.chances.count)! > 10 {
                let chanceImage = UIImage(named: "chance10+.png")
                chanceButtonOutlet.setImage(chanceImage, for: .normal)
            } else {
                let chanceImage = UIImage(named: "chance"+String(appDelegate.item!.chances.count)+".png")
                chanceButtonOutlet.setImage(chanceImage, for: .normal)
            }
        } else {
            let chanceImage = UIImage(named: "chanceAD.png")
            chanceButtonOutlet.setImage(chanceImage, for: .normal)
        }
        self.view.layoutIfNeeded()
    }
    
    func shouldRandomNum() -> Bool {
        var shouldBeRandom = Bool()
        if randomNums.count <= 5 && blanksNums.count >= 2 {
            shouldBeRandom = false
        } else if randomNums.count <= 10 && blanksNums.count >= 3 {
            shouldBeRandom = false
        } else {
            shouldBeRandom = true
        }
        return shouldBeRandom
    }
    
    func activateChance() {
        let row = puzzleArea.selected.row
        let col = puzzleArea.selected.column
        if col == 8 {
            playAnimation(answer: appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col), point: sudokuView.cgPointForSelectedBox, isColumn8: true, isBlank: false)
        } else {
            playAnimation(answer: appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col), point: sudokuView.cgPointForSelectedBox, isColumn8: false, isBlank: false)
        }
        appDelegate.spendItem()
        self.chanceSetup()
    }
    
    func playAnimation(answer: Int?, point: CGPoint, isColumn8: Bool, isBlank: Bool) {
        self.chanceButtonOutlet.isUserInteractionEnabled = false
        let boxSize = sudokuView.sizeForSelectedBox
        let frame = CGRect(x: point.x+3, y: (point.y-boxSize.height*0.75)+biOutlet.frame.size.height+view.safeAreaInsets.top+3, width: boxSize.width*1.75, height: boxSize.height*1.80)
        let flippedFrame = CGRect(x: point.x-boxSize.width*0.72, y: (point.y-boxSize.height*0.75)+biOutlet.frame.size.height+view.safeAreaInsets.top+3, width: boxSize.width*1.75, height: boxSize.height*1.80)
        chanceView.frame = frame
        chanceView.backgroundColor = .clear
        
        let side = "Side"
        var lottieName = "Chance"
        let lottieNumber = String(answer!)
        
        if isBlank == false {
            if isColumn8 {
                lottieName += lottieNumber + side
                print(lottieName)
            } else {
                lottieName += lottieNumber
                print(lottieName)
            }
        } else {
            //play Blank
            let randomBlank = random(2)
            lottieName = "Blank" + String(randomBlank)
            print(lottieName)
        }
        
        let lottie = AnimationView(name: lottieName)
        
        if isColumn8 {
            if lottieName == "Blank0" || lottieName == "Blank1" {
                lottie.transform = CGAffineTransform(scaleX: -1, y: 1)
                lottie.frame = flippedFrame
                chanceView.frame = flippedFrame
            } else {
                lottie.frame = flippedFrame
                chanceView.frame = flippedFrame
            }
        } else if !isColumn8 {
            lottie.transform = CGAffineTransform(scaleX: 1, y: 1)
            lottie.frame = frame
            chanceView.frame = frame
        }
        
        lottie.center = chanceView.center
        lottie.contentMode = .scaleAspectFit
        lottie.backgroundColor = .clear
        view.addSubview(lottie)
        
        lottie.play { (finished) in
            self.chanceView.removeFromSuperview()
            lottie.removeFromSuperview()
            self.chanceButtonOutlet.isUserInteractionEnabled = true
        }
        // FLAGED - Build test code - infinite chances
//        appDelegate.storeItems(1)
//        self.chanceSetup()
    }
    
    
}
