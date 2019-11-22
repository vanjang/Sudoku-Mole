//
//  HomeVCUISetup.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/31.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController {
    func makeStartButton() {
        startButton.frame.size.width = 250
        startButton.frame.size.height = 250
        
        let frame = CGRect(x: (self.view.bounds.size.width-startButton.frame.size.width)/2, y: self.view.bounds.size.height*0.10, width: startButton.frame.size.width, height: startButton.frame.size.width)
        let attributedString = NSMutableAttributedString(string: "sudoku\nMole\nstart", attributes: [.font: UIFont(name: "LuckiestGuy-Regular", size: 48.0)!, .foregroundColor: UIColor(red: 236.0 / 255.0, green: 224.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0), .kern: -0.42])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 1.0, green: 201.0 / 255.0, blue: 188.0 / 255.0, alpha: 1.0), range: NSRange(location: 12, length: 5))
        
        startButton.frame = frame
        startButton.setAttributedTitle(attributedString, for: .normal)
        startButton.titleLabel?.numberOfLines = 0
        startButton.titleLabel?.textAlignment = .center
        startButton.titleLabel?.lineBreakMode = .byWordWrapping
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        view.addSubview(startButton)
    }
    
    func makeLevelButtons() {
        let attribute = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 32.0)!, NSMutableAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: yellow, NSAttributedString.Key.foregroundColor: yellow] as [NSAttributedString.Key : Any]
        let attributeForContinueButton = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 32.0)!, NSMutableAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: mint, NSAttributedString.Key.foregroundColor: mint] as [NSAttributedString.Key : Any]

        let easy = NSAttributedString(string: "EASY".localized(), attributes: attribute as [NSAttributedString.Key : Any])
        let normal = NSAttributedString(string: "NORMAL".localized(), attributes: attribute as [NSAttributedString.Key : Any])
        let hard = NSAttributedString(string: "HARD".localized(), attributes: attribute as [NSAttributedString.Key : Any])
        let expert = NSAttributedString(string: "EXPERT".localized(), attributes: attribute as [NSAttributedString.Key : Any])
        let continueGame = NSAttributedString(string: "CONTINUE GAME".localized(), attributes: attributeForContinueButton as [NSAttributedString.Key : Any])
        
        easyButton.setAttributedTitle(easy, for: .normal)
        easyButton.frame.size.height = 20
        normalButton.setAttributedTitle(normal, for: .normal)
        normalButton.frame.size.height = 20
        hardButton.setAttributedTitle(hard, for: .normal)
        hardButton.frame.size.height = 20
        expertButton.setAttributedTitle(expert, for: .normal)
        expertButton.frame.size.height = 20
        continueButton.setAttributedTitle(continueGame, for: .normal)
        continueButton.frame.size.height = 20
        
        easyButton.addTarget(self, action: #selector(easyButtonTapped), for: .touchUpInside)
        normalButton.addTarget(self, action: #selector(normalButtonTapped), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(hardButtonTapped), for: .touchUpInside)
        expertButton.addTarget(self, action: #selector(expertButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        levelButtonsStackView.axis = .vertical
        levelButtonsStackView.distribution = .fill
        levelButtonsStackView.alignment = .center
        levelButtonsStackView.spacing = 8
        levelButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        levelButtonsStackView.addArrangedSubview(easyButton)
        levelButtonsStackView.addArrangedSubview(normalButton)
        levelButtonsStackView.addArrangedSubview(hardButton)
        levelButtonsStackView.addArrangedSubview(expertButton)
        levelButtonsStackView.addArrangedSubview(continueButton)
        view.addSubview(levelButtonsStackView)
        
        let topConstraint = NSLayoutConstraint(item: levelButtonsStackView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: view.frame.height*0.23)
        let horizontalConstraint = NSLayoutConstraint(item: levelButtonsStackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraints([topConstraint, horizontalConstraint])
    }
    
    func makeInstructionView() {
        nameLabel.frame.size.height = 20
        nameLabel.numberOfLines = 0
        nameLabel.sizeToFit()
        nameLabel.contentMode = .center

        ageLabel.frame.size.height = 100
        ageLabel.numberOfLines = 0
        ageLabel.baselineAdjustment = .alignBaselines//.none
        ageLabel.contentMode = .bottom //.center
        
        featureLabel1.frame.size.height = 20
        featureLabel1.numberOfLines = 0
        featureLabel1.sizeToFit()
        featureLabel1.contentMode = .center
        
        featureLabel2.frame.size.height = 20
        featureLabel2.numberOfLines = 0
        featureLabel2.sizeToFit()
        featureLabel2.contentMode = .center
        
        featureLabel3.frame.size.height = 20
        featureLabel3.numberOfLines = 0
        featureLabel3.sizeToFit()
        featureLabel3.contentMode = .center
        
        featureLabel4.frame.size.height = 20
        featureLabel4.numberOfLines = 0
        featureLabel4.sizeToFit()
        featureLabel4.contentMode = .center
        
        let yellowAttribute = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 30.0)!, NSAttributedString.Key.foregroundColor: yellow] as [NSAttributedString.Key : Any]
        let mintAttribute = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 30.0)!, NSAttributedString.Key.foregroundColor: mint] as [NSAttributedString.Key : Any]
        
        let nameMutableAttribute = NSMutableAttributedString()
        let ageMutableAttribute = NSMutableAttributedString()
        let featureMutableAttribute = NSMutableAttributedString()
        
        let nameAttributedString = NSAttributedString(string: "NAME : ".localized(), attributes: yellowAttribute)
        let smoleAttributedString = NSAttributedString(string: "SMOLE".localized(), attributes: mintAttribute)
        nameMutableAttribute.append(nameAttributedString)
        nameMutableAttribute.append(smoleAttributedString)
        nameLabel.attributedText = nameMutableAttribute
        
        let ageAttributedString = NSAttributedString(string: "AGE : ".localized(), attributes: yellowAttribute)
        let twoAttributedString = NSAttributedString(string: "2".localized(), attributes: mintAttribute)
        ageMutableAttribute.append(ageAttributedString)
        ageMutableAttribute.append(twoAttributedString)
        ageLabel.attributedText = ageMutableAttribute
        
        let feature1AttributedString = NSAttributedString(string: "FEATURE : ".localized(), attributes: yellowAttribute)
        let sleepyHeadAttributedString = NSAttributedString(string: "SLEEPYHEAD,".localized(), attributes: mintAttribute)
        featureMutableAttribute.append(feature1AttributedString)
        featureMutableAttribute.append(sleepyHeadAttributedString)
        featureLabel1.attributedText = featureMutableAttribute
        
        let feature2AttributedString = NSAttributedString(string: "VERY CALM, CURLY HAIR,".localized(), attributes: mintAttribute)
        featureLabel2.attributedText = feature2AttributedString
        
        let feature3AttributedString = NSAttributedString(string: "SMALL TEETH,".localized(), attributes: mintAttribute)
        featureLabel3.attributedText = feature3AttributedString
        
        let feature4AttributedString = NSAttributedString(string: "HEAVY EATER".localized(), attributes: mintAttribute)
        featureLabel4.attributedText = feature4AttributedString
     
        count.contentMode = .center
        count.baselineAdjustment = .none
        count.alpha = 0.0
        count.contentCompressionResistancePriority(for: .vertical)

        let attribute = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 80.0)!, NSAttributedString.Key.foregroundColor: yellow] as [NSAttributedString.Key : Any]
        let attributedString = NSAttributedString(string: "3", attributes: attribute)
        count.attributedText = attributedString
        
        instructionStackView.axis = .vertical
        instructionStackView.distribution = .fill//Equally//.fill
        instructionStackView.alignment = .center
        instructionStackView.spacing = 8
        instructionStackView.translatesAutoresizingMaskIntoConstraints = false
        instructionStackView.addArrangedSubview(nameLabel)
        instructionStackView.addArrangedSubview(ageLabel)
        instructionStackView.addArrangedSubview(featureLabel1)
        instructionStackView.addArrangedSubview(featureLabel2)
        instructionStackView.addArrangedSubview(featureLabel3)
        instructionStackView.addArrangedSubview(featureLabel4)
        view.addSubview(instructionStackView)
        
        let topConstraint = NSLayoutConstraint(item: instructionStackView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: view.frame.height*0.24)
        let horizontalConstraint = NSLayoutConstraint(item: instructionStackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraints([topConstraint, horizontalConstraint])
    }
