//
//  Game VC Life.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController {
    func lifeCounter() {
        if lives.isEmpty {
            lifeRemained.text = "3"
        } else if lives.count == 1 {
            lifeRemained.text = "2"
        } else if lives.count == 2 {
            lifeRemained.text = "1"
        } else if lives.count == 3 {
            lifeRemained.text = "0"
        }
        self.view.layoutIfNeeded()
    }
}
