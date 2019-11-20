//
//  CustomAlertViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/29.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit

class DialogLabel: UILabel {
    let topInset = CGFloat(15)
    let bottomInset = CGFloat(0)
    let leftInset = CGFloat(0)
    let rightInset = CGFloat(0)

    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}


protocol GameViewControllerDelegate: AnyObject {
    func customAlertController(title: String, message: String, option: DialogOption)
    func customAction1(title: String, action: ((Any) -> Void)!)
    func customAction2(title: String, action: ((Any) -> Void)!)
    func customAction3(title: String, action: ((Any) -> Void)!)
}

enum DialogOption {
    case oneButton
    case twoButtons
    case threeButtons
}

class CustomAlertViewController: UIViewController, GameViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSwitcher()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        viewSwitcher()
        buttonSetup()
        buttonRemover()
        animateTwoBttnView()
        animateThreeBttnView()
        
        twoButtonMessage.frame = CGRect(x: 20, y: 20, width: 200, height: 200)
        twoButtonMessage.sizeToFit()
        twoButtonMessage.frame = CGRect(x: 20, y: 20, width: 200, height: 200)
        twoButtonMessage.sizeToFit()
    }

    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func viewSwitcher() {
        twoBttnAlertView.isHidden = viewReverseSwitch
        threeBttnAlertView.isHidden = !viewReverseSwitch
    }
    
    		
    
    
    func buttonSetup() {
        let grey = #colorLiteral(red: 0.9183209538, green: 0.9375432134, blue: 0.9589710832, alpha: 1)
        let skyBlue = #colorLiteral(red: 0.8421699405, green: 0.9555736184, blue: 1, alpha: 1)
        let pink = #colorLiteral(red: 1, green: 0.8663414121, blue: 0.8334389329, alpha: 1)
        let mint = #colorLiteral(red: 0.7501283288, green: 0.9766417146, blue: 0.8720756173, alpha: 1)
        
        print("aaa")
        twoBttnLeftBttn.setBackgroundColor(grey, for: .normal)
        twoBttnLeftBttn.setBackgroundColor(mint, for: .highlighted)
        twoBttnRightBttn.setBackgroundColor(grey, for: .normal)
        twoBttnRightBttn.setBackgroundColor(pink, for: .highlighted)

        threeBttnTopBttn.setBackgroundColor(grey, for: .normal)
        threeBttnTopBttn.setBackgroundColor(mint, for: .highlighted)
        threeBttnMidBttn.setBackgroundColor(grey, for: .normal)
        threeBttnMidBttn.setBackgroundColor(skyBlue, for: .highlighted)
        threeBttnBttmBttn.setBackgroundColor(grey, for: .normal)
        threeBttnBttmBttn.setBackgroundColor(pink, for: .highlighted)
        
        
  
        
    }
    
    
    @IBOutlet weak var twoBttnAlertView: UIView!
    @IBOutlet weak var twoBttnTitle: UILabel!
    @IBOutlet weak var twoButtonMessage: UILabel!
    @IBOutlet weak var twoBttnLeftBttn: UIButton!
    @IBOutlet weak var twoBttnRightBttn: UIButton!
    @IBAction func twoBttnLeftBttnTapped(_ sender: UIButton) {
        action1(action: action1)
    }
    @IBAction func twoBttnRightBttnTapped(_ sender: UIButton) {
        action2(action: action2)
    }
    
    @IBOutlet weak var threeBttnAlertView: UIView!
    @IBOutlet weak var threeBttnTitle: UILabel!
    @IBOutlet weak var threeButtonMessage: UILabel!
    @IBOutlet weak var threeBttnTopBttn: UIButton!
    @IBOutlet weak var threeBttnMidBttn: UIButton!
    @IBOutlet weak var threeBttnBttmBttn: UIButton!
    @IBAction func threeBttnTopBttnTapped(_ sender: UIButton) {
        action1(action: action1)
    }
    @IBAction func threeBttnMidBttnTapped(_ sender: UIButton) {
        action2(action: action2)
    }
    @IBAction func threeBttnBttmBttnTapped(_ sender: UIButton) {
        action3(action: action3)
    }
    
    var viewReverseSwitch = true
    var isOneBttnViewOn = Bool()
    var dialogTitle: String = ""
    var dialogMessage: String = ""
    var action1: ((Any) -> Void)?
    var action1Title = ""
    var action2: ((Any) -> Void)?
    var action2Title = ""
    var action3: ((Any) -> Void)?
    var action3Title = ""
    var dialogOption: DialogOption = .twoButtons {
        didSet {
            switch dialogOption {
            case .oneButton :
                viewReverseSwitch = false
                isOneBttnViewOn = true
            case .twoButtons :
                viewReverseSwitch = false
                isOneBttnViewOn = false
            case .threeButtons :
                viewReverseSwitch = true
            }
        }
    }
    
    func buttonRemover(){
        twoBttnRightBttn.isHidden = isOneBttnViewOn
    }
    
    func customAlertController(title: String, message: String, option: DialogOption) {
        dialogTitle = title
        dialogMessage = message
        dialogOption = option
    }
    
    func animateTwoBttnView() {
        twoBttnTitle.text = dialogTitle
        twoButtonMessage.text = dialogMessage
        twoBttnLeftBttn.setTitle(action1Title, for: .normal)
        twoBttnRightBttn.setTitle(action2Title, for: .normal)
        twoBttnAlertView.alpha = 0
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.twoBttnAlertView.alpha = 1.0
        })
    }
    
    func animateThreeBttnView() {
        threeBttnAlertView.alpha = 0
        threeBttnTitle.text = dialogTitle
        threeButtonMessage.text = dialogMessage
        threeBttnTopBttn.setTitle(action1Title, for: .normal)
        threeBttnMidBttn.setTitle(action2Title, for: .normal)
        threeBttnBttmBttn.setTitle(action3Title, for: .normal)
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.threeBttnAlertView.alpha = 1.0
        })
    }
    
    func customAction1(title: String, action: ((Any) -> Void)!) {
        self.action1Title = title
        self.action1 = action
    }
    
    func customAction2(title: String, action: ((Any) -> Void)!) {
        self.action2Title = title
        self.action2 = action
    }
    
    func customAction3(title: String, action: ((Any) -> Void)!) {
        self.action3Title = title
        self.action3 = action
    }
    
    func action1(action:((Any) -> Void)!) {
        action!(action!)
    }
    
    func action2(action:((Any) -> Void)!) {
        action!(action!)
    }
    
    func action3(action:((Any) -> Void)!) {
        action!(action!)// ?? nil!)
    }

}
