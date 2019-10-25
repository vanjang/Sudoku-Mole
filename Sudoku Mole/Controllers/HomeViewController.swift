//
//  ViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 20/09/2019.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        mainButtonSetup()
        activateButtons()
        dummyButtonsHidden()
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "easySegue" : GameViewController.difficultyTitle = "EASY"
        case "normalSegue" : GameViewController.difficultyTitle = "NORMAL"
        case "hardSegue" : GameViewController.difficultyTitle = "HARD"
        case "expertSegue" : GameViewController.difficultyTitle = "EXPERT"
        case "continueSegue" : GameViewController.difficultyTitle = "TBD"
        default : break
        }
    }

    @IBOutlet weak var mainMenuSVOutlet: UIStackView!
    @IBOutlet weak var sudojiOutlet: UIImageView!
    @IBOutlet var dummyButtons: [UIButton]!

     @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {
        goBacktoStartButton()
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let startButton = UIButton()
    let easyButton = UIButton()
    let normalButton = UIButton()
    let hardButton = UIButton()
    let expertButton = UIButton()
    let continueButton = UIButton()
    let backButton = UIButton()
    let yellow = UIColor(red: 236.0 / 255.0, green: 224.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    let mint = UIColor(red: 198.0 / 255.0, green: 237.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    let pink = UIColor(red: 232.0 / 255.0, green: 161.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    
    func activateButtons() {
        easyButton.addTarget(self, action: #selector(easyButtonTapped), for: .touchUpInside)
        normalButton.addTarget(self, action: #selector(normalButtonTapped), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(hardButtonTapped), for: .touchUpInside)
        expertButton.addTarget(self, action: #selector(expertButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    func dummyButtonsHidden() {
        for button in dummyButtons {
            button.isHidden = true
            button.isEnabled = false
        }
    }
    
    func mainButtonSetup() {
        let attributedString = NSMutableAttributedString(string: "sudoku\nMole\nstart", attributes: [
            .font: UIFont(name: "LuckiestGuy-Regular", size: 45.0)!,
            .foregroundColor: UIColor(red: 236.0 / 255.0, green: 224.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0),
            .kern: -0.42
            ])
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 1.0, green: 201.0 / 255.0, blue: 188.0 / 255.0, alpha: 1.0), range: NSRange(location: 12, length: 5))

        startButton.setAttributedTitle(attributedString, for: .normal)
        startButton.titleLabel?.numberOfLines = 0
        startButton.titleLabel?.textAlignment = .center
        startButton.titleLabel?.lineBreakMode = .byWordWrapping
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        
        mainMenuSVOutlet.addArrangedSubview(startButton)
        
    }
    
    func goBacktoStartButton() {
        let buttons = [easyButton, normalButton, hardButton, expertButton, continueButton, backButton]
        for button in buttons {
            button.fadeIn(object: button, withDuration: 0.2)
            button.isHidden = true
        }
        startButton.isHidden = false
        startButton.fadeOut(object: startButton, withDuration: 0.2)
    }
    
    func difficultyButtonsSetup() {

        let attribute = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 30.0)!, NSMutableAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: yellow, NSAttributedString.Key.foregroundColor: yellow] as [NSAttributedString.Key : Any]
        let attributeForContinueButton = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 30.0)!, NSMutableAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue, NSAttributedString.Key.underlineColor: mint, NSAttributedString.Key.foregroundColor: mint] as [NSAttributedString.Key : Any]
        let attributeForArrow = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 50.0)!, NSAttributedString.Key.foregroundColor: pink] as [NSAttributedString.Key : Any]
        
        let easy = NSAttributedString(string: "EASY", attributes: attribute as [NSAttributedString.Key : Any])
        let normal = NSAttributedString(string: "NORMAL", attributes: attribute as [NSAttributedString.Key : Any])
        let hard = NSAttributedString(string: "HARD", attributes: attribute as [NSAttributedString.Key : Any])
        let expert = NSAttributedString(string: "EXPERT", attributes: attribute as [NSAttributedString.Key : Any])
        let continueGame = NSAttributedString(string: "CONTINUE GAME", attributes: attributeForContinueButton as [NSAttributedString.Key : Any])
        let back = NSAttributedString(string: "⬅︎", attributes: attributeForArrow as [NSAttributedString.Key : Any])
        
        easyButton.setAttributedTitle(easy, for: .normal)
        normalButton.setAttributedTitle(normal, for: .normal)
        hardButton.setAttributedTitle(hard, for: .normal)
        expertButton.setAttributedTitle(expert, for: .normal)
        continueButton.setAttributedTitle(continueGame, for: .normal)
        backButton.setAttributedTitle(back, for: .normal)
        
        mainMenuSVOutlet.addArrangedSubview(easyButton)
        mainMenuSVOutlet.addArrangedSubview(normalButton)
        mainMenuSVOutlet.addArrangedSubview(hardButton)
        mainMenuSVOutlet.addArrangedSubview(expertButton)
        mainMenuSVOutlet.addArrangedSubview(continueButton)
        mainMenuSVOutlet.addArrangedSubview(backButton)
    }
    
    @objc func startButtonTapped(sender: UIButton) {
        startButton.fadeIn(object: sender, withDuration: 0.2)
        startButton.isHidden = true
        difficultyButtonsSetup()
        let buttons = [easyButton, normalButton, hardButton, expertButton, continueButton, backButton]
        for button in buttons {
            button.fadeOut(object: button, withDuration: 0.2)
            button.isHidden = false
        }
    }
    
    @objc func easyButtonTapped(sender: UIButton) {
        easyButton.fadeOutIn(object: sender, withDuration: 0.2)
        easyButton.fadeOutIn(object: sender, withDuration: 0.2)
        let puzzle = appDelegate.sudoku
        puzzle.grid.gameDiff = "easy"
        performSegue(withIdentifier: "toPuzzle", sender: sender)
        let array = appDelegate.getPuzzles(puzzle.grid.gameDiff)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[random(array.count)], toughness: puzzle.grid.gameDiff)
    }
    
    @objc func normalButtonTapped(sender: UIButton) {
        normalButton.fadeOutIn(object: sender, withDuration: 0.2)
    }
    
    @objc func hardButtonTapped(sender: UIButton) {
        hardButton.fadeOutIn(object: sender, withDuration: 0.2)
        hardButton.fadeOutIn(object: sender, withDuration: 0.2)
        let puzzle = appDelegate.sudoku
        puzzle.grid.gameDiff = "hard"
        performSegue(withIdentifier: "toPuzzle", sender: sender)
        let array = appDelegate.getPuzzles(puzzle.grid.gameDiff)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[random(array.count)], toughness: puzzle.grid.gameDiff)
    }
    
    @objc func expertButtonTapped(sender: UIButton) {
        expertButton.fadeOutIn(object: sender, withDuration: 0.2)
    }
    
    @objc func continueButtonTapped(sender: UIButton) {
        continueButton.fadeOutIn(object: sender, withDuration: 0.2)
        let puzzle = appDelegate.sudoku
        let load = appDelegate.load
        print("\(String(puzzle.inProgress))")
        if puzzle.inProgress {
            performSegue(withIdentifier: "toPuzzle", sender: sender)
        } else if load != nil {
            appDelegate.sudoku.grid = load
            performSegue(withIdentifier: "toPuzzle", sender: sender)
        } else {
        let alert = UIAlertController(title: "Alert", message: "No Game in Progress & No Saved Games", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func backButtonTapped(sender: UIButton) {
        goBacktoStartButton()
    }
    
}
