//
//  PauseViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/18.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        var y:CGFloat = 0.0
        if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "Simulator iPhone 8" || UIDevice.modelName == "Simulator iPhone 7" {
            y = 35.0
        } else {
            y = 20.0
        }
        let frame = CGRect(x: -self.view.frame.size.width, y: y, width: self.view.frame.size.width, height: self.view.frame.size.height*0.75
        )
        pauseImage.contentMode = .scaleAspectFill
        pauseImage.image = image
        pauseImage.frame = frame
        view.addSubview(pauseImage)
        pauseImage.animateXPosition(target: pauseImage, targetPosition: self.view.frame.origin.x-5)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBAction func pauseButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resumeTimer"), object: nil, userInfo: nil)
        pauseImage.animateXPosition(target: pauseImage, targetPosition: -self.view.frame.size.width)
        dismiss(animated: true, completion: nil)
    }
    
    let pauseImage = UIImageView()
    let image = UIImage(named: "smolePauseBlindTilt.png")
    
}
