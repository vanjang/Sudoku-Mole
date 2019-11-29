//
//  SudokuView.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/15.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

class SudokuView: UIView {
    var selected = (row : -1, column : -1)  // current selected cell in 9x9 puzzle (-1 => none)
    var selectedFixed = (row : -1, column : -1)
    // For playing animation on the selected box
    var cgPointForSelectedBox = CGPoint()
    var sizeForSelectedBox = CGRect()
    
    // Allow user to "select" a non-fixed cell in the puzzle's 9x9 grid.
    @IBAction func handleTap(_ sender : UIGestureRecognizer) {
        let tapPoint = sender.location(in: self)
        let gridSize = (self.bounds.width < self.bounds.height) ? self.bounds.width : self.bounds.height
        let gridOrigin = CGPoint(x: (self.bounds.width - gridSize)/2, y: (self.bounds.height - gridSize)/2)
        let d = gridSize/9
        let col = Int((tapPoint.x - gridOrigin.x)/d)
        let row = Int((tapPoint.y - gridOrigin.y)/d)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let puzzle = appDelegate.sudoku
        
        if  0 <= col && col < 9 && 0 <= row && row < 9 {              // if inside puzzle bounds
//            if (!puzzle.numberIsFixedAt(row: row, column: col)) {       // and not a "fixed number"
                if (row != selected.row || col != selected.column) {  // and not already selected
                    selected.row = row                                // then select cell
                    selected.column = col
                    setNeedsDisplay()                                 // request redraw ***** PuzzleView
                }
//            }
        }
    }
    
    // Draw sudoku board. The current puzzle state is stored in the "sudoku" property
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        // Fetch Sudoku puzzle model object from app delegate.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = appDelegate.sudoku
        
        // Find largest square w/in bounds of view and use this to establish
        // Grid parameters.
        let gridSize = self.bounds.width-7
        let gridOrigin = CGPoint(x: (self.bounds.width - gridSize)*0+(7/2), y: (self.bounds.height - gridSize)*0+(7/2))
        let delta = gridSize/3
        let d = delta/3
        
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 149.0 / 255.0, green: 79.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)//.clear
        
        // Draw color attribute information
        let selectedCellColor = UIColor(red: 102/255, green: 52/255, blue: 0/255, alpha: 1)
