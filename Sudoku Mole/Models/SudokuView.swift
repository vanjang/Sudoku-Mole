//
//  SudokuView.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/15.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

//
// Compute font size for target box.
// http://goo.gl/jPL9Yu
//
func fontSizeFor(_ string : NSString, fontName : String, targetSize : CGSize) -> CGFloat {
    let testFontSize : CGFloat = 32
    let font = UIFont(name: fontName, size: testFontSize)
    let attr = [NSAttributedString.Key.font : font!]
    let strSize = string.size(withAttributes: attr)
    return testFontSize*min(targetSize.width/strSize.width, targetSize.height/strSize.height)
}

class SudokuView: UIView {
    
    var selected = (row : -1, column : -1)  // current selected cell in 9x9 puzzle (-1 => none)
    
    //
    // Allow user to "select" a non-fixed cell in the puzzle's 9x9 grid.
    // SudokuView를 self값으로 가져옴
    @IBAction func handleTap(_ sender : UIGestureRecognizer) {
        let tapPoint = sender.location(in: self)
        let gridSize = (self.bounds.width < self.bounds.height) ? self.bounds.width : self.bounds.height
        let gridOrigin = CGPoint(x: (self.bounds.width - gridSize)/2, y: (self.bounds.height - gridSize)/2)
        let d = gridSize/9
        let col = Int((tapPoint.x - gridOrigin.x)/d)
        let row = Int((tapPoint.y - gridOrigin.y)/d)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = appDelegate.sudoku
        
        if  0 <= col && col < 9 && 0 <= row && row < 9 {              // if inside puzzle bounds
            if (!puzzle.numberIsFixedAt(row: row, column: col)) {       // and not a "fixed number"
                if (row != selected.row || col != selected.column) {  // and not already selected
                    selected.row = row                                // then select cell
                    selected.column = col
                    setNeedsDisplay()                                 // request redraw ***** PuzzleView
                }
            }
        }
    }
    
    //
    // Draw sudoku board. The current puzzle state is stored in the "sudoku" property
    // stored in the app delegate.
    //
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        //
        // Fetch Sudoku puzzle model object from app delegate.
        //
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = appDelegate.sudoku
        //
        // Find largest square w/in bounds of view and use this to establish
        // grid parameters.
        //
        let gridSize = (self.bounds.width < self.bounds.height) ? self.bounds.width-5 : self.bounds.height-5
        let gridOrigin = CGPoint(x: (self.bounds.width - gridSize)*0+2.5, y: (self.bounds.height - gridSize)*0+2.5)
        let delta = gridSize/3
        let d = delta/3
                
        self.layer.cornerRadius = 16//16
        self.clipsToBounds = true
        self.backgroundColor = UIColor(red: 149.0 / 255.0, green: 79.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)//.clear
        
        let selectedCellColor = UIColor(red: 102/255, green: 52/255, blue: 0/255, alpha: 1)
        let selectedStrokeColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        let neighboringColor = UIColor(red: 135/255, green: 71/255, blue: 48/255, alpha: 1)
        let majorBorderColor = UIColor(red: 124.0 / 255.0, green: 63.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
        let minorBorderColor = UIColor(red: 122/255, green: 63/255, blue: 40/255, alpha: 1)
        let sameNumberColor = UIColor(red: 122/255, green: 66/255, blue: 45/255, alpha: 1)
        let sameNumberStrokeColoe = UIColor(red: 100/255, green: 56/255, blue: 40/255, alpha: 1)
        //
        // Fill selected cell (if one is selected by tap gesture recognizer).
        //
        if selected.row >= 0 && selected.column >= 0 {
            let x = gridOrigin.x + CGFloat(selected.column)*d
            let y = gridOrigin.y + CGFloat(selected.row)*d
            let numberAtSelectedRow = puzzle.userEntry(row: selected.row, column: selected.column)
            
            // fill 3x3 boxes
            for i in 0 ..< 3 {
                if selected.row >= 0 && selected.row < 3 && selected.column >= 0 && selected.column < 3 {
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: gridOrigin.x+CGFloat(i)*d, y: gridOrigin.y+CGFloat(j)*d, width: d, height: d))
                    }
                }
                