//
//    func makeCount() {
//
//        let dummyView = UIView()
//        dummyView.backgroundColor = .clear
//        dummyView.frame.size.height = 60
//        instructionStackView.addArrangedSubview(dummyView)
//        instructionStackView.addArrangedSubview(count)
//
//        count.font = UIFont(name: "LuckiestGuy-Regular", size: 150.0)
//        DispatchQueue.main.async {
//            UIView.animate(withDuration: 0.1, delay: 0.5, options: .curveEaseIn, animations: {
//                self.count.alpha = 1.0
//            }) { (action) in
//                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
//                    self.count.alpha = 0.0
//                }) { (action) in
//                    UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
//                        self.count.text = "2"
//                        self.count.alpha = 1.0
//                    }) { (action) in
//                        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
//                            self.count.alpha = 0.0
//                        }) { (action) in
//                            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
//                                self.count.text = "1"
//                                self.count.alpha = 1.0
//                            }) { (action) in
//                                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: {
//                                    self.count.alpha = 0.0
//                                }) { (action) in
//                                    UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseIn, animations: {
//                                        let attribute = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 65.0)!, NSAttributedString.Key.foregroundColor: self.yellow] as [NSAttributedString.Key : Any]
//                                        let attributedString = NSAttributedString(string: "start!", attributes: attribute)
//                                        self.count.attributedText = attributedString
//                                        self.count.alpha = 1.0
//                                    }) { (action) in
//                                        if self.homeViewControllerTransition == .level {
//                                            self.startButton.isHidden = true
//                                            self.levelButtonsStackView.isHidden = false
//                                            self.instructionStackView.isHidden = true
//
//                                        } else if self.homeViewControllerTransition == .sudoji {
//                                            self.startButton.isHidden = true
//                                            self.levelButtonsStackView.isHidden = true
//                                            self.instructionStackView.isHidden = false
//                                        }
//                                        self.performSegue(withIdentifier: "toPuzzle", sender: self)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//}