//        let selectedStrokeColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)//UIColor(red: 102/255, green: 52/255, blue: 0/255, alpha: 1)//
        let neighboringColor = UIColor(red: 135/255, green: 71/255, blue: 48/255, alpha: 1)
        let majorBorderColor = UIColor(red: 124.0 / 255.0, green: 63.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
        let minorBorderColor = UIColor(red: 122/255, green: 63/255, blue: 40/255, alpha: 1)
        let sameNumberColor = UIColor(red: 122/255, green: 66/255, blue: 45/255, alpha: 1)
        let sameNumberStrokeColor = UIColor(red: 100/255, green: 56/255, blue: 40/255, alpha: 1)
        let conflictBoxColor = #colorLiteral(red: 0.8231359124, green: 0.2062529325, blue: 0.1228148416, alpha: 1)
        let conflictNeibourghBoxColor = #colorLiteral(red: 0.9053650498, green: 0.3585931063, blue: 0.2821154594, alpha: 1)
        
        // Fetch/compute font attribute information.
        let fontName = "SFProDisplay-Light"//"SF Compact Display-Semibold"//"Helvetica-Light"
        let fixedFontColor = #colorLiteral(red: 241/255, green: 221/255, blue: 128/255, alpha: 1)
        let userFontColor = #colorLiteral(red: 195/255, green: 239/255, blue: 255/255, alpha: 1)
        let pencilFontColor = #colorLiteral(red: 1, green: 0.7889312506, blue: 0.7353969216, alpha: 1)
        
        // Box font attributes
        let fontSize = fontSizeFor("0", fontName: fontName, targetSize: CGSize(width: d, height: d))
        let font = UIFont(name: fontName, size: 31  )//fontSize)
        let pencilFont = UIFont(name: fontName, size: fontSize/3.5)
        let fixedAttributes = [NSAttributedString.Key.font : font!, NSAttributedString.Key.foregroundColor : fixedFontColor]
        let userAttributes = [NSAttributedString.Key.font : font!, NSAttributedString.Key.foregroundColor : userFontColor]
        let pencilAttributes = [NSAttributedString.Key.font : pencilFont!, NSAttributedString.Key.foregroundColor : pencilFontColor]
        
        // Fill selected cell (if one is selected by tap gesture recognizer).
        if selected.row >= 0 && selected.column >= 0 {
            let x = gridOrigin.x + CGFloat(selected.column)*d
            let y = gridOrigin.y + CGFloat(selected.row)*d
//            let numberAtSelectedBox = puzzle.userEntry(row: selected.row, column: selected.column)
            let numberAtSelectedBox = puzzle.numberAt(row: selected.row, column: selected.column)
            var selectedThird = -1
            
            // Fill 3x3 boxes : from top left 3x3 in clock way
            for i in 0 ..< 3 {
                // 1. Top left
                if selected.row >= 0 && selected.row < 3 && selected.column >= 0 && selected.column < 3 {
                    selectedThird = 0
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: gridOrigin.x+CGFloat(i)*d, y: gridOrigin.y+CGFloat(j)*d, width: d, height: d))
                    }
                }
                // 2. Top mid
                if selected.row >= 0 && selected.row < 3 && selected.column >= 3 && selected.column < 6 {
                    selectedThird = 1
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+delta, y: gridOrigin.y+CGFloat(j)*d, width: d, height: d))
                    }
                }
                // 3. Top right
                if selected.row >= 0 && selected.row < 3 && selected.column >= 6 && selected.column < 9 {
                    selectedThird = 2
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+(delta*2), y: gridOrigin.y+CGFloat(j)*d, width: d, height: d))
                    }
                }
                // 4. Mid left
                if selected.row >= 3 && selected.row < 6 && selected.column >= 0 && selected.column < 3 {
                    selectedThird = 3
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: gridOrigin.x+CGFloat(i)*d, y: (gridOrigin.y+CGFloat(j)*d)+delta, width: d, height: d))
                    }
                }
                // 5. Mid mid
                if selected.row >= 3 && selected.row < 6 && selected.column >= 3 && selected.column < 6 {
                    selectedThird = 4
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+delta, y: (gridOrigin.y+CGFloat(j)*d)+delta, width: d, height: d))
                    }
                }
                // 6. Mid right
                if selected.row >= 3 && selected.row < 6 && selected.column >= 6 && selected.column < 9 {
                    selectedThird = 5
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+(delta*2), y: (gridOrigin.y+CGFloat(j)*d)+delta, width: d, height: d))
                    }
                }
                // 7. Bottom left
                if selected.row >= 6 && selected.row < 9 && selected.column >= 0 && selected.column < 3 {
                    selectedThird = 6
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: gridOrigin.x+CGFloat(i)*d, y: (gridOrigin.y+CGFloat(j)*d)+(delta*2), width: d, height: d))
                    }
                }
                // 8. Bottom mid
                if selected.row >= 6 && selected.row < 9 && selected.column >= 3 && selected.column < 6 {
                    selectedThird = 7
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+delta, y: (gridOrigin.y+CGFloat(j)*d)+(delta*2), width: d, height: d))
                    }
                }
                // 9. Bottom right
                if selected.row >= 6 && selected.row < 9 && selected.column >= 6 && selected.column < 9 {
                    selectedThird = 8
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+(delta*2), y: (gridOrigin.y+CGFloat(j)*d)+(delta*2), width: d, height: d))
                    }
                }
            }
            
            // Fill rows
            for i in 0 ..< 9 {
                neighboringColor.setFill()
                context?.fill(CGRect(x: gridOrigin.x + CGFloat(i)*d, y: y, width: d, height: d))
            }
            
            // Fill cols and selected box
            for i in 0 ..< 9 {
                if y == gridOrigin.y+CGFloat(i)*d {
                    
                    selectedCellColor.setFill()
//                    selectedStrokeColor.setStroke()
                    context?.fill(CGRect(x: x, y: y, width: d, height: d))
//                    context?.stroke(CGRect(x: x, y: y, width: d, height: d))
//                    context?.setLineWidth(1)
                    
                    // send coordinates to play animation on
                    cgPointForSelectedBox.x = x
                    cgPointForSelectedBox.y = y
                    sizeForSelectedBox.size.width = d
                    sizeForSelectedBox.size.height = d
                } else {
                    neighboringColor.setFill()
                    context?.fill(CGRect(x: x, y: gridOrigin.y + CGFloat(i)*d, width: d, height: d))
                }
            }
            
            // If selected box is conflicting, set its box to red
            for r in 0 ..< 9 {
                for c in 0 ..< 9 {
                    let selectedBox = (row : r, column : c)
                    if puzzle.isConflictingEntryAt(row: r, column: c) && selected == selectedBox && puzzle.grid.plistPuzzle[r][c] == 0 {
                        conflictBoxColor.setFill()
                        sameNumberStrokeColor.setStroke()
                        context?.fill(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
                        context?.stroke(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
                    }
                }
            }
            
            // Set conflicts to vermilion
            for r in 0 ..< 9 {
                for c in 0 ..< 9 {
                    let iteratingBox = (row : r, column : c)
                    if puzzle.userEntry(row: r, column: c) > 0 && !puzzle.numberIsFixedAt(row: r, column: c) && puzzle.isConflictingEntryAt(row: r, column: c) && selected != iteratingBox {
                        conflictNeibourghBoxColor.setFill()
                        sameNumberStrokeColor.setStroke()
                        context?.fill(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
                        context?.stroke(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
                    }
                }
            }
            
            // Fill same numbers with the number drawn in selected cell - ### FILL THE OTHER BOXES - NOT THE SELECTED BOX
            for r in 0 ..< 9 {
                for c in 0 ..< 9 {
                    let iteratingBox = (row : r, column : c)
                    var iteratingThird = -1
                    
                    // 1. Top left - iteratingBox == 3x3 boxes. To compare 3x3 box value with selctedBox value
                    if iteratingBox.row >= 0 && iteratingBox.row < 3 && iteratingBox.column >= 0 && iteratingBox.column < 3 {
                        iteratingThird = 0
                    }
                    // 2. Top mid
                    if iteratingBox.row >= 0 && iteratingBox.row < 3 && iteratingBox.column >= 3 && iteratingBox.column < 6 {
                        iteratingThird = 1
                    }
                    // 3. Top right
                    if iteratingBox.row >= 0 && iteratingBox.row < 3 && iteratingBox.column >= 6 && iteratingBox.column < 9 {
                        iteratingThird = 2
                    }
                    // 4. Mid left
                    if iteratingBox.row >= 3 && iteratingBox.row < 6 && iteratingBox.column >= 0 && iteratingBox.column < 3 {
                        iteratingThird = 3
                    }
                    // 5. Mid mid
                    if iteratingBox.row >= 3 && iteratingBox.row < 6 && iteratingBox.column >= 3 && iteratingBox.column < 6 {
                        iteratingThird = 4
                    }
                    // 6. Mid right
                    if iteratingBox.row >= 3 && iteratingBox.row < 6 && iteratingBox.column >= 6 && iteratingBox.column < 9 {
                        iteratingThird = 5
                    }
                    // 7. Bottom left
                    if iteratingBox.row >= 6 && iteratingBox.row < 9 && iteratingBox.column >= 0 && iteratingBox.column < 3 {
                        iteratingThird = 6
                    }
                    // 8. Bottom mid
                    if iteratingBox.row >= 6 && iteratingBox.row < 9 && iteratingBox.column >= 3 && iteratingBox.column < 6 {
                        iteratingThird = 7
                    }
                    // 9. Bottom right
                    if iteratingBox.row >= 6 && iteratingBox.row < 9 && iteratingBox.column >= 6 && iteratingBox.column < 9 {
                        iteratingThird = 8
                    }
                    

                    if numberAtSelectedBox != 0 && selected != iteratingBox && (puzzle.userEntry(row: r, column: c) == numberAtSelectedBox || puzzle.grid.plistPuzzle[r][c] == numberAtSelectedBox) {
                        sameNumberColor.setFill()
                        sameNumberStrokeColor.setStroke()
                        context?.fill(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
                        context?.stroke(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))

                        if (selected.row == iteratingBox.row || selected.column == iteratingBox.column || selectedThird == iteratingThird || puzzle.userEntry(row: r, column: c) != 0) && puzzle.isConflictingEntryAt(row: r, column: c) {
                            conflictNeibourghBoxColor.setFill()
                            sameNumberStrokeColor.setStroke()
                            context?.fill(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
                            context?.stroke(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
                        }
//                        else if (selected.row == iteratingBox.row || selected.column == iteratingBox.column || selectedThird == iteratingThird ) && puzzle.isConflictingEntryAt(row: r, column: c) && puzzle.userEntry(row: r, column: c) != 0 {
//                            conflictNeibourghBoxColor.setFill()
//                            sameNumberStrokeColor.setStroke()
//                            context?.fill(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
//                            context?.stroke(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
//                        }
                    }
                    
//                    // 1)선택한 칸에 숫자가 채워졌고
//                    if numberAtSelectedBox != 0 &&
//                        // 2) 선택한 칸이 아닌 다른 모든 칸이며(looping)(선택한 칸이 아닌 다른 칸을 draw해야 하므로)
//                        selected != iteratingBox &&
//                        // 3) 아래 creteria중 하나가 true이며
//                        // - looping된 셀의 userEntry값이 '현재 선택한 셀 값(numberAtSelectedBox)'와 동일하거나
//                        // - looping된 셀의 fix값이 '현재 선택한 셀 값(numberAtSelectedBox)'와 동일하거나
//                        (puzzle.userEntry(row: r, column: c) == numberAtSelectedBox || puzzle.grid.plistPuzzle[r][c] == numberAtSelectedBox) {//} &&
//                        sameNumberColor.setFill()
//                        sameNumberStrokeColor.setStroke()
//                        context?.fill(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
//                        context?.stroke(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
//                        // vv아래 creteria중 하나가 true일 때
//                        // - 현재 선택한 셀의 row와 looping된 셀의 row가 같거나
//                        // - 현재 선택한 셀의 col와 looping된 셀의 col이 같거나
//                        // - 현재 선택한 3x3 값과 looping된 셀의 3x3 값이 같거나
//                        if (selected.row == iteratingBox.row || selected.column == iteratingBox.column || selectedThird == iteratingThird ) && puzzle.isConflictingEntryAt(row: r, column: c) {
////                            print("same num drawing")
////                        print("number at selected cell = \(numberAtSelectedBox)")
////                        sameNumberColor.setFill()
////                        sameNumberStrokeColor.setStroke()
////                        context?.fill(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
////                        context?.stroke(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
////                        print(selected)
////                        print("not con")
//                        // If neighbouring same numbers is making conflicts then set these box color to vermilion
////                        if puzzle.isConflictingEntryAt(row: r, column: c) {
//                            conflictNeibourghBoxColor.setFill()
//                            sameNumberStrokeColor.setStroke()
//                            context?.fill(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
//                            context?.stroke(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
//                            print(selected)
//                            print("conflict dra")
//                        }
//                        else {
//                            // If not making conflicts set to light brown
////                            sameNumberColor.setFill()
////                            sameNumberStrokeColor.setStroke()
////                            context?.fill(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
////                            context?.stroke(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
////                            print(selected)
////                            print("not con")
//                        }
//                    }
                }
            }
        }
        
        // Masking bezier paths
        for i in 0 ..< 1 {
            let x = gridOrigin.x + CGFloat(i)*delta
            let mask = CAShapeLayer()
            
            let leftTop = UIBezierPath(roundedRect: CGRect(x: x, y: gridOrigin.y, width: delta, height: delta), cornerRadius: 13.0)
            let leftMiddle = UIBezierPath(roundedRect: CGRect(x: x, y: gridOrigin.y+delta, width: delta, height: delta), cornerRadius: 13.0)
            let leftBottom = UIBezierPath(roundedRect: CGRect(x: x, y: gridOrigin.y+(delta*2), width: delta, height: delta), cornerRadius: 13.0)
            
            let middleTop = UIBezierPath(roundedRect: CGRect(x: x+delta, y: gridOrigin.y, width: delta, height: delta), cornerRadius: 13.0)
            let middleMiddle = UIBezierPath(roundedRect: CGRect(x: x+delta, y: gridOrigin.y+delta, width: delta, height: delta), cornerRadius: 13.0)
            let middleBottom = UIBezierPath(roundedRect: CGRect(x: x+delta, y: gridOrigin.y+(delta*2), width: delta, height: delta), cornerRadius: 13.0)
            
            let rightTop = UIBezierPath(roundedRect: CGRect(x: x+(delta*2), y: gridOrigin.y, width: delta, height: delta), cornerRadius: 13.0)
            let rightMiddle = UIBezierPath(roundedRect: CGRect(x: x+(delta*2), y: gridOrigin.y+delta, width: delta, height: delta), cornerRadius: 13.0)
            let rightBottom = UIBezierPath(roundedRect: CGRect(x: x+(delta*2), y: gridOrigin.y+(delta*2), width: delta, height: delta), cornerRadius: 13.0)
            
            leftTop.append(leftMiddle)
            leftTop.append(leftBottom)
            leftTop.append(middleTop)
            leftTop.append(middleMiddle)
            leftTop.append(middleBottom)
            leftTop.append(rightTop)
            leftTop.append(rightMiddle)
            leftTop.append(rightBottom)
            mask.path = leftTop.cgPath
            layer.mask = mask
        }
        
        // Stroke outer puzzle rectangle
        // 3x3 corner radius
        for i in 0 ..< 3 {
            majorBorderColor.setStroke()
            let x = gridOrigin.x + CGFloat(i)*delta
            if i == 0 {
                let clipPathfor1r = UIBezierPath(roundedRect: CGRect(x: x-1, y: gridOrigin.y-1, width: delta, height: delta), cornerRadius: 13.0).cgPath
                let clipPathfor2r = UIBezierPath(roundedRect: CGRect(x: x-1, y: gridOrigin.y+delta, width: delta, height: delta), cornerRadius: 13.0).cgPath
                let clipPathfor3r = UIBezierPath(roundedRect: CGRect(x: x-1, y: gridOrigin.y+(delta*2)+1, width: delta, height: delta), cornerRadius: 13.0).cgPath
                context?.addPath(clipPathfor1r)
                context?.addPath(clipPathfor2r)
                context?.addPath(clipPathfor3r)
            } else if i == 1 {
                let clipPathfor1r = UIBezierPath(roundedRect: CGRect(x: x+0.2, y: gridOrigin.y-1, width: delta, height: delta), cornerRadius: 13.0).cgPath
                let clipPathfor2r = UIBezierPath(roundedRect: CGRect(x: x+0.2, y: gridOrigin.y+delta, width: delta, height: delta), cornerRadius: 13.0).cgPath
                let clipPathfor3r = UIBezierPath(roundedRect: CGRect(x: x+0.2, y: gridOrigin.y+(delta*2)+1, width: delta, height: delta), cornerRadius: 13.0).cgPath
                context?.addPath(clipPathfor1r)
                context?.addPath(clipPathfor2r)
                context?.addPath(clipPathfor3r)
            } else if i == 2 {
                let clipPathfor1r = UIBezierPath(roundedRect: CGRect(x: x+1, y: gridOrigin.y-1, width: delta, height: delta), cornerRadius: 13.0).cgPath
                let clipPathfor2r = UIBezierPath(roundedRect: CGRect(x: x+1, y: gridOrigin.y+delta, width: delta, height: delta), cornerRadius: 13.0).cgPath
                let clipPathfor3r = UIBezierPath(roundedRect: CGRect(x: x+1, y: gridOrigin.y+(delta*2)+1, width: delta, height: delta), cornerRadius: 13.0).cgPath
                context?.addPath(clipPathfor1r)
                context?.addPath(clipPathfor2r)
                context?.addPath(clipPathfor3r)
            }
            context?.setLineWidth(2.7)
            context?.strokePath()
        }
        
        // Stroke minor grid lines.
        for i in 0 ..< 3 {
            minorBorderColor.setStroke()
            for j in 1 ..< 3 {
                let x = gridOrigin.x + CGFloat(i)*delta + CGFloat(j)*d
                context?.move(to: CGPoint(x: x, y: gridOrigin.y))
                context?.addLine(to: CGPoint(x: x, y: gridOrigin.y + gridSize))
                
                context?.setLineWidth(0.7)
                let y = gridOrigin.y + CGFloat(i)*delta + CGFloat(j)*d
                context?.move(to: CGPoint(x: gridOrigin.x, y: y))
                context?.addLine(to: CGPoint(x: gridOrigin.x + gridSize, y: y))
                context?.strokePath()
            }
        }
        
        // Fill in puzzle numbers.
        for row in 0 ..< 9 {
            for col in 0 ..< 9 {
                var number : Int
                // 정리 : 각각의 칸(81칸)에 유저값이 있다면(!=0) 채워넣고 없다면 fix값 채워넣는다
                // 보드판 숫자 채워넣기위해 number에 유저 숫자 or 기본 숫자를 넣어준다
                if puzzle.userEntry(row: row, column: col) != 0 {
                    number = puzzle.userEntry(row: row, column: col)
                } else {
                    number = puzzle.numberAt(row: row, column: col)
                }
                // string attribute 설정 : number가 0보다 클 경우 -> 유저가 해당 칸을 채워넣은 경우
                if (number > 0) {
                    var attributes : [NSAttributedString.Key : NSObject]? = nil
                    // 1. 가장 먼저 퍼즐 기본 숫자 넣어주기 (fixed)
                    if puzzle.numberIsFixedAt(row: row, column: col) {
                        attributes = fixedAttributes
                        // 2. 그리고 해당 셀이 오답이면 오답 폰트 넣기 (근데 오답 메소드가 뭔가 잘못됨, 확인해야 함)
                        
                    } else if puzzle.isConflictingEntryAt(row: row, column: col) {
                        // Conflicting number font attribute
                        attributes = userAttributes
                        
                        // 3. 기본 숫자 들어가고 오답도 들어갔으면 유저 숫자 넣기
                    } else if puzzle.userEntry(row: row, column: col) != 0 {
                        if puzzle.isConflictingEntryAt(row: row, column: col) {
                        } else {
                            attributes = userAttributes
                        }
                    }
                    
                    // 4. Fill numbers
                    let text = "\(number)" as NSString
                    let textSize = text.size(withAttributes: attributes)
                    let x = gridOrigin.x + CGFloat(col)*d + 0.5*(d - textSize.width)
                    let y = gridOrigin.y + CGFloat(row)*d + 0.5*(d - textSize.height)
                    let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
                    text.draw(in: textRect, withAttributes: attributes)
                    
                    // number가 0보다 작은 경우 : 해당 칸에 유저가 넣은 값이 없는 경우가 된다. 유저값이 없는 경우에만 pencil값을 그려준다
                } else if puzzle.anyPencilSetAt(row: row, column: col) {
                    let s = d/3
                    for n in 1 ... 9 {
                        if puzzle.isSetPencil(n: n, row: row, column: col) {
                            let r = (n - 1) / 3
                            let c = (n - 1) % 3
                            let text : NSString = "\(n)" as NSString
                            let textSize = text.size(withAttributes: pencilAttributes)
                            
                            var x = CGFloat()
                            var y = CGFloat()
                            
                            if n == 1 {
                                x = gridOrigin.x + CGFloat(col)*d + CGFloat(c)*s + 0.8*(s - textSize.width)
                                y = gridOrigin.y + CGFloat(row)*d + CGFloat(r)*s + 1.2*(s - textSize.height)
                            } else if n == 2 {
                                x = gridOrigin.x + CGFloat(col)*d + CGFloat(c)*s + 0.5*(s - textSize.width)
                                y = gridOrigin.y + CGFloat(row)*d + CGFloat(r)*s + 1.2*(s - textSize.height)
                            } else if n == 3 {
                                x = gridOrigin.x + CGFloat(col)*d + CGFloat(c)*s + 0.2*(s - textSize.width)
                                y = gridOrigin.y + CGFloat(row)*d + CGFloat(r)*s + 1.2*(s - textSize.height)
                            } else if n == 4 {
                                x = gridOrigin.x + CGFloat(col)*d + CGFloat(c)*s + 0.8*(s - textSize.width)
                                y = gridOrigin.y + CGFloat(row)*d + CGFloat(r)*s + 0.5*(s - textSize.height)
                            } else if n == 5 {
                                x = gridOrigin.x + CGFloat(col)*d + CGFloat(c)*s + 0.5*(s - textSize.width)
                                y = gridOrigin.y + CGFloat(row)*d + CGFloat(r)*s + 0.5*(s - textSize.height)
                            } else if n == 6 {
                                x = gridOrigin.x + CGFloat(col)*d + CGFloat(c)*s + 0.2*(s - textSize.width)
                                y = gridOrigin.y + CGFloat(row)*d + CGFloat(r)*s + 0.5*(s - textSize.height)
                            } else if n == 7 {
                                x = gridOrigin.x + CGFloat(col)*d + CGFloat(c)*s + 0.8*(s - textSize.width)
                                y = gridOrigin.y + CGFloat(row)*d + CGFloat(r)*s + 0.2*(s - textSize.height)
                            } else if n == 8 {
                                x = gridOrigin.x + CGFloat(col)*d + CGFloat(c)*s + 0.5*(s - textSize.width)
                                y = gridOrigin.y + CGFloat(row)*d + CGFloat(r)*s + 0.2*(s - textSize.height)
                            } else if n == 9 {
                                x = gridOrigin.x + CGFloat(col)*d + CGFloat(c)*s + 0.2*(s - textSize.width)
                                y = gridOrigin.y + CGFloat(row)*d + CGFloat(r)*s + 0.2*(s - textSize.height)
                            }
                            let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
                            text.draw(in: textRect, withAttributes: pencilAttributes)
                        }
                    }
                }
            }
        }
    }
    
}