                if selected.row >= 0 && selected.row < 3 && selected.column >= 3 && selected.column < 6 {
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+delta, y: gridOrigin.y+CGFloat(j)*d, width: d, height: d))
                    }
                }

                if selected.row >= 0 && selected.row < 3 && selected.column >= 6 && selected.column < 9 {
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+(delta*2), y: gridOrigin.y+CGFloat(j)*d, width: d, height: d))
                    }
                }

                if selected.row >= 3 && selected.row < 6 && selected.column >= 0 && selected.column < 3 {
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: gridOrigin.x+CGFloat(i)*d, y: (gridOrigin.y+CGFloat(j)*d)+delta, width: d, height: d))
                    }
                }
                
                if selected.row >= 3 && selected.row < 6 && selected.column >= 3 && selected.column < 6 {
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+delta, y: (gridOrigin.y+CGFloat(j)*d)+delta, width: d, height: d))
                    }
                }

                if selected.row >= 3 && selected.row < 6 && selected.column >= 6 && selected.column < 9 {
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+(delta*2), y: (gridOrigin.y+CGFloat(j)*d)+delta, width: d, height: d))
                    }
                }
                
                if selected.row >= 6 && selected.row < 9 && selected.column >= 0 && selected.column < 3 {
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: gridOrigin.x+CGFloat(i)*d, y: (gridOrigin.y+CGFloat(j)*d)+(delta*2), width: d, height: d))
                    }
                }
                
                if selected.row >= 6 && selected.row < 9 && selected.column >= 3 && selected.column < 6 {
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+delta, y: (gridOrigin.y+CGFloat(j)*d)+(delta*2), width: d, height: d))
                    }
                }

                if selected.row >= 6 && selected.row < 9 && selected.column >= 6 && selected.column < 9 {
                    for j in 0 ..< 3 {
                        neighboringColor.setFill()
                        context?.fill(CGRect(x: (gridOrigin.x+CGFloat(i)*d)+(delta*2), y: (gridOrigin.y+CGFloat(j)*d)+(delta*2), width: d, height: d))
                    }
                }
            }
            
            // fill rows
            for i in 0 ..< 9 {
                neighboringColor.setFill()
                context?.fill(CGRect(x: gridOrigin.x + CGFloat(i)*d, y: y, width: d, height: d))
            }
            
            // fill cols and selected box
            for i in 0 ..< 9 {
                if y == gridOrigin.y+CGFloat(i)*d {
                    selectedCellColor.setFill()
                    selectedStrokeColor.setStroke()
                    context?.fill(CGRect(x: x, y: y, width: d, height: d))
                    context?.stroke(CGRect(x: x, y: y, width: d, height: d))
                } else {
                    neighboringColor.setFill()
                    context?.fill(CGRect(x: x, y: gridOrigin.y + CGFloat(i)*d, width: d, height: d))
                }
            }
            
            // fill same numbers with the number drawn in selected cell
            for r in 0 ..< 9 {
                for c in 0 ..< 9 {
                    let selectedBox = (row : r, column : c)
                    if numberAtSelectedRow != 0 && selected != selectedBox && (puzzle.userEntry(row: r, column: c) == numberAtSelectedRow || puzzle.grid.plistPuzzle[r][c] == numberAtSelectedRow) {
                        sameNumberColor.setFill()
                        sameNumberStrokeColoe.setStroke()
                        context?.fill(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
                        context?.stroke(CGRect(x: gridOrigin.x + CGFloat(c)*d, y: gridOrigin.y + CGFloat(r)*d, width: d, height: d))
                    }
                }
            }
        }
        
        //
        // masking bezier paths
        //
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
        
        //
        // Stroke outer puzzle rectangle
        // 3x3 corner radius
        //
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

        //
        // Stroke minor grid lines.
        //
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

        //
        // Fetch/compute font attribute information.
        //
        let fontName = "Helvetica-Light"
        let boldFontName = "Helvetica-Light"
        let pencilFontName = "Helvetica-Light"
        let fixtedFontColor = UIColor(red: 241/255, green: 221/255, blue: 128/255, alpha: 1)
        let userFontColor = UIColor(red: 195/255, green: 239/255, blue: 255/255, alpha: 1)
//        let conflictFontColor = UIColor(red: 195/255, green: 239/255, blue: 255/255, alpha: 1)
        let conflictFontColor = UIColor.red
        let pencilFontColor = UIColor(red: 241/255, green: 221/255, blue: 128/255, alpha: 1)
        
        let fontSize = fontSizeFor("0", fontName: boldFontName, targetSize: CGSize(width: d, height: d))
        
