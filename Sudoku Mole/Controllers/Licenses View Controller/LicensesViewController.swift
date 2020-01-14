//
//  LicensesViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/29.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit

class LicensesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        licenseView.layer.cornerRadius = 20
        licenseView.fadeOut(object: licenseView, withDuration: 0.3)
        dummyView.frame = self.view.bounds
        dummyView.backgroundColor = .clear
        licenseTextView.attributedText = licenseText()
        
        view.addSubview(dummyView)
        view.bringSubviewToFront(licenseView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        tap.cancelsTouchesInView = false
        dummyView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    @IBOutlet weak var licenseView: UIView!
    @IBOutlet weak var licenseTextView: UITextView!
    
    @IBAction func dismissTapped(_ sender: Any) {
        dismissSelf()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let dummyView = UIView()
    let about = "About SUDOKU MOLE\n\n\n".localized()
    let copyright = "Copyright\n\n".localized()
    let sudoku = "SUDOKU MOLE is distributed by Apple App Store. SUDOKU MOLE is developed by COCHIPCHO Limited.\nSUDOKU MOLE and its content is copryright of COCHIPCHO Limited. - © COCHIPCHO Limited.\nAll rights reserved.\n\n\n".localized()
    let license = "Licenses\n\n".localized()
    let licensesContent = "1. Luckiest Guy font\n\nLuckiest Guy is a friendly heavyweight sans-serif font inspired by custom hand lettered 1950's advertisements. Large and in charge, this offbeat, lovably legible font lends itself to all sorts of uses. Luckiest Guy is allowed to be distributed for commercial purpose for free. Luckiest Guy is licensed under Apache License, Version 2.0.\n\n2. Lottie\n\nPlease find at : https://lottiefiles.com/page/terms-and-conditions\n\n\n".localized()
    let version = "Sudoku Mole Version\n\n".localized()
    let versionNumber = "Version 1.0.0(9)\n\n\n".localized()
    let contact = "Contact\n\n".localized()
    let contactContent = "Please contact at : http://cochipcho.com".localized()
    
    func licenseText() -> NSMutableAttributedString {
        var text = NSMutableAttributedString()
        let slateGrey = #colorLiteral(red: 0.3246352971, green: 0.3530436754, blue: 0.3961455226, alpha: 1)
        let deepGrey = #colorLiteral(red: 0.5552752614, green: 0.5883629918, blue: 0.6401379704, alpha: 1)
        
        let boldAttribute = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 16.0)!, NSAttributedString.Key.foregroundColor: slateGrey] as [NSAttributedString.Key : Any]
        let mediumAttribute = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Medium", size: 14.0)!, NSAttributedString.Key.foregroundColor: slateGrey] as [NSAttributedString.Key : Any]
        let regularAttribute = [NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Regular", size: 14.0)!, NSAttributedString.Key.foregroundColor: deepGrey] as [NSAttributedString.Key : Any]
        
        let aboutAttribute = NSMutableAttributedString(string: about, attributes: boldAttribute)
        let copyrightAttribute = NSMutableAttributedString(string: copyright, attributes: mediumAttribute)
        let sudokuAttribute = NSMutableAttributedString(string: sudoku, attributes: regularAttribute)
        let licenseAttribute = NSMutableAttributedString(string: license, attributes: mediumAttribute)
        let licenseContentAttribute = NSMutableAttributedString(string: licensesContent, attributes: regularAttribute)
        let versionAttribute = NSMutableAttributedString(string: version, attributes: mediumAttribute)
        let versionNumberAttribute = NSMutableAttributedString(string: versionNumber, attributes: regularAttribute)
        let contactAttribute = NSMutableAttributedString(string: contact, attributes: mediumAttribute)
        let contactContentAttribute = NSMutableAttributedString(string: contactContent, attributes: regularAttribute)
        
        aboutAttribute.append(copyrightAttribute)
        aboutAttribute.append(sudokuAttribute)
        aboutAttribute.append(licenseAttribute)
        aboutAttribute.append(licenseContentAttribute)
        aboutAttribute.append(versionAttribute)
        aboutAttribute.append(versionNumberAttribute)
        aboutAttribute.append(contactAttribute)
        aboutAttribute.append(contactContentAttribute)
        
        text = aboutAttribute
        
        return text
    }

    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}
