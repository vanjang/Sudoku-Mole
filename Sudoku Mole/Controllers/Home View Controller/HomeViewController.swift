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
        stopBGM()
        homeViewControllerTransition = .start
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isPlayingGame = true
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
                zoomOutStartImageToCentre()
                self.levelButtonsStackView.isHidden = false
                self.levelButtonsStackView.frame.origin.x = self.view.frame.maxX
                self.view.animateXPosition(target: self.levelButtonsStackView, targetPosition: levelSVX)
                playLevelLottie { () in
                }
                self.view.bringSubviewToFront(self.levelButtonsStackView)
            case .sudoji :
                playSound(soundFile: "countdown", lag: 0.91, numberOfLoops: 0)
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
        playLevelSound(soundFile: "startAndLevel", lag: -0.2, numberOfLoops: 0)
        homeViewControllerTransition = .level
        isFromGameVC = true
    }

    @objc func easyButtonTapped(sender: UIButton) {
        initialiseLevel(level: "Easy")
    }
    
    @objc func normalButtonTapped(sender: UIButton) {
        initialiseLevel(level: "Normal")
    }
    
    @objc func hardButtonTapped(sender: UIButton) {
        initialiseLevel(level: "Hard")
    }
    
    @objc func expertButtonTapped(sender: UIButton) {
        initialiseLevel(level: "Expert")
    }
    
    @objc func continueButtonTapped(sender: UIButton) {
        startButton.isHidden = true
        var load = appDelegate.load
        load = appDelegate.loadLocalStorage()
        
        if load != nil {
            let savedLevel = load!.gameDiff
            let timeProgressed = load!.savedOutletTime
            let message = "You were in the middle of\n".localized() + savedLevel + "(" + timeProgressed + ")!".localized()
            instantiatingCustomAlertView()
            delegate?.customAlertController(title: "RESUME GAME?".localized(), message: message, option: .twoButtons)
            delegate?.customAction1(title: "CONTINUE".localized(), action:  { action in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                    isPlayingSavedGame = true
                    self.appDelegate.sudoku.grid = load
                    self.performSegue(withIdentifier: "toPuzzle", sender: sender)
                }
            })
            delegate?.customAction2(title: "CANCEL".localized(), action : { action in
                self.customAlertView.dismiss(animated: true, completion: nil)
            })
            present(customAlertView, animated: true, completion: nil)
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
    
    func initialiseLevel(level: String) {
        isPlayingSavedGame = false
        playLevelSound(soundFile: "startAndLevel", lag: -0.3, numberOfLoops: 0)
        setupGameData()
        homeViewControllerTransition = .sudoji
        let puzzle = appDelegate.sudoku
        puzzle.grid.gameDiff = level
        let array = appDelegate.getPuzzles(puzzle.grid.gameDiff)
        let answerArray = appDelegate.getPuzzles(puzzle.grid.gameDiff+"Answers")
        let puzzleIndex = random(array.count)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[puzzleIndex], toughness: puzzle.grid.gameDiff)
        puzzle.grid.puzzleAnswer = puzzle.plistToPuzzle(plist: answerArray[puzzleIndex], toughness: puzzle.grid.gameDiff+"Answers")
    }
    
    func setupGameData() {
        let puzzle = self.appDelegate.sudoku
        puzzle.grid.savedOutletTime = "00:00:00"
        puzzle.grid.savedTime = 0
        puzzle.grid.lifeRemained = []
        puzzle.grid.savedRow = -1
        puzzle.grid.savedCol = -1
        puzzle.clearUserPuzzle()
        puzzle.clearPlistPuzzle()
        puzzle.clearPencilPuzzle()
        puzzle.grid.undonePuzzle.removeAll()
        puzzle.grid.puzzleStack.removeAll()
        puzzle.grid.undonePencil.removeAll()
        puzzle.grid.pencilStack.removeAll()
        puzzle.grid.savedFilledNum = [1: false, 2: false, 3: false, 4: false, 5: false, 6: false, 7: false, 8: false, 9: false]
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