//        let boldFont = UIFont(name: boldFontName, size: fontSize)
        let font = UIFont(name: fontName, size: fontSize)
        let pencilFont = UIFont(name: pencilFontName, size: fontSize/3)
        
        let fixedAttributes = [NSAttributedString.Key.font : font!, NSAttributedString.Key.foregroundColor : fixtedFontColor]
        let userAttributes = [NSAttributedString.Key.font : font!, NSAttributedString.Key.foregroundColor : userFontColor]
        let conflictAttributes = [NSAttributedString.Key.font : font!, NSAttributedString.Key.foregroundColor : conflictFontColor]
        let pencilAttributes = [NSAttributedString.Key.font : pencilFont!, NSAttributedString.Key.foregroundColor : pencilFontColor]
        
        //
        // Fill in puzzle numbers.
        //
        for row in 0 ..< 9 {
            for col in 0 ..< 9 {
                
                var number : Int
                
                // 1. number initialize해주기
                // row & column은 0~8의 순차적 Int
                // userEntry는 예를 들어 row0, column0의 패러미터를 받아서 그 칸에 해당되는 유저가 채워넣은 숫자를 return한다
                
                // 만약 userEntry(row:,column:)이 0을 return한다면(유저가 채워넣은 칸이면 0은 return될 수 없다) 해당 칸의 숫자를 numberAt(row:,column:)을 통해 return한다(fixed). 만약 0이 아니라면 userEntry를 return한다.
                
                // row0 & col 0~8, row1 & col 0~8 로 채워나간다
                
                // 정리 : 각각의 칸(81칸)에 유저값이 있다면(!=0) 채워넣고 없다면 fix값 채워넣는다
                // 보드판 숫자 채워넣기위해 number에 유저 숫자 or 기본 숫자를 넣어준다
//                let conflict =  puzzle.isConflictingEntryAt(row: row, column: col)
//                print("\(row)\(col):\(conflict)")
                
                if puzzle.userEntry(row: row, column: col) != 0 {
                    number = puzzle.userEntry(row: row, column: col)
                    
//                    userEntryCellColor.setFill()
//                    context?.fill(CGRect(x: gridOrigin.x+CGFloat(row)*d, y: gridOrigin.y+CGFloat(col)*d, width: d, height: d))
//                    
                    
                } else {
                    number = puzzle.numberAt(row: row, column: col)
                }
                
                
                // string attribute 설정
                // number가 0보다 클 경우 : 유저가 해당 칸을 채워넣은 경우가 되겠다
                if (number > 0) {
                    var attributes : [NSAttributedString.Key : NSObject]? = nil
                    // 1. 가장 먼저 퍼즐 기본 숫자 넣어주기 (fixed)
                    if puzzle.numberIsFixedAt(row: row, column: col) {
                        attributes = fixedAttributes
                    // 2. 그리고 해당 셀이 오답이면 오답 폰트 넣기 (근데 오답 메소드가 뭔가 잘못됨, 확인해야 함)
                    } else if puzzle.isConflictingEntryAt(row: row, column: col) {
                        attributes = conflictAttributes
                    // 3. 마지막으로 - 기본 숫자 들어가고 오답도 들어갔으면 유저 숫자 넣기
                    } else if puzzle.userEntry(row: row, column: col) != 0 {
                        attributes = userAttributes
                    }
                    
                    // 보드에 이제 숫자를 그려 넣는다
                    let text = "\(number)" as NSString
                    let textSize = text.size(withAttributes: attributes)
                    let x = gridOrigin.x + CGFloat(col)*d + 0.5*(d - textSize.width)
                    let y = gridOrigin.y + CGFloat(row)*d + 0.5*(d - textSize.height)
                    let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
                    text.draw(in: textRect, withAttributes: attributes)
                    
                    // number가 0보다 작은 경우 : 해당 칸에 유저가 넣은 값이 없는 경우가 된다
                    // 유저값이 없는 경우에만 pencil값을 그려준다
                } else if puzzle.anyPencilSetAt(row: row, column: col) {
                    print("any pencil set at")
                    let s = d/3
                    for n in 1 ... 9 {
                        if puzzle.isSetPencil(n: n, row: row, column: col) {
                            let r = (n - 1) / 3
                            let c = (n - 1) % 3
                            let text : NSString = "\(n)" as NSString
                            let textSize = text.size(withAttributes: pencilAttributes)
                            let x = gridOrigin.x + CGFloat(col)*d + CGFloat(c)*s + 0.5*(s - textSize.width)
                            let y = gridOrigin.y + CGFloat(row)*d + CGFloat(r)*s + 0.5*(s - textSize.height)
                            let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
                            text.draw(in: textRect, withAttributes: pencilAttributes)
                            
                        }
                    }
                }
                
                // 숫자 1개에 해당되는 모든 빈칸을 제대로 넣은 경우 색 바꿔주기
                
                
            }
        }
        
    }

}
