//
//  UISetup.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController {
    func makeTipView() {
        let width = self.view.frame.size.width*0.88
        let height = width*0.50
        let dismissedFrame = CGRect(x: (view.frame.size.width-width)/2, y: view.frame.size.height+300, width: width, height: height)
        tipView.frame = dismissedFrame
        tipView.backgroundColor = #colorLiteral(red: 0.9364990592, green: 0.3447085321, blue: 0.3428477943, alpha: 1)
        tipView.layer.cornerRadius = 29
        view.addSubview(tipView)
        tipView.addSubview(tipLabel)
        
        tipLabel.text = "Tap the input field twice to delete the number you entered.".localized()
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
    
//    func makeIAPTipView() {
//        let width = self.view.frame.size.width*0.88
//        let height = width*0.50
//        
//        let dismissedFrame = CGRect(x: (view.frame.size.width-width)/2, y: view.frame.size.height+300, width: width, height: height)
//        IAPtipView.frame = dismissedFrame
//        IAPtipView.backgroundColor = #colorLiteral(red: 0.9364990592, green: 0.3447085321, blue: 0.3428477943, alpha: 1)
//        IAPtipView.layer.cornerRadius = 29
//        view.addSubview(IAPtipView)
//        IAPtipView.addSubview(IAPtipLabel)
//        
//        IAPtipLabel.text = "You can use chances to know the answer! Please note chance may include \"Blank\"!".localized()
//        IAPtipLabel.numberOfLines = 0
//        IAPtipLabel.textColor = .white
//        IAPtipLabel.font = UIFont(name: "SFProDisplay-Regular", size: 18)
//        IAPtipLabel.contentMode = .topLeft
//        IAPtipLabel.textAlignment = .left
//        
//        IAPtipLabel.translatesAutoresizingMaskIntoConstraints = false
//        let leftConstraint = NSLayoutConstraint(item: IAPtipLabel, attribute: .left, relatedBy: .equal, toItem: IAPtipView, attribute: .left, multiplier: 1, constant: 20)
//        let rightConstraint = NSLayoutConstraint(item: IAPtipLabel, attribute: .right, relatedBy: .equal, toItem: IAPtipView, attribute: .right, multiplier: 1, constant: -width*0.38)
//        let topConstraint = NSLayoutConstraint(item: IAPtipLabel, attribute: .top, relatedBy: .equal, toItem: IAPtipView, attribute: .top, multiplier: 1, constant: 0)
//        let bottomConstraint = NSLayoutConstraint(item: IAPtipLabel, attribute: .bottom, relatedBy: .equal, toItem: IAPtipView, attribute: .bottom, multiplier: 1, constant: -tipView.frame.size.height/3)
//        self.IAPtipView.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
//        
//        IAPtipViewDismissImage = UIImage(named: "tooltipClose.png")!
//        IAPtipViewDismissButton.setImage(IAPtipViewDismissImage, for: .normal)
//        IAPtipViewDismissButton.frame.size.width = 20
//        IAPtipViewDismissButton.frame.size.height = 20
//        IAPtipViewDismissButton.addTarget(self, action: #selector(IAPtipViewButtonDismissButtonTapped), for: .touchUpInside)
//        IAPtipView.addSubview(IAPtipViewDismissButton)
//        
//        IAPtipViewDismissButton.translatesAutoresizingMaskIntoConstraints = false
//        let xRightConstraint = NSLayoutConstraint(item: IAPtipViewDismissButton, attribute: .right, relatedBy: .equal, toItem: IAPtipView, attribute: .right, multiplier: 1, constant: -15)
//        let xTopConstraint = NSLayoutConstraint(item: IAPtipViewDismissButton, attribute: .top, relatedBy: .equal, toItem: IAPtipView, attribute: .top, multiplier: 1, constant: 15)
//        self.IAPtipView.addConstraints([xRightConstraint, xTopConstraint])
//        
//        IAPtipSmoleImage = UIImage(named: "smoleNotice.png")!
//        IAPtipSmole.image = IAPtipSmoleImage
//        IAPtipSmole.contentMode = .scaleAspectFit
//        IAPtipView.addSubview(IAPtipSmole)
//        
//        IAPtipSmole.translatesAutoresizingMaskIntoConstraints = false
//        let smoleLeftConstraint = NSLayoutConstraint(item: IAPtipSmole, attribute: .left, relatedBy: .equal, toItem: IAPtipLabel, attribute: .right, multiplier: 1, constant: 0)
//        let smoleRightConstraint = NSLayoutConstraint(item: IAPtipSmole, attribute: .right, relatedBy: .equal, toItem: IAPtipView, attribute: .right, multiplier: 1, constant: -10)
//        let smoleTopConstraint = NSLayoutConstraint(item: IAPtipSmole, attribute: .top, relatedBy: .equal, toItem: IAPtipView, attribute: .top, multiplier: 1, constant: tipView.frame.size.height/3.5)
//        let smoleBottomConstraint = NSLayoutConstraint(item: IAPtipSmole, attribute: .bottom, relatedBy: .equal, toItem: IAPtipView, attribute: .bottom, multiplier: 1, constant: 0)
//        self.IAPtipView.addConstraints([smoleLeftConstraint, smoleRightConstraint, smoleTopConstraint, smoleBottomConstraint])
//        
//        IAPtipView.animateYPosition(target: IAPtipView, targetPosition: view.frame.size.height-height-((view.frame.size.width-width)/2), completion: nil)
//    }
    
    func keypadAutoResize() {
        for button in keypadCollection {
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.contentMode = .scaleToFill
            button.titleLabel?.baselineAdjustment = .alignBaselines
            button.titleLabel?.adjustsFontForContentSizeCategory = true
            if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "Simulator iPhone 8" || UIDevice.modelName == "Simulator iPhone 7" {
                button.titleLabel?.font = UIFont(name: "LuckiestGuy-Regular", size: 39.0)
            }
        }
    }
    
    func redoUndoStateSetup() {
        let undoNormal = UIImage(named: "btnBottomUndoNormal.png")
        let undoDisabled = UIImage(named: "btnBottomUndoDisabled.png")
        let undoPressed = UIImage(named: "btnBottomUndoPressed.png")
        let redoNormal = UIImage(named: "btnBottomRedoNormal.png")
        let redoDisabled = UIImage(named: "btnBottomRedoDisabled.png")
        let redoPressed = UIImage(named: "btnBottomRedoPressed.png")
        
        undoButtonOutlet.setImage(undoNormal, for: .normal)
        undoButtonOutlet.setImage(undoDisabled, for: .disabled)
        undoButtonOutlet.setImage(undoPressed, for: .highlighted)
        redoButtonOutlet.setImage(redoNormal, for: .normal)
        redoButtonOutlet.setImage(redoDisabled, for: .disabled)
        redoButtonOutlet.setImage(redoPressed, for: .highlighted)
    }
    
    func undoRedoButtonState() {
        let puzzle = self.appDelegate.sudoku
        if pencilOn {
            if puzzle.grid.pencilStack.isEmpty {
                undoButtonOutlet.isEnabled = false
            } else {
                undoButtonOutlet.isEnabled = true
            }
            
            if puzzle.grid.undonePencil.isEmpty {
                redoButtonOutlet.isEnabled = false
            } else {
                redoButtonOutlet.isEnabled = true
            }
        } else {
            if puzzle.grid.puzzleStack.isEmpty {
                undoButtonOutlet.isEnabled = false
            } else {
                undoButtonOutlet.isEnabled = true
            }
            
            if puzzle.grid.undonePuzzle.isEmpty {
                redoButtonOutlet.isEnabled = false
            } else {
                redoButtonOutlet.isEnabled = true
            }
        }
    }
    
    func instantiatingCustomAlertView() {
        customAlertView = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertViewController
        customAlertView.providesPresentationContextTransitionStyle = true
        customAlertView.definesPresentationContext = true
        customAlertView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.delegate = customAlertView
    }
    
    func biTitleSetup() {
        let attributedKeys = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 22.0)!, NSAttributedString.Key.foregroundColor: yellow] as [NSAttributedString.Key : Any]
        let attribute =  NSAttributedString(string: "SUDOKU\nMOLE".localized(), attributes: attributedKeys)
        
        biOutlet.attributedText = attribute
        biOutlet.layer.shadowColor = UIColor(red: 69.0/255.0, green: 99.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor
        biOutlet.layer.shadowOffset.height = 3
    }
    
    func timerSetup() {
        timerView.bringSubviewToFront(timerOutlet)
        timerView.bringSubviewToFront(timerSwitch)
        
        if let load = appDelegate.loadLocalStorage() {
            timerOutlet.text = load.savedOutletTime
            counter = load.savedTime
        } else {
            timerOutlet.text = "00:00:00"
        }
        timerStateInAction()
    }
    
    func boardSetup() {
        puzzleArea.clipsToBounds = true
        puzzleArea.backgroundColor = UIColor(red: 149.0 / 255.0, green: 79.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        
        for dummy in dummyCollection {
            dummy.clipsToBounds = true
            dummy.layer.cornerRadius = 13
            dummy.backgroundColor = UIColor(red: 124.0 / 255.0, green: 63.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
        }
        
        // Standard sizes
        let gridSize = sudokuView.bounds.width
        let gridOrigin = CGPoint(x: (sudokuView.bounds.width - gridSize), y: (sudokuView.bounds.height - gridSize))
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let sudokuViewSize = screenWidth - CGFloat(6)
        let delta = sudokuViewSize/3
        
        // Can't use loop due to view hierarchy
        let r1c1 = UIView(frame: CGRect(x: gridOrigin.x, y: gridOrigin.y, width: delta+6, height: delta+6))
        r1c1.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r1c1.layer.cornerRadius = 13
        let r1c2 = UIView(frame: CGRect(x: gridOrigin.x, y: gridOrigin.y+delta, width: delta+6, height: delta+6))
        r1c2.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r1c2.layer.cornerRadius = 13
        let r1c3 = UIView(frame: CGRect(x: gridOrigin.x, y: gridOrigin.y+(delta*2), width: delta+6, height: delta+6.5))
        r1c3.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r1c3.layer.cornerRadius = 13
        let height1 = UIView(frame: CGRect(x: gridOrigin.x, y: gridOrigin.y+10, width: delta+6, height: screenWidth+1.5))
        height1.backgroundColor = UIColor(red: 200/255, green: 187/255, blue: 130/255, alpha: 1)
        height1.layer.cornerRadius = 13
        let shadow1 = UIView(frame: CGRect(x: gridOrigin.x, y: gridOrigin.y+10, width: delta+6, height: screenWidth+7.5))
        shadow1.backgroundColor = #colorLiteral(red: 0, green: 0.512778461, blue: 0.2747916579, alpha: 1)//UIColor(red: 56/255, green: 129/255, blue: 76/255, alpha: 1)
        shadow1.layer.cornerRadius = 13
        
        let r2c1 = UIView(frame: CGRect(x: gridOrigin.x+delta, y: gridOrigin.y, width: delta+6, height: delta+6))
        r2c1.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r2c1.layer.cornerRadius = 13
        let r2c2 = UIView(frame: CGRect(x: gridOrigin.x+delta, y: gridOrigin.y+delta, width: delta+6, height: delta+6))
        r2c2.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r2c2.layer.cornerRadius = 13
        let r2c3 = UIView(frame: CGRect(x: gridOrigin.x+delta, y: gridOrigin.y+(delta*2), width: delta+6, height: delta+6.5))
        r2c3.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r2c3.layer.cornerRadius = 13
        let height2 = UIView(frame: CGRect(x: gridOrigin.x+delta, y: gridOrigin.y+10, width: delta+6, height: screenWidth+1.5))
        height2.backgroundColor = UIColor(red: 200/255, green: 187/255, blue: 130/255, alpha: 1)
        height2.layer.cornerRadius = 13
        let shadow2 = UIView(frame: CGRect(x: gridOrigin.x+delta, y: gridOrigin.y+10, width: delta+6, height: screenWidth+7.5))
        shadow2.backgroundColor = #colorLiteral(red: 0, green: 0.512778461, blue: 0.2747916579, alpha: 1)//UIColor(red: 56/255, green: 129/255, blue: 76/255, alpha: 1)
        shadow2.layer.cornerRadius = 13
        
        let r3c1 = UIView(frame: CGRect(x: gridOrigin.x+(delta*2), y: gridOrigin.y, width: delta+6, height: delta+6))
        r3c1.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r3c1.layer.cornerRadius = 13
        let r3c2 = UIView(frame: CGRect(x: gridOrigin.x+(delta*2), y: gridOrigin.y+delta, width: delta+6, height: delta+6))
        r3c2.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r3c2.layer.cornerRadius = 13
        let r3c3 = UIView(frame: CGRect(x: gridOrigin.x+(delta*2), y: gridOrigin.y+(delta*2), width: delta+6, height: delta+6.5))
        r3c3.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r3c3.layer.cornerRadius = 13
        let height3 = UIView(frame: CGRect(x: gridOrigin.x+(delta*2), y: gridOrigin.y+10, width: delta+6, height: screenWidth+1.5))
        height3.backgroundColor = UIColor(red: 200/255, green: 187/255, blue: 130/255, alpha: 1)
        height3.layer.cornerRadius = 13
        let shadow3 = UIView(frame: CGRect(x: gridOrigin.x+(delta*2), y: gridOrigin.y+10, width: delta+6, height: screenWidth+7.5))
        shadow3.backgroundColor = #colorLiteral(red: 0, green: 0.512778461, blue: 0.2747916579, alpha: 1)//UIColor(red: 56/255, green: 129/255, blue: 76/255, alpha: 1)
        shadow3.layer.cornerRadius = 13
        
        let fill = UIView(frame: CGRect(x: delta/2, y: delta/2, width: delta*2, height: delta*2))
        fill.backgroundColor = UIColor(red: 124.0 / 255.0, green: 63.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
        
        yellowView.addSubview(shadow1)
        yellowView.addSubview(shadow2)
        yellowView.addSubview(shadow3)
        
        yellowView.addSubview(height1)
        yellowView.addSubview(height2)
        yellowView.addSubview(height3)
        
        yellowView.addSubview(r1c1)
        yellowView.addSubview(r1c2)
        yellowView.addSubview(r1c3)
        
        yellowView.addSubview(r2c1)
        yellowView.addSubview(r2c2)
        yellowView.addSubview(r2c3)
        
        yellowView.addSubview(r3c1)
        yellowView.addSubview(r3c2)
        yellowView.addSubview(r3c3)
        
        yellowView.addSubview(fill)
    }
}
