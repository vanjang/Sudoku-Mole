//
//  MenuView.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

extension GameViewController {
    func makeMenuView() {
        let menuWidth = self.view.frame.width//*0.8
        let menuHeight = self.view.frame.height
        let frame = CGRect(x: self.view.frame.maxX, y: 0, width: menuWidth, height: menuHeight)
        menuView.frame = frame
        menuView.backgroundColor = #colorLiteral(red: 0.003636014182, green: 0.6047223806, blue: 0.3254223168, alpha: 1)//UIColor(red: 67/255, green: 152/255, blue: 90/255, alpha: 1)
    }
    
    func makeMenuButtons() {
        let recordButtonImage = UIImage(named: "menuMyrecordNormal.png")
        let selfInstructionButtonImage = UIImage(named: "menuSmoleIntroNormal.png")
        let iapButtonImage = UIImage(named: "menuItemNormal.png")
        let size = 33 as CGFloat
        let yAlignedWithBILabel = biOutlet.frame.origin.y+self.view.safeAreaInsets.top
        let dismissFrame = CGRect(x: view.frame.maxX-200, y: yAlignedWithBILabel, width: size, height: biOutlet.frame.size.height)
        let dismissImage = UIImage(named: "icSideClose.png")
        
        dismissButton.frame = dismissFrame
        dismissButton.setImage(dismissImage, for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        
        recordButton.setImage(recordButtonImage, for: .normal)
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        
        selfInstructionButton.setImage(selfInstructionButtonImage, for: .normal)
        selfInstructionButton.addTarget(self, action: #selector(selfInstructionButtonTapped), for: .touchUpInside)
        
        iapButton.setImage(iapButtonImage, for: .normal)
        iapButton.addTarget(self, action: #selector(iapButtonTapped), for: .touchUpInside)
    }
    
    func makeMenuStackview() {
        menuStackview.axis = .vertical
        menuStackview.distribution = .equalSpacing
        menuStackview.alignment = .center
        menuStackview.spacing = view.frame.size.height*0.0187//0//15//25
        menuStackview.translatesAutoresizingMaskIntoConstraints = false
        menuStackview.addArrangedSubview(recordButton)
        menuStackview.addArrangedSubview(selfInstructionButton)
        menuStackview.addArrangedSubview(iapButton)
    }
    
    func addMenuViewThenAnimate() {
        let menuWidth = self.view.frame.width//*0.8
        menuView.addSubview(dismissButton)
        menuView.addSubview(menuStackview)
        view.addSubview(menuView)
        view.animateXPosition(target: menuView, targetPosition: self.view.frame.maxX-(menuWidth*0.8))
    }
    
    func makeConstToStackView() {
        dummyView.frame.size.width = menuView.frame.size.width*0.82
        dummyView.backgroundColor = .clear
        menuView.addSubview(dummyView)
        
        let verticalConstraint = NSLayoutConstraint(item: menuStackview, attribute: .centerY, relatedBy: .equal, toItem: menuView, attribute: .centerY, multiplier: 1, constant: -15)
        let horizontalConstraint = NSLayoutConstraint(item: menuStackview, attribute: .centerX, relatedBy: .equal, toItem: dummyView, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraints([verticalConstraint, horizontalConstraint])
    }
    
    func makeFadeView() {
        let fadeWidth = self.view.frame.width
        let fadeHeight = self.view.frame.height
        let fadeFrame = CGRect(x: self.view.frame.minX, y: 0, width: fadeWidth, height: fadeHeight)
        fadeView.frame = fadeFrame
        fadeView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        view.addSubview(fadeView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(GameViewController.dismissButtonTapped))
        tap.cancelsTouchesInView = false
        fadeView.addGestureRecognizer(tap)
    }
    
    func makeMenuRewindButton() {
        let size = 33 as CGFloat
        let yAlignedWithBILabel = biOutlet.frame.origin.y+self.view.safeAreaInsets.top
        let menuRewindFrame = CGRect(x: CGFloat(8), y: yAlignedWithBILabel, width: size, height: biOutlet.frame.size.height)
        let rewind = UIImage(named: "icSideBack.png")
        
        menuRewindButton.frame = menuRewindFrame
        menuRewindButton.setImage(rewind, for: .normal)
        menuRewindButton.addTarget(self, action: #selector(menuRewindButtonTapped), for: .touchUpInside)
        menuView.addSubview(menuRewindButton)
    }
    
    func makeBannerCase() {
        bannerCase.addSubview(bannerView)
        let width = menuView.frame.size.width*0.72
        let height = width*0.286
        let x = (dummyView.frame.size.width-width)/2
        let y = menuView.bounds.maxY-height-20
        let frame = CGRect(x: x, y: y, width: width, height: height)
        
        bannerView.frame = frame
        bannerView.layer.cornerRadius = height/3
        
        let caseWidth = menuView.frame.size.width*0.70
        let caseFrame = CGRect(x: x, y: y, width: caseWidth, height: height)
        bannerCase.frame = caseFrame
        bannerCase.backgroundColor = .white
        bannerCase.layer.borderWidth = 0
        bannerCase.layer.cornerRadius = height/3
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        menuView.addSubview(bannerCase)
        
        let verticalConstraint = NSLayoutConstraint(item: bannerView!, attribute: .centerY, relatedBy: .equal, toItem: bannerCase, attribute: .centerY, multiplier: 1, constant: 0)
        let horizontalConstraint = NSLayoutConstraint(item: bannerView!, attribute: .centerX, relatedBy: .equal, toItem: bannerCase, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraints([verticalConstraint, horizontalConstraint])
    }
    
    @objc func leftButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reverseVC"), object: nil, userInfo: nil)
    }
    
    @objc func rightButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "forwardVC"), object: nil, userInfo: nil)
    }
    
    func makeRecordView() {
        // instantiating Page View
        embed(recordsPageVC, inParent: self, inView: recordsContainerView)
        // Setup record view background
        recordBGView.frame = menuView.bounds
        recordBGView.backgroundColor = #colorLiteral(red: 0.002215130022, green: 0.7956928015, blue: 1, alpha: 1)
        menuView.addSubview(recordBGView)
        menuView.sendSubviewToBack(recordBGView)
        
        // Record label setup
        recordLabel.backgroundColor = .clear
        recordLabel.text = "MY RECORDS".localized()
        recordLabel.contentMode = .center
        recordLabel.textAlignment = .center
        recordLabel.frame.size.width = menuView.frame.size.width*0.5
        recordLabel.frame.size.height = dismissButton.frame.size.height
        recordLabel.frame.origin.x = (menuView.frame.size.width-recordLabel.frame.width)/2
        recordLabel.frame.origin.y = dismissButton.frame.origin.y+4
        recordLabel.font = UIFont(name: "LuckiestGuy-Regular", size: 28.0)
        recordLabel.textColor = #colorLiteral(red: 1, green: 0.9337611198, blue: 0.2692891061, alpha: 1)
        menuView.addSubview(recordLabel)
        
        self.recordsContainerView.backgroundColor = .clear
        self.menuView.addSubview(self.recordsContainerView)
        self.recordsContainerView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraints = NSLayoutConstraint(item: self.recordsContainerView, attribute: .top, relatedBy: .equal, toItem: self.recordLabel, attribute: .bottom, multiplier: 1, constant: -10)
        let bottomConstraints = NSLayoutConstraint(item: self.recordsContainerView, attribute: .bottom, relatedBy: .equal, toItem: superViewForConst(), attribute: constAttribute(), multiplier: 1, constant: constConstant())
        let leadingConstraints = NSLayoutConstraint(item: self.recordsContainerView, attribute: .leading, relatedBy: .equal, toItem: self.menuView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraints = NSLayoutConstraint(item: self.recordsContainerView, attribute: .trailing, relatedBy: .equal, toItem: self.menuView, attribute: .trailing, multiplier: 1, constant: 0)
        self.menuView.addConstraints([topConstraints, bottomConstraints, leadingConstraints, trailingConstraints])
        
        // Foward/Reward button setup
        let leftButtonImage = UIImage(named: "boardLeft.png")
        let rightButtonImage = UIImage(named: "boardRight.png")
        recordIndicatorButtonLeft.setImage(leftButtonImage, for: .normal)
        recordIndicatorButtonLeft.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        
        recordIndicatorButtonRight.setImage(rightButtonImage, for: .normal)
        recordIndicatorButtonRight.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        
        self.menuView.addSubview(self.recordIndicatorButtonLeft)
        self.menuView.addSubview(self.recordIndicatorButtonRight)
        
        self.menuView.bringSubviewToFront(self.recordIndicatorButtonLeft)
        self.menuView.bringSubviewToFront(self.recordIndicatorButtonRight)
        
        // Page control setup
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.tintColor = .black
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.02486280166, green: 0.484606564, blue: 0.2699485421, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0.9337611198, blue: 0.2692891061, alpha: 1)
        
        self.menuView.addSubview(pageControl)
        
        // Smole setup
        let smoleImage = UIImage(named: "menuMyrecordSmolenote.png")
        recordViewSmoleImage.image = smoleImage
        menuView.addSubview(recordViewSmoleImage)
    }
    
    func makeInstructionView() {
        var frame = CGRect()
        
        if !appDelegate.hasADRemoverBeenBought() {
            frame = CGRect(x: self.view.bounds.origin.x, y: (self.view.bounds.origin.y)+(dismissButton.frame.maxY), width: self.view.frame.size.width, height: self.view.frame.size.height-(bannerCase.frame.size.height+30))
        } else {
            frame = CGRect(x: self.view.bounds.origin.x, y: (self.view.bounds.origin.y)+(dismissButton.frame.maxY), width: self.view.frame.size.width, height: self.view.frame.size.height-30)
        }
        
        instructionView.frame = frame
        instructionView.backgroundColor = .clear
        menuView.addSubview(instructionView)
        
        let image = UIImage(named: "menuSmoleIntroHi.png")
        smoleMenuImage.image = image
        smoleMenuImage.contentMode = .scaleAspectFit
        menuView.addSubview(smoleMenuImage)
        menuView.sendSubviewToBack(smoleMenuImage)
        
        let nameLabel = InsetLabel()
        let ageLabel = InsetLabel()
        let featureLabel1 = InsetLabel()
        let featureLabel2 = InsetLabel()
        let featureLabel3 = InsetLabel()
        let featureLabel4 = InsetLabel()
        let licensesButton = UIButton()
        
        let yellowAttribute = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 28.0)!, NSAttributedString.Key.foregroundColor: yellow] as [NSAttributedString.Key : Any]
        let mintAttribute = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 28.0)!, NSAttributedString.Key.foregroundColor: mint] as [NSAttributedString.Key : Any]
        
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
        
        let buttonImage = UIImage(named: "btnAbout.png")
        licensesButton.setImage(buttonImage, for: .normal)
        licensesButton.imageView?.contentMode = .center
        licensesButton.frame.size.width = 150
        licensesButton.frame.size.height = 150
        licensesButton.addTarget(self, action: #selector(licensesButtonTapped), for: .touchUpInside)
        instructionView.addSubview(licensesButton)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        stackView.spacing = 9
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(ageLabel)
        stackView.addArrangedSubview(featureLabel1)
        stackView.addArrangedSubview(featureLabel2)
        stackView.addArrangedSubview(featureLabel3)
        stackView.addArrangedSubview(featureLabel4)
        instructionView.addSubview(stackView)
        
        let topConstraint = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: menuView, attribute: .top, multiplier: 1, constant: instructionView.frame.size.height*0.16)
        let horizontalConstraint = NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1, constant: -29)
        self.view.addConstraints([topConstraint, horizontalConstraint])
        
        licensesButton.translatesAutoresizingMaskIntoConstraints = false
        let buttonTopConstraint = NSLayoutConstraint(item: licensesButton, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1, constant: 25)
        let buttonRightConstraint = NSLayoutConstraint(item: licensesButton, attribute: .right, relatedBy: .equal, toItem: stackView, attribute: .right, multiplier: 1, constant: 0)
        self.view.addConstraints([buttonTopConstraint, buttonRightConstraint])
        
        if !appDelegate.hasADRemoverBeenBought() {
            bannerCase.superview?.bringSubviewToFront(bannerCase)
        }
    }
    
    @objc func licensesButtonTapped() {
        let licenseVC = storyboard?.instantiateViewController(withIdentifier: "LicenseVC") as? LicensesViewController
        licenseVC!.providesPresentationContextTransitionStyle = true
        licenseVC!.definesPresentationContext = true
        licenseVC!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        licenseVC!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(licenseVC!, animated: true, completion: nil)
    }
    
    
    // Page View Container view constraints
    func superViewForConst() -> UIView {
        var returningView = UIView()
        
        if !appDelegate.hasADRemoverBeenBought() {
            returningView = bannerCase
        } else {
            returningView = menuView
        }
        
        return returningView
    }
    
    func constAttribute() -> NSLayoutConstraint.Attribute {
        var attribute = NSLayoutConstraint.Attribute.top
        
        if !appDelegate.hasADRemoverBeenBought() {
            attribute = .top
        } else {
            attribute = .bottom
        }
        return attribute
    }
    
    func constConstant() -> CGFloat {
        var constant = 0.0
        
        if !appDelegate.hasADRemoverBeenBought() {
            constant = -20
        } else {
            constant = -60
        }
        return CGFloat(constant)
    }
    
    func makeIAPView() {
        // Record label setup
        shopLabel.backgroundColor = .clear
        shopLabel.text = "SHOP".localized()
        shopLabel.contentMode = .center
        shopLabel.textAlignment = .center
        shopLabel.frame.size.width = menuView.frame.size.width*0.5
        shopLabel.frame.size.height = dismissButton.frame.size.height
        shopLabel.frame.origin.x = (menuView.frame.size.width-recordLabel.frame.width)/2
        shopLabel.frame.origin.y = dismissButton.frame.origin.y+4
        shopLabel.font = UIFont(name: "LuckiestGuy-Regular", size: 28.0)
        shopLabel.textColor = #colorLiteral(red: 1, green: 0.9337611198, blue: 0.2692891061, alpha: 1)
        menuView.addSubview(shopLabel)
        
        iapView.backgroundColor = .clear
        menuView.addSubview(iapView)
        iapView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraints = NSLayoutConstraint(item: self.iapView, attribute: .top, relatedBy: .equal, toItem: self.shopLabel, attribute: .bottom, multiplier: 1, constant: -10)
        let bottomConstraints = NSLayoutConstraint(item: self.iapView, attribute: .bottom, relatedBy: .equal, toItem: superViewForConst(), attribute: constAttribute(), multiplier: 1, constant: constConstant())
        let leadingConstraints = NSLayoutConstraint(item: self.iapView, attribute: .leading, relatedBy: .equal, toItem: self.menuView, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraints = NSLayoutConstraint(item: self.iapView, attribute: .trailing, relatedBy: .equal, toItem: self.menuView, attribute: .trailing, multiplier: 1, constant: 0)
        self.menuView.addConstraints([topConstraints, bottomConstraints, leadingConstraints, trailingConstraints])
        
        let iapStackView = UIStackView()
        iapStackView.axis = .vertical
        iapStackView.distribution = .fillProportionally
        iapStackView.alignment = .center
        iapStackView.spacing = view.frame.size.height*0.07
        iapView.addSubview(iapStackView)
        
        iapStackView.translatesAutoresizingMaskIntoConstraints = false
        let verticalConstraints = NSLayoutConstraint(item: iapStackView, attribute: .centerY, relatedBy: .equal, toItem: iapView, attribute: .centerY, multiplier: 1, constant: view.frame.size.height*0.02)
        let horizontalConstraints = NSLayoutConstraint(item: iapStackView, attribute: .centerX, relatedBy: .equal, toItem: iapView, attribute: .centerX, multiplier: 1, constant: 0)
        self.menuView.addConstraints([horizontalConstraints, verticalConstraints])
        
        let iapHorizontalStackView = UIStackView()
        iapHorizontalStackView.axis = .horizontal
        iapHorizontalStackView.distribution = .fillEqually
        iapHorizontalStackView.alignment = .center
        iapHorizontalStackView.spacing = 55
        
        let chanceStackView = UIStackView()
        chanceStackView.axis = .vertical
        chanceStackView.distribution = .fillProportionally
        chanceStackView.alignment = .center
        chanceStackView.spacing = 5
        chanceStackView.contentMode = .center
        
        let adFreeStackView = UIStackView()
        adFreeStackView.axis = .vertical
        adFreeStackView.distribution = .fillProportionally
        adFreeStackView.alignment = .center
        adFreeStackView.spacing = 5
        adFreeStackView.contentMode = .center
        
        let chanceImageView = UIImageView()
        let chanceImage = UIImage(named: "item5Chance.png")
        chanceImageView.image = chanceImage
        chanceImageView.contentMode = .scaleAspectFit
        
        let adFreeImageView = UIImageView()
        let adFreeImage = UIImage(named: "itemClearAd.png")
        adFreeImageView.image = adFreeImage
        adFreeImageView.contentMode = .scaleAspectFit
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        var chanceTitle = String()
        var chancePrice = String()
        if productsArray.indices.contains(1) {
            chanceTitle =  productsArray[1].localizedTitle+"\n"
            formatter.locale = productsArray[1].priceLocale
            chancePrice = formatter.string(from: productsArray[1].price)!
        } else {
            chanceTitle = "5 CHANCE\n"
            chancePrice = "-"
        }
        
        let chanceAttributes = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 14.0) as Any, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9364990592, green: 0.3447085321, blue: 0.3428477943, alpha: 1)] as [NSAttributedString.Key : Any]
        let chanceMutableAttributedString = NSMutableAttributedString(string: chanceTitle, attributes: chanceAttributes as [NSAttributedString.Key : Any])
        let chance2Attributes = [ NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 24.0)!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9364990592, green: 0.3447085321, blue: 0.3428477943, alpha: 1)] as [NSAttributedString.Key : Any]
        let chance2MutableAttributes = NSMutableAttributedString(string: chancePrice, attributes: chance2Attributes )
        chanceMutableAttributedString.append(chance2MutableAttributes)
        
        let chanceLabel = PaddedLabel()
        chanceLabel.frame.size.width = 200
        chanceLabel.frame.size.height = 160
        chanceLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9337611198, blue: 0.2692891061, alpha: 1)
        chanceLabel.numberOfLines = 0
        chanceLabel.contentMode = .center
        chanceLabel.textAlignment = .center
        chanceLabel.clipsToBounds = true
        chanceLabel.layer.cornerRadius = 22
        chanceLabel.adjustsFontSizeToFitWidth = true
        chanceLabel.attributedText = chanceMutableAttributedString
        
        var adFreeTitle = String()
        var adFreePrice = String()
        if productsArray.indices.contains(0) {
            adFreeTitle =  productsArray[0].localizedTitle+"\n"
            formatter.locale = productsArray[0].priceLocale
            adFreePrice = formatter.string(from: productsArray[0].price)!
        } else {
            adFreeTitle = "CLEAR AD\n"
            adFreePrice = "-"
        }
        
        let adFreeAttributes = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 14.0) as Any, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9364990592, green: 0.3447085321, blue: 0.3428477943, alpha: 1)] as [NSAttributedString.Key : Any]
        let adFreeMutableAttributedString = NSMutableAttributedString(string: adFreeTitle, attributes: adFreeAttributes as [NSAttributedString.Key : Any])
        let adFree2Attributes = [ NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 24.0)!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.9364990592, green: 0.3447085321, blue: 0.3428477943, alpha: 1)] as [NSAttributedString.Key : Any]
        let adFree2MutableAttributes = NSMutableAttributedString(string: adFreePrice, attributes: adFree2Attributes )
        adFreeMutableAttributedString.append(adFree2MutableAttributes)
        
        let adFreeLabel = PaddedLabel()
        adFreeLabel.frame.size.width = 200
        adFreeLabel.frame.size.height = 160
        adFreeLabel.backgroundColor = #colorLiteral(red: 1, green: 0.9337611198, blue: 0.2692891061, alpha: 1)
        adFreeLabel.numberOfLines = 0
        adFreeLabel.contentMode = .center
        adFreeLabel.textAlignment = .center
        adFreeLabel.clipsToBounds = true
        adFreeLabel.layer.cornerRadius = 22
        adFreeLabel.adjustsFontSizeToFitWidth = true
        adFreeLabel.attributedText = adFreeMutableAttributedString
        
        chanceStackView.addArrangedSubview(chanceImageView)
        chanceStackView.addArrangedSubview(chanceLabel)
        adFreeStackView.addArrangedSubview(adFreeImageView)
        adFreeStackView.addArrangedSubview(adFreeLabel)
        
        iapHorizontalStackView.addArrangedSubview(chanceStackView)
        iapHorizontalStackView.addArrangedSubview(adFreeStackView)
        
        let iapSmoleImageView = UIImageView()
        let iapSmoleImage = UIImage(named: "smoleShop.png")
        iapSmoleImageView.image = iapSmoleImage
        iapSmoleImageView.contentMode = .scaleAspectFit
        
        iapStackView.alignment = .center
        iapStackView.addArrangedSubview(iapHorizontalStackView)
        iapStackView.addArrangedSubview(iapSmoleImageView)
        
        let chanceButton = UIButton()
        chanceButton.backgroundColor = .clear
        chanceButton.alpha = 0.5
        chanceButton.addTarget(self, action: #selector(getChanceButtonTapped), for: .touchUpInside)
        iapView.addSubview(chanceButton)
        iapView.bringSubviewToFront(chanceButton)
        
        chanceButton.translatesAutoresizingMaskIntoConstraints = false
        let chanceTopConstraint = NSLayoutConstraint(item: chanceButton, attribute: .top, relatedBy: .equal, toItem: chanceImageView, attribute: .top, multiplier: 1, constant: 0)
        let chanceLeftConstraint = NSLayoutConstraint(item: chanceButton, attribute: .left, relatedBy: .equal, toItem: chanceImageView, attribute: .left, multiplier: 1, constant: 0)
        let chanceRightConstraint = NSLayoutConstraint(item: chanceButton, attribute: .right, relatedBy: .equal, toItem: chanceImageView, attribute: .right, multiplier: 1, constant: 0)
        let chanceBottomConstraint = NSLayoutConstraint(item: chanceButton, attribute: .bottom, relatedBy: .equal, toItem: chanceLabel, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([chanceTopConstraint, chanceLeftConstraint, chanceRightConstraint, chanceBottomConstraint])
        
        let adFreeButton = UIButton()
        adFreeButton.backgroundColor = .clear
        adFreeButton.alpha = 0.5
        adFreeButton.addTarget(self, action: #selector(ADFreeButtonTapped), for: .touchUpInside)
        iapView.addSubview(adFreeButton)
        iapView.bringSubviewToFront(adFreeButton)
        
        adFreeButton.translatesAutoresizingMaskIntoConstraints = false
        let adFreeTopConstraint = NSLayoutConstraint(item: adFreeButton, attribute: .top, relatedBy: .equal, toItem: adFreeImageView, attribute: .top, multiplier: 1, constant: 0)
        let adFreeLeftConstraint = NSLayoutConstraint(item: adFreeButton, attribute: .left, relatedBy: .equal, toItem: adFreeImageView, attribute: .left, multiplier: 1, constant: 0)
        let adFreeRightConstraint = NSLayoutConstraint(item: adFreeButton, attribute: .right, relatedBy: .equal, toItem: adFreeImageView, attribute: .right, multiplier: 1, constant: 0)
        let adFreeBottomConstraint = NSLayoutConstraint(item: adFreeButton, attribute: .bottom, relatedBy: .equal, toItem: adFreeLabel, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraints([adFreeTopConstraint, adFreeLeftConstraint, adFreeRightConstraint, adFreeBottomConstraint])
        
        if !appDelegate.hasADRemoverBeenBought() {
            bannerCase.superview?.bringSubviewToFront(bannerCase)
        }
    }
}
