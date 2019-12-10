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
    override func viewDidLoad() {
        super.viewDidLoad()
        makeStartButton()
        makeLevelButtons()
        makeInstructionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeViewControllerTransition = .start
    }
    
    @IBOutlet weak var aniView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var homeViewControllerTransition: HomeViewControllerTransition = .start {
        didSet {
            let leftX = self.view.frame.origin.x-view.frame.size.width
            let levelSVX = (self.view.frame.size.width-levelButtonsStackView.frame.size.width)/2
            let instructionX = (self.view.frame.size.width-instructionStackView.frame.size.width)/2
            
            switch homeViewControllerTransition {
            case .start :
                makeStartImage()
                playStartLottie()
                startButton.isHidden = false
                levelButtonsStackView.isHidden = true
                instructionStackView.isHidden = true
            case .level :
                startButton.isHidden = true
//                self.moveStartImageToLeft()
                zoomOutStartImageToCentre()
                self.levelButtonsStackView.isHidden = false
                self.levelButtonsStackView.frame.origin.x = self.view.frame.maxX
                self.view.animateXPosition(target: self.levelButtonsStackView, targetPosition: levelSVX)
                playLevelLottie { () in
//                    self.moveStartImageToLeft()
//                    self.levelButtonsStackView.isHidden = false
//                    self.levelButtonsStackView.frame.origin.x = self.view.frame.maxX
//                    self.view.animateXPosition(target: self.levelButtonsStackView, targetPosition: levelSVX)
                }
                self.view.bringSubviewToFront(self.levelButtonsStackView)
            case .sudoji :
                self.playSudoji { () in
                    self.performSegue(withIdentifier: "toPuzzle", sender: self)
                }
                instructionStackView.isUserInteractionEnabled = false
                self.view.animateXPosition(target: levelButtonsStackView, targetPosition: leftX) { action in
                    self.levelButtonsStackView.isHidden = true
                }
                instructionStackView.frame.origin.x = view.frame.maxX
                instructionStackView.isHidden = false
                self.view.animateXPosition(target: instructionStackView, targetPosition: instructionX) { action in
                    
                }
                levelButtonsStackView.layoutIfNeeded()
                instructionStackView.layoutIfNeeded()
            }
        }
    }
    
    var startImage = UIImage()
    let startImageView = UIImageView()
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
    var isFromGameVC = false
    let intro = AnimationView(name: "Intro")
    
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
    
    @objc func continueButtonTapped(sender: UIButton) {
        startButton.isHidden = true
        var load = appDelegate.load
        load = appDelegate.loadLocalStorage()
        if load != nil {
            GameViewController.isPlayingSavedGame = true
            appDelegate.sudoku.grid = load
            dump(appDelegate.sudoku.grid.plistPuzzle)
            dump(appDelegate.sudoku.grid.puzzleAnswer)
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
            
        } else {
            // Game is currently NOT saved
        }
        puzzle.grid.undonePuzzle.removeAll()
        puzzle.grid.puzzleStack.removeAll()
        puzzle.grid.undonePencil.removeAll()
        puzzle.grid.pencilStack.removeAll()
    }
    
    func instantiatingCustomAlertView() {
        customAlertView = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertViewController
        customAlertView.providesPresentationContextTransitionStyle = true
        customAlertView.definesPresentationContext = true
        customAlertView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.delegate = customAlertView
    }
    
}
