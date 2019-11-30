//
//  Functions2.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController {
    func menuConsts() {
        // Page control
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        let pageControlCenterConstraints = NSLayoutConstraint(item: self.pageControl, attribute: .centerX, relatedBy: .equal, toItem: menuView, attribute: .centerX, multiplier: 1, constant: -10)
        let pageControlTopConstraints = NSLayoutConstraint(item: self.pageControl, attribute: .top, relatedBy: .equal, toItem: recordsContainerView, attribute: .bottom, multiplier: 1, constant: -55)
        recordViewSmoleImage.translatesAutoresizingMaskIntoConstraints = false
        let smoleRightConstraints = NSLayoutConstraint(item: recordViewSmoleImage, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1, constant: -3)
        let smoleTopConstraints = NSLayoutConstraint(item: recordViewSmoleImage, attribute: .top, relatedBy: .equal, toItem: recordsContainerView, attribute: .bottom, multiplier: 1, constant: -115)
        
        menuView.bringSubviewToFront(recordViewSmoleImage)
        self.menuView.addConstraints([pageControlTopConstraints, pageControlCenterConstraints, smoleRightConstraints, smoleTopConstraints])
        menuView.bringSubviewToFront(recordIndicatorButtonLeft)
        menuView.bringSubviewToFront(recordIndicatorButtonRight)
        
        // Record view buttons
        recordIndicatorButtonLeft.translatesAutoresizingMaskIntoConstraints = false
        let centerXRecordIndicatorButtonLeftConstraints = NSLayoutConstraint(item: recordIndicatorButtonLeft, attribute: .centerY, relatedBy: .equal, toItem: recordsContainerView, attribute: .centerY, multiplier: 1, constant: -30)
        let leftRecordIndicatorButtonLeftConstraints = NSLayoutConstraint(item: recordIndicatorButtonLeft, attribute: .left, relatedBy: .equal, toItem: menuView, attribute: .left, multiplier: 1, constant: 17)
        
        recordIndicatorButtonRight.translatesAutoresizingMaskIntoConstraints = false
        let centerXRecordIndicatorButtonRightConstraints = NSLayoutConstraint(item: recordIndicatorButtonRight, attribute: .centerY, relatedBy: .equal, toItem: recordsContainerView, attribute: .centerY, multiplier: 1, constant: -30)
        let rightRecordIndicatorButtonLeftConstraints = NSLayoutConstraint(item: recordIndicatorButtonRight, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1, constant: -17)
        self.menuView.addConstraints([centerXRecordIndicatorButtonLeftConstraints, leftRecordIndicatorButtonLeftConstraints, centerXRecordIndicatorButtonRightConstraints, rightRecordIndicatorButtonLeftConstraints])
        
        // Smole image
        smoleMenuImage.translatesAutoresizingMaskIntoConstraints = false
        let smoleImageBottomConstraints = NSLayoutConstraint(item: smoleMenuImage, attribute: .bottom, relatedBy: .equal, toItem: menuView, attribute: .bottom, multiplier: 1, constant: 0)
        let smoleImageLeftConstraints = NSLayoutConstraint(item: smoleMenuImage, attribute: .left, relatedBy: .equal, toItem: menuView, attribute: .left, multiplier: 1, constant: 0)
        smoleMenuImage.heightAnchor.constraint(equalTo: smoleMenuImage.widthAnchor, multiplier: 498/334).isActive = true
        smoleMenuImage.heightAnchor.constraint(equalTo: menuView.heightAnchor, multiplier: 3/5).isActive = true
        self.menuView.addConstraints([smoleImageBottomConstraints, smoleImageLeftConstraints])
    }
    
}

