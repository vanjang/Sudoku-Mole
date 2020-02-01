//
//  GameSolved VC TipView.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2020/01/30.
//  Copyright © 2020 cochipcho. All rights reserved.
//

import Foundation
import UIKit

extension GameSolvedViewController {
    func makeTipView() {
        let width = self.view.frame.size.width*0.88
        let height = width*0.50
        let dismissedFrame = CGRect(x: (view.frame.size.width-width)/2, y: view.frame.size.height+300, width: width, height: height)
        tipView.frame = dismissedFrame
        tipView.backgroundColor = #colorLiteral(red: 0.9364990592, green: 0.3447085321, blue: 0.3428477943, alpha: 1)
        tipView.layer.cornerRadius = 29
        view.addSubview(tipView)
        tipView.addSubview(tipLabel)
        
        tipLabel.text = "Share your record with friends on SNS and get a free chance!🌟".localized()
        tipLabel.numberOfLines = 0
        tipLabel.textColor = .white
        tipLabel.font = UIFont(name: "SFProDisplay-Regular", size: 18)
        tipLabel.contentMode = .topLeft
        tipLabel.textAlignment = .left
        
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: tipLabel, attribute: .left, relatedBy: .equal, toItem: tipView, attribute: .left, multiplier: 1, constant: 20)
        let rightConstraint = NSLayoutConstraint(item: tipLabel, attribute: .right, relatedBy: .equal, toItem: tipView, attribute: .right, multiplier: 1, constant: -width*0.38)
        let topConstraint = NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: tipView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: tipLabel, attribute: .bottom, relatedBy: .equal, toItem: tipView, attribute: .bottom, multiplier: 1, constant: -tipView.frame.size.height/3)
        self.tipView.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        
        tipViewDismissImage = UIImage(named: "tooltipClose.png")!
        tipViewDismissButton.setImage(tipViewDismissImage, for: .normal)
        tipViewDismissButton.frame.size.width = 20
        tipViewDismissButton.frame.size.height = 20
        tipViewDismissButton.addTarget(self, action: #selector(tipViewButtonDismissButtonTapped), for: .touchUpInside)
        tipView.addSubview(tipViewDismissButton)
        
        tipViewDismissButton.translatesAutoresizingMaskIntoConstraints = false
        let xRightConstraint = NSLayoutConstraint(item: tipViewDismissButton, attribute: .right, relatedBy: .equal, toItem: tipView, attribute: .right, multiplier: 1, constant: -15)
        let xTopConstraint = NSLayoutConstraint(item: tipViewDismissButton, attribute: .top, relatedBy: .equal, toItem: tipView, attribute: .top, multiplier: 1, constant: 15)
        self.tipView.addConstraints([xRightConstraint, xTopConstraint])
        
        tipSmoleImage = UIImage(named: "smoleNotice.png")!
        tipSmole.image = tipSmoleImage
        tipSmole.contentMode = .scaleAspectFit
        tipView.addSubview(tipSmole)
        
        tipSmole.translatesAutoresizingMaskIntoConstraints = false
        let smoleLeftConstraint = NSLayoutConstraint(item: tipSmole, attribute: .left, relatedBy: .equal, toItem: tipLabel, attribute: .right, multiplier: 1, constant: 0)
        let smoleRightConstraint = NSLayoutConstraint(item: tipSmole, attribute: .right, relatedBy: .equal, toItem: tipView, attribute: .right, multiplier: 1, constant: -10)
        let smoleTopConstraint = NSLayoutConstraint(item: tipSmole, attribute: .top, relatedBy: .equal, toItem: tipView, attribute: .top, multiplier: 1, constant: tipView.frame.size.height/3.5)
        let smoleBottomConstraint = NSLayoutConstraint(item: tipSmole, attribute: .bottom, relatedBy: .equal, toItem: tipView, attribute: .bottom, multiplier: 1, constant: 0)
        self.tipView.addConstraints([smoleLeftConstraint, smoleRightConstraint, smoleTopConstraint, smoleBottomConstraint])
        
        tipView.animateYPosition(target: tipView, targetPosition: view.frame.size.height-height-((view.frame.size.width-width)/2), completion: nil)
    }
    
    func shouldTipView() -> Bool {
        let tipViewKey = "TipViewShownForGameSolvedVC"
        let userDefault = appDelegate.userDefault
        var count = Int()
        
        guard let value = userDefault.value(forKey: tipViewKey) as? Int else {
            userDefault.set(0, forKey: tipViewKey)
            return true
        }
        count = value + 1
        userDefault.set(count, forKey: tipViewKey)
        
        if value < 5 {
            return true
        } else {
            return false
        }
    }
    
    @objc func tipViewButtonDismissButtonTapped() {
        tipView.animateYPosition(target: tipView, targetPosition: view.frame.size.height+300, completion: { (action) in
            self.tipView.removeFromSuperview()
        })
    }
}
