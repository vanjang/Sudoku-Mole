//
//  DoubletapRemover.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/18.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit

class CustomTapGestureRecognizer: UITapGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        DispatchQueue.main.asyncAfter(deadline: .now() + tapMaxDelay) { [weak self] in
            if self?.state != UIGestureRecognizer.State.recognized {
                self?.state = UIGestureRecognizer.State.failed
            }
        }
    }
    
    let tapMaxDelay: Double = 0.5
}
