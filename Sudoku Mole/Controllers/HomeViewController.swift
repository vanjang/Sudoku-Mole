//
//  ViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 20/09/2019.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit
import Lottie

class HomeViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeStartButton()
        makeLevelButtons()
        makeInstructionView()
        lottieForHomeVC() // will resume once Lottie file is handed over
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let attribute = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 80.0)!, NSAttributedString.Key.foregroundColor: yellow] as [NSAttributedString.Key : Any]
        let attributedString = NSAttributedString(string: "3", attributes: attribute)
        count.attributedText = attributedString
        count.isHidden = true
        homeViewControllerTransition = .start
    }
    
    var homeViewControllerTransition: HomeViewControllerTransition = .start {
        didSet {
            let leftX = self.view.frame.origin.x-view.frame.size.width
            let startButtonX = (self.view.frame.size.width-startButton.frame.size.width)/2
            let levelSVX = (self.view.frame.size.width-levelButtonsStackView.frame.size.width)/2
            let instructionX = (self.view.frame.size.width-instructionStackView.frame.size.width)/2
            
            switch homeViewControllerTransition {
            case .start :
                // Hide level buttons and instruction view & animate start button if it is not in the position
                startButton.isHidden = false
                levelButtonsStackView.isHidden = true
                instructionStackView.isHidden = true
                self.view.animateXPosition(target: startButton, targetPosition: startButtonX) { (action) in
                    self.startButton.isHidden = false
                }
            case .level :
                // Animate start button to left and hide
                self.view.animateXPosition(target: startButton, targetPosition: leftX) { a in
                    self.startButton.isHidden = true
                }
                // Show level buttons, place it at invisible start line, then animate to its position
                levelButtonsStackView.isHidden = false
                levelButtonsStackView.frame.origin.x = view.frame.maxX
                self.view.animateXPosition(target: levelButtonsStackView, targetPosition: levelSVX)
                startButton.layoutIfNeeded()
                levelButtonsStackView.layoutIfNeeded()
            case .sudoji :
                instructionStackView.isUserInteractionEnabled = false
                self.view.animateXPosition(target: levelButtonsStackView, targetPosition: leftX) { action in
                    self.levelButtonsStackView.isHidden = true
                }
                instructionStackView.frame.origin.x = view.frame.maxX
                instructionStackView.isHidden = false
                self.view.animateXPosition(target: instructionStackView, targetPosition: instructionX) { action in
                    self.count.isHidden = false
                    self.makeCount()
                }
                levelButtonsStackView.layoutIfNeeded()
                instructionStackView.layoutIfNeeded()
            }
        }
    }
    
    let startButton = UIButton()
    let easyButton = UIButton()
    let normalButton = UIButton()
    let hardButton = UIButton()
    let expertButton = UIButton()
    let continueButton = UIButton()
    var count = InsetLabel()
    let levelButtonsStackView = UIStackView()
    let instructionStackView = UIStackView()
    let nameLabel = InsetLabel()
    let ageLabel = InsetLabel()
    let featureLabel1 = InsetLabel()
    let featureLabel2 = InsetLabel()
    let featureLabel3 = InsetLabel()
    let featureLabel4 = InsetLabel()
    var customAlertView = CustomAlertViewController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let yellow = UIColor(red: 236.0 / 255.0, green: 224.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    let mint = UIColor(red: 198.0 / 255.0, green: 237.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    let pink = UIColor(red: 232.0 / 255.0, green: 161.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    var delegate: GameViewControllerDelegate?
    
    @IBOutlet weak var aniView: UIView!

    @objc func startButtonTapped(sender: UIButton) {
        homeViewControllerTransition = .level
    }

    @objc func easyButtonTapped(sender: UIButton) {
        deleteIfGameSaved()
        homeViewControllerTransition = .sudoji
        let puzzle = appDelegate.sudoku
        puzzle.grid.gameDiff = "Easy"
        let array = appDelegate.getPuzzles(puzzle.grid.gameDiff)
        let answerArray = appDelegate.getPuzzles(puzzle.grid.gameDiff+"Answers")
        let puzzleIndex = random(array.count)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[puzzleIndex], toughness: puzzle.grid.gameDiff)
        puzzle.grid.puzzleAnswer = puzzle.plistToPuzzle(plist: answerArray[puzzleIndex], toughness: puzzle.grid.gameDiff+"Answers")
    }
    
    @objc func normalButtonTapped(sender: UIButton) {
        deleteIfGameSaved()
        homeViewControllerTransition = .sudoji
        let puzzle = appDelegate.sudoku
        puzzle.grid.gameDiff = "Normal"
        let array = appDelegate.getPuzzles(puzzle.grid.gameDiff)
        let answerArray = appDelegate.getPuzzles(puzzle.grid.gameDiff+"Answers")
        let puzzleIndex = random(array.count)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[puzzleIndex], toughness: puzzle.grid.gameDiff)
        puzzle.grid.puzzleAnswer = puzzle.plistToPuzzle(plist: answerArray[puzzleIndex], toughness: puzzle.grid.gameDiff+"Answers")
    }
    
    @objc func hardButtonTapped(sender: UIButton) {
        deleteIfGameSaved()
        homeViewControllerTransition = .sudoji
        let puzzle = appDelegate.sudoku
        puzzle.grid.gameDiff = "Hard"
        let array = appDelegate.getPuzzles(puzzle.grid.gameDiff)
        let answerArray = appDelegate.getPuzzles(puzzle.grid.gameDiff+"Answers")
        let puzzleIndex = random(array.count)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[puzzleIndex], toughness: puzzle.grid.gameDiff)
        puzzle.grid.puzzleAnswer = puzzle.plistToPuzzle(plist: answerArray[puzzleIndex], toughness: puzzle.grid.gameDiff+"Answers")
    }
    
    @objc func expertButtonTapped(sender: UIButton) {
        deleteIfGameSaved()
        homeViewControllerTransition = .sudoji
        let puzzle = appDelegate.sudoku
        puzzle.grid.gameDiff = "Expert"
        let array = appDelegate.getPuzzles(puzzle.grid.gameDiff)
        let answerArray = appDelegate.getPuzzles(puzzle.grid.gameDiff+"Answers")
        let puzzleIndex = random(array.count)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[puzzleIndex], toughness: puzzle.grid.gameDiff)
        puzzle.grid.puzzleAnswer = puzzle.plistToPuzzle(plist: answerArray[puzzleIndex], toughness: puzzle.grid.gameDiff+"Answers")
    }
    
    func deleteIfGameSaved() {
        var load = appDelegate.load
        let puzzle = self.appDelegate.sudoku
        load = appDelegate.loadLocalStorage()
        if load != nil {
            // Game is currently saved
            appDelegate.sudoku.grid = load
            
            puzzle.clearUserPuzzle()
            puzzle.clearPlistPuzzle()
            puzzle.clearPencilPuzzle()
//            puzzle.grid.undonePuzzle.removeAll()
//            puzzle.grid.puzzleStack.removeAll()
//            puzzle.grid.undonePencil.removeAll()
//            puzzle.grid.pencilStack.removeAll()
        } else {
            // Game is currently NOT saved
        }
        puzzle.grid.undonePuzzle.removeAll()
        puzzle.grid.puzzleStack.removeAll()
        puzzle.grid.undonePencil.removeAll()
        puzzle.grid.pencilStack.removeAll()
    }
    
    @objc func continueButtonTapped(sender: UIButton) {
        startButton.isHidden = true
        var load = appDelegate.load
        load = appDelegate.loadLocalStorage()
        if load != nil {
            GameViewController.isPlayingSavedGame = true
            appDelegate.sudoku.grid = load
            performSegue(withIdentifier: "toPuzzle", sender: sender)
        } else {
            instantiatingCustomAlertView()
            self.delegate?.customAlertController(title: "UH-OH".localized(), message: "No Saved Game.".localized(), option: .oneButton)
            self.delegate?.customAction1(title: "OK", action: { xx in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            self.present(self.customAlertView, animated: true, completion: nil)
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
    
    func lottieForHomeVC() {
        let ani = AnimationView(name: "Blank")
        ani.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        ani.center = self.view.center
        ani.contentMode = .scaleAspectFill
        view.addSubview(aniView)
        aniView.addSubview(ani)
        view.sendSubviewToBack(aniView)
        ani.play()
    }
    
    // Convert 1 line sudoku puzzles
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    func converting() {
        var array = [Int]()
        var arrays = appDelegate.getPuzzles("hard")
        let answerArrays = appDelegate.getPuzzles("hardAnswers")
        
        for (index, element) in arrays.enumerated() {
            let numOfGivenNums = 81-(element.countInstances(of: "."))
            if numOfGivenNums < 33 {
                for (cIndex, character) in element.enumerated() {
                    if character == "." {
                        array.append(cIndex)
                    }
                }
                while 81-(arrays[index].countInstances(of: ".")) < 33 {
                    let randomIndex = array.randomElement()
                    arrays[index] = replace(myString: arrays[index], randomIndex!, answerArrays[index][randomIndex!])
                }
                array.removeAll()
            }
        }
        dump(arrays)
    }
    
}
