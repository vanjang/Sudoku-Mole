//
//  PaddedButton.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2020/01/21.
//  Copyright © 2020 cochipcho. All rights reserved.
//

import Foundation
import UIKit

// For keypad 1 only
class KeypadButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()

        let screenSize: CGRect = UIScreen.main.bounds
        
        if screenSize.width >= 414 {
            titleLabel?.frame = CGRect(x: (frame.width/2)-38, y: bounds.origin.y, width: frame.width, height: bounds.size.height)
        } else {
            titleLabel?.frame = CGRect(x: (frame.width/2)-35, y: bounds.origin.y, width: frame.width, height: bounds.size.height)
        }
    }
}
