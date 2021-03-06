//
//  ExtensionUIViewforAnimation.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 20/09/2019.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

// Animation
extension UIView {
    
    func fadeIn(object: UIView, withDuration: Double) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: withDuration) {
                object.alpha = 0.0
            }
        }
    }
    
    func fadeOut(object: UIView, withDuration: Double) {
        DispatchQueue.main.async {
            object.alpha = 0.0
            UIView.animate(withDuration: withDuration) {
                object.alpha = 1.0
            }
        }
    }
    
    func fadeOutIn(object: UIView, withDuration: Double) {
        DispatchQueue.main.async {
            object.alpha = 0.0
            UIView.animate(withDuration: withDuration, delay: 0, options: [], animations: {
                object.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func tracingViewFadeIn(object: UIView, withDuration: Double) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: withDuration) {
                object.alpha = 0.0
            }
        }
    }
    
    func tracingViewFadeOut(object: UIView, withDuration: Double) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: withDuration) {
                object.alpha = 0.5
            }
        }
    }
    
}
