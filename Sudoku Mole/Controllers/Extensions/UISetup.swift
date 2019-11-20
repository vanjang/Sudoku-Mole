//
//  UISetup.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

// interface setup
extension GameViewController {
 
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
        let attribute =  NSAttributedString(string: "SUDOKU\nMOLE", attributes: attributedKeys)
        
        biOutlet.attributedText = attribute
        biOutlet.layer.shadowColor = UIColor(red: 69.0/255.0, green: 99.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor
        biOutlet.layer.shadowOffset.height = 3
    }
    
    func timerSetup() {
        
        let timerImage = UIImage(named: "timerBg.png")
        let timerImageView = UIImageView(image: timerImage)
//        timerImageView.alpha = 1
        timerImageView.frame = timerView.bounds
        timerImageView.contentMode = .scaleToFill
//        if UIDevice.modelName == "Simulator iPhone 11 Pro Max" || UIDevice.modelName == "Simulator iPhone 8 Plus" || UIDevice.modelName == "Simulator iPhone 11"  {//"iPhone 11 Pro Max" { //Simulator iPhone 11 Pro Max
//            timerImageView.frame.size.width = timerView.frame.size.width * 1.07
//            timerImageView.frame.size.height = timerView.frame.size.height * 1.09
//        }
        
        timerView.addSubview(timerImageView)
        timerView.bringSubviewToFront(timerOutlet)
        timerView.bringSubviewToFront(timerSwitch)
        
        timerImageView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraints = NSLayoutConstraint(item: timerImageView, attribute: .top, relatedBy: .equal, toItem: timerView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraints = NSLayoutConstraint(item: timerImageView, attribute: .bottom, relatedBy: .equal, toItem: timerView, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstraints = NSLayoutConstraint(item: timerImageView, attribute: .leading, relatedBy: .equal, toItem: timerView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraints = NSLayoutConstraint(item: timerImageView, attribute: .trailing, relatedBy: .equal, toItem: timerView, attribute: .trailing, multiplier: 1, constant: 0)
        self.timerView.addConstraints([topConstraints, bottomConstraints, leadingConstraints, trailingConstraints])
        
        
//        timerView.layer.cornerRadius = timerView.frame.height/2
//        timerView.layer.borderWidth = 0.0
//        timerView.backgroundColor = .clear
        
        
        if let load = appDelegate.loadLocalStorage() {
            timerOutlet.text = load.savedOutletTime
            counter = load.savedTime
        } else {
            timerOutlet.text = "00:00:00"
        }
        
//        timerOulet.frame.inset(by: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0))
//        timerOutlet.layer.backgroundColor = UIColor.clear.cgColor

//        timerView.layer.shadowOffset = CGSize(width: 20.0, height: 15.0)
//        timerView.layer.shadowColor = UIColor(red: 105.0/255.0, green: 105.0/255.0, blue: 105.0/255.0, alpha: 0.5).cgColor
        
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
        
        // standard sizes
        let gridSize = sudokuView.bounds.width
        let gridOrigin = CGPoint(x: (sudokuView.bounds.width - gridSize), y: (sudokuView.bounds.height - gridSize))
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let sudokuViewSize = screenWidth - CGFloat(6)
        let delta = sudokuViewSize/3
        
        // can't use loop due to view hierarchy
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
