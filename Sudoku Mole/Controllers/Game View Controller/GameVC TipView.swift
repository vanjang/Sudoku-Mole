//
//  Functions.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit
import Lottie

extension GameViewController {
    func shouldTipView() -> Bool {
        let tipViewKey = "TipViewShownOnce6" // FLAGED "TipViewShownOnce"
        let userDefault = appDelegate.userDefault
        
        guard let value = userDefault.value(forKey: tipViewKey) as? Int else {
            userDefault.set(0, forKey: tipViewKey)
            return true
        }
        
        if value < 2 {
            return true
        } else {
            return false
        }
    }
    
    @objc func tipViewButtonDismissButtonTapped() {
        tipView.animateYPosition(target: tipView, targetPosition: view.frame.size.height+300, completion: { (action) in
            self.tipView.removeFromSuperview()
            self.sudokuView.removeGestureRecognizer(self.singleTapGestureRecognizer)
            self.sudokuView.isUserInteractionEnabled = true
        })
    }
}
