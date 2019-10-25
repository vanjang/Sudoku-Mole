//
//  GameViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 21/09/2019.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit

func random(_ n:Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
} // end random()

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        biTitleSetup()
        timerSetup()
        boardSetup()
        
        difficultyLabelOutlet.text = appDelegate.sudoku.grid.gameDiff//GameViewController.difficultyTitle
        pencilOn = false
    }
    
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var sudokuView: SudokuView!
    @IBOutlet weak var biOutlet: UILabel!
    @IBOutlet weak var difficultyLabelOutlet: UILabel!
    @IBOutlet weak var timerOulet: UILabel!
    @IBOutlet var dummyCollection: [UIView]!
    
    @IBAction func pencilOn(_ sender: UIButton) {
        pencilOn = !pencilOn
        sender.isSelected = pencilOn
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        // UIAlertController message
        let title = "Leaving Current Game"
        let message = "Are you sure you want to abandon?"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            let puzzle = self.appDelegate.sudoku
            puzzle.clearUserPuzzle()
            puzzle.clearPlistPuzzle()
            puzzle.clearPencilPuzzle()
            puzzle.gameInProgress(set: false)
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var puzzleArea: SudokuView!
    
    @IBAction func keypad(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = self.appDelegate.sudoku
        puzzle.gameInProgress(set: true)
        let grid = appDelegate.sudoku.grid
        let row = puzzleArea.selected.row
        let col = puzzleArea.selected.column
        if (row != -1 && col != -1) {
            if pencilOn == false {
                if grid?.plistPuzzle[row][col] == 0 && grid?.userPuzzle[row][col] == 0  {
                    appDelegate.sudoku.userGrid(n: sender.tag, row: row, col: col)
                    refresh()
                } else if grid?.plistPuzzle[row][col] == 0 || grid?.userPuzzle[row][col] == sender.tag {
                    appDelegate.sudoku.userGrid(n: 0, row: row, col: col)
                    refresh()
                }
            } else {
                appDelegate.sudoku.pencilGrid(n: sender.tag, row: row, col: col)
                refresh()
            }
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        // UIAlertController message
        let alert = UIAlertController(title: "Menu", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Clear Conflicts", comment: "Default action"), style: .`default`, handler: { _ in
            
            let puzzle = self.appDelegate.sudoku
            puzzle.clearConflicts()
            self.refresh()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Clear All", comment: ""), style: .`default`, handler: { _ in
            let puzzle = self.appDelegate.sudoku
            puzzle.clearUserPuzzle()
            puzzle.clearPencilPuzzle()
            puzzle.gameInProgress(set: false)
            self.refresh()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .`default`, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    static var difficultyTitle: String!
    var pencilOn = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let yellow = UIColor(red: 236.0 / 255.0, green: 224.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    let mint = UIColor(red: 198.0 / 255.0, green: 237.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    
    @objc func timerTapped() {
        print("timer tapped")
    }
    
    func biTitleSetup() {
        let attributedKeys = [NSAttributedString.Key.font: UIFont(name: "LuckiestGuy-Regular", size: 22.0)!, NSAttributedString.Key.foregroundColor: yellow] as [NSAttributedString.Key : Any]
        let attribute =  NSAttributedString(string: "SUDOKU\nMOLE", attributes: attributedKeys)
        
        biOutlet.attributedText = attribute
        biOutlet.layer.shadowColor = UIColor(red: 69.0/255.0, green: 99.0/255.0, blue: 54.0/255.0, alpha: 1.0).cgColor
        biOutlet.layer.shadowOffset.height = 3
    }
    
    func refresh() {
        sudokuView.setNeedsDisplay()
    }
    
    func timerSetup() {
        //▶︎▶️⏸
        timerOulet.text = "▶︎  00:00:00"
        timerOulet.frame.inset(by: UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0))
        timerOulet.layer.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2).cgColor
        timerOulet.layer.cornerRadius = timerOulet.frame.height/2
        timerOulet.layer.borderWidth = 0.0
        
        timerOulet.layer.shadowOffset = CGSize(width: 0.0, height: -5.0)
        timerOulet.layer.shadowColor = UIColor(red: 105.0/255.0, green: 105.0/255.0, blue: 105.0/255.0, alpha: 0.5).cgColor
        timerOulet.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(timerTapped))
        timerOulet.addGestureRecognizer(gestureRecognizer)
    }
    
    func boardSetup() {
        puzzleArea.clipsToBounds = true
        puzzleArea.backgroundColor = UIColor(red: 149.0 / 255.0, green: 79.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
        
        for dummy in dummyCollection {
            dummy.clipsToBounds = true
            dummy.layer.cornerRadius = 13
            dummy.backgroundColor = UIColor(red: 124.0 / 255.0, green: 63.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
        }
        
        // standard sizes
        let gridSize = sudokuView.bounds.width
        let gridOrigin = CGPoint(x: (sudokuView.bounds.width - gridSize), y: (sudokuView.bounds.height - gridSize))
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let sudokuViewSize = screenWidth - CGFloat(6)
        let delta = sudokuViewSize/3
        
        // can't use loop due to view hierarchy
        let r1c1 = UIView(frame: CGRect(x: gridOrigin.x, y: gridOrigin.y, width: delta+6, height: delta+6))
        r1c1.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r1c1.layer.cornerRadius = 13
        let r1c2 = UIView(frame: CGRect(x: gridOrigin.x, y: gridOrigin.y+delta, width: delta+6, height: delta+6))
        r1c2.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r1c2.layer.cornerRadius = 13
        let r1c3 = UIView(frame: CGRect(x: gridOrigin.x, y: gridOrigin.y+(delta*2), width: delta+6, height: delta+6.5))
        r1c3.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r1c3.layer.cornerRadius = 13
        let height1 = UIView(frame: CGRect(x: gridOrigin.x, y: gridOrigin.y+10, width: delta+6, height: screenWidth+1.5))
        height1.backgroundColor = UIColor(red: 200/255, green: 187/255, blue: 130/255, alpha: 1)
        height1.layer.cornerRadius = 13
        let shadow1 = UIView(frame: CGRect(x: gridOrigin.x, y: gridOrigin.y+10, width: delta+6, height: screenWidth+7.5))
        shadow1.backgroundColor = UIColor(red: 56/255, green: 129/255, blue: 76/255, alpha: 1)
        shadow1.layer.cornerRadius = 13
        
        let r2c1 = UIView(frame: CGRect(x: gridOrigin.x+delta, y: gridOrigin.y, width: delta+6, height: delta+6))
        r2c1.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r2c1.layer.cornerRadius = 13
        let r2c2 = UIView(frame: CGRect(x: gridOrigin.x+delta, y: gridOrigin.y+delta, width: delta+6, height: delta+6))
        r2c2.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r2c2.layer.cornerRadius = 13
        let r2c3 = UIView(frame: CGRect(x: gridOrigin.x+delta, y: gridOrigin.y+(delta*2), width: delta+6, height: delta+6.5))
        r2c3.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r2c3.layer.cornerRadius = 13
        let height2 = UIView(frame: CGRect(x: gridOrigin.x+delta, y: gridOrigin.y+10, width: delta+6, height: screenWidth+1.5))
        height2.backgroundColor = UIColor(red: 200/255, green: 187/255, blue: 130/255, alpha: 1)
        height2.layer.cornerRadius = 13
        let shadow2 = UIView(frame: CGRect(x: gridOrigin.x+delta, y: gridOrigin.y+10, width: delta+6, height: screenWidth+7.5))
        shadow2.backgroundColor = UIColor(red: 56/255, green: 129/255, blue: 76/255, alpha: 1)
        shadow2.layer.cornerRadius = 13
        
        let r3c1 = UIView(frame: CGRect(x: gridOrigin.x+(delta*2), y: gridOrigin.y, width: delta+6, height: delta+6))
        r3c1.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r3c1.layer.cornerRadius = 13
        let r3c2 = UIView(frame: CGRect(x: gridOrigin.x+(delta*2), y: gridOrigin.y+delta, width: delta+6, height: delta+6))
        r3c2.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r3c2.layer.cornerRadius = 13
        let r3c3 = UIView(frame: CGRect(x: gridOrigin.x+(delta*2), y: gridOrigin.y+(delta*2), width: delta+6, height: delta+6.5))
        r3c3.backgroundColor = UIColor(red: 234/255, green: 221/255, blue: 168/255, alpha: 1)
        r3c3.layer.cornerRadius = 13
        let height3 = UIView(frame: CGRect(x: gridOrigin.x+(delta*2), y: gridOrigin.y+10, width: delta+6, height: screenWidth+1.5))
        height3.backgroundColor = UIColor(red: 200/255, green: 187/255, blue: 130/255, alpha: 1)
        height3.layer.cornerRadius = 13
        let shadow3 = UIView(frame: CGRect(x: gridOrigin.x+(delta*2), y: gridOrigin.y+10, width: delta+6, height: screenWidth+7.5))
        shadow3.backgroundColor = UIColor(red: 56/255, green: 129/255, blue: 76/255, alpha: 1)
        shadow3.layer.cornerRadius = 13
        
        let fill = UIView(frame: CGRect(x: delta/2, y: delta/2, width: delta*2, height: delta*2))
        fill.backgroundColor = UIColor(red: 124.0 / 255.0, green: 63.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
        
        yellowView.addSubview(shadow1)
        yellowView.addSubview(shadow2)
        yellowView.addSubview(shadow3)
        
        yellowView.addSubview(height1)
        yellowView.addSubview(height2)
        yellowView.addSubview(height3)
        
        yellowView.addSubview(r1c1)
        yellowView.addSubview(r1c2)
        yellowView.addSubview(r1c3)
        
        yellowView.addSubview(r2c1)
        yellowView.addSubview(r2c2)
        yellowView.addSubview(r2c3)
        
        yellowView.addSubview(r3c1)
        yellowView.addSubview(r3c2)
        yellowView.addSubview(r3c3)
        
        yellowView.addSubview(fill)
    }
    
}
