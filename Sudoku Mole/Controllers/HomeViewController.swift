//
//  ViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 20/09/2019.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit
import Lottie

enum HomeViewControllerTransition {
    case start
    case level
    case sudoji
}

class HomeViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBOutlet weak var aniView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeStartButton()
        makeLevelButtons()
        makeInstructionView()


       let ani = AnimationView(name: "11282-bread-toaster")
//
//
        ani.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
            ani.center = self.view.center
            ani.contentMode = .scaleAspectFill
            
            view.addSubview(aniView)
        aniView.addSubview(ani)
        view.sendSubviewToBack(aniView)
            ani.play()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
        let attribute = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 80.0)!, NSAttributedString.Key.foregroundColor: yellow] as [NSAttributedString.Key : Any]
        let attributedString = NSAttributedString(string: "3", attributes: attribute)
        count.attributedText = attributedString
        count.isHidden = true
        homeViewControllerTransition = .start
    }
    
    @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {
           }
    
//    var isBackButtonTapped = false
    let startButton = UIButton()
    let easyButton = UIButton()
    let normalButton = UIButton()
    let hardButton = UIButton()
    let expertButton = UIButton()
    let continueButton = UIButton()
//    let backButton = UIButton()
    var count = UILabel()
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
    
    var homeViewControllerTransition: HomeViewControllerTransition = .start {
          didSet {
            
            let leftX = self.view.frame.origin.x-view.frame.size.width
//            let rightX = self.view.frame.maxX+view.frame.size.width
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
                // animate level buttons to right so that it is hidden
//                if isBackButtonTapped == true {
//                    levelButtonsStackView.isHidden = false
//                    self.view.animateXPosition(target: levelButtonsStackView, targetPosition: rightX)
//                    isBackButtonTapped = false
//                }
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
    
    @objc func startButtonTapped(sender: UIButton) {
        homeViewControllerTransition = .level
        
//        converting()
        
    }

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

    @objc func easyButtonTapped(sender: UIButton) {
        homeViewControllerTransition = .sudoji
        let puzzle = appDelegate.sudoku
        puzzle.grid.gameDiff = "Easy"
        let array = appDelegate.getPuzzles(puzzle.grid.gameDiff)
        let answerArray = appDelegate.getPuzzles(puzzle.grid.gameDiff+"Answers")
        let puzzleIndex = random(array.count)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[random(array.count)], toughness: puzzle.grid.gameDiff)
        puzzle.grid.puzzleAnswer = puzzle.plistToPuzzle(plist: answerArray[puzzleIndex], toughness: puzzle.grid.gameDiff+"Answers")
    }
    
    @objc func normalButtonTapped(sender: UIButton) {
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
        homeViewControllerTransition = .sudoji
        let puzzle = appDelegate.sudoku
        puzzle.grid.gameDiff = "Hard"
        let array = appDelegate.getPuzzles(puzzle.grid.gameDiff)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[random(array.count)], toughness: puzzle.grid.gameDiff)
    }
    
    @objc func expertButtonTapped(sender: UIButton) {
        homeViewControllerTransition = .sudoji
        let puzzle = appDelegate.sudoku
        puzzle.grid.gameDiff = "Expert"
        let array = appDelegate.getPuzzles(puzzle.grid.gameDiff)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[random(array.count)], toughness: puzzle.grid.gameDiff)
    }
    
    @objc func continueButtonTapped(sender: UIButton) {
           startButton.isHidden = true
           
//           let puzzle = appDelegate.sudoku
           var load = appDelegate.load
           load = appDelegate.loadLocalStorage()
//           if puzzle.inProgress {
//               performSegue(withIdentifier: "toPuzzle", sender: sender)
//           } else
            if load != nil {
               appDelegate.sudoku.grid = load
               performSegue(withIdentifier: "toPuzzle", sender: sender)
           } else {
               instantiatingCustomAlertView()
               self.delegate?.customAlertController(title: "UH-OH", message: "No Game in Progress & No Saved Games", option: .oneButton)
               self.delegate?.customAction1(title: "OK", action: { xx in
                   DispatchQueue.main.async {
                       self.dismiss(animated: true, completion: nil)
                   }
               })
               self.present(self.customAlertView, animated: true, completion: nil)
           }
       }
    
//    @objc func backButtonTapped(sender: UIButton) {
//        isBackButtonTapped = true
//        homeViewControllerTransition = .start
//    }
    
    func instantiatingCustomAlertView() {
         customAlertView = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertViewController
         customAlertView.providesPresentationContextTransitionStyle = true
         customAlertView.definesPresentationContext = true
         customAlertView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
         customAlertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
         self.delegate = customAlertView
     }
    
}
extension Array where Element : Collection,
    Element.Iterator.Element : Equatable, Element.Index == Int {

    func indices(of x: Element.Iterator.Element) -> (Int, Int)? {
        for (i, row) in self.enumerated() {
            if let j = row.firstIndex(of: x) {
                return (i, j)
            }
        }
        return nil
    }
}

//extension String {
//    /// stringToFind must be at least 1 character.
//    func countInstances(of stringToFind: String) -> Int {
//        assert(!stringToFind.isEmpty)
//        var count = 0
//        var searchRange: Range<String.Index>?
//        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
//            count += 1
//            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
//        }
//        return count
//    }
//}

//public extension String {
//  func indexInt(of char: Character) -> Int? {
//    return firstIndex(of: char)?.utf16Offset(in: self)
//  }
//}