func makeCount() {

    let dummyView = UIView()
    dummyView.backgroundColor = .clear
    dummyView.frame.size.height = 60
    instructionStackView.addArrangedSubview(dummyView)
    instructionStackView.addArrangedSubview(count)

    count.font = UIFont(name: "LuckiestGuy-Regular", size: 150.0)
    DispatchQueue.main.async {
        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.count.alpha = 1.0
        }) { (action) in
            UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseIn, animations: {
                self.count.alpha = 0.0
            }) { (action) in
                UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseIn, animations: {
                    self.count.text = "2"
                    self.count.alpha = 1.0
                }) { (action) in
                    UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseIn, animations: {
                        self.count.alpha = 0.0
                    }) { (action) in
                        UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseIn, animations: {
                            self.count.text = "1"
                            self.count.alpha = 1.0
                        }) { (action) in
                            UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseIn, animations: {
                                self.count.alpha = 0.0
                            }) { (action) in
                                UIView.animate(withDuration: 0.0, delay: 0.0, options: .curveEaseIn, animations: {
                                    let attribute = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 65.0)!, NSAttributedString.Key.foregroundColor: self.yellow] as [NSAttributedString.Key : Any]
                                    let attributedString = NSAttributedString(string: "start!", attributes: attribute)
                                    self.count.attributedText = attributedString
                                    self.count.alpha = 1.0
                                }) { (action) in
                                    if self.homeViewControllerTransition == .level {
                                        self.startButton.isHidden = true
                                        self.levelButtonsStackView.isHidden = false
                                        self.instructionStackView.isHidden = true

                                    } else if self.homeViewControllerTransition == .sudoji {
                                        self.startButton.isHidden = true
                                        self.levelButtonsStackView.isHidden = true
                                        self.instructionStackView.isHidden = false
                                    }
                                    self.performSegue(withIdentifier: "toPuzzle", sender: self)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
}
