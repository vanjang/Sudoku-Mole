//
//  File.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/15.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

class GridView: UIView {
    private var path = UIBezierPath()
    let borderColor = #colorLiteral(red: 0.5343368649, green: 0.2786505818, blue: 0.1829650402, alpha: 1)

    fileprivate var gridWidthMultiple: CGFloat {
        return 7
    }

    fileprivate var gridHeightMultiple : CGFloat {
        return 20
    }

    fileprivate var gridWidth: CGFloat {
        return bounds.width/CGFloat(gridWidthMultiple)
    }

    fileprivate var gridHeight: CGFloat {
        return bounds.height/CGFloat(gridHeightMultiple)
    }

    fileprivate var gridCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }

    fileprivate func drawGrid() {
        path = UIBezierPath()
        path.lineWidth = 1.0

        for index in 1...Int(gridWidthMultiple) - 1 {
            let start = CGPoint(x: CGFloat(index) * gridWidth, y: 0)
            let end = CGPoint(x: CGFloat(index) * gridWidth, y:bounds.height)
            path.move(to: start)
            path.addLine(to: end)
        }

        for index in 1...Int(gridHeightMultiple) - 1 {
            let start = CGPoint(x: 0, y: CGFloat(index) * gridWidth)
            let end = CGPoint(x: bounds.height, y: CGFloat(index) * gridWidth)
            path.move(to: start)
            path.addLine(to: end)
        }
        //Close the path.
        path.close()

    }

    override func draw(_ rect: CGRect) {
        drawGrid()
        // Specify a border (stroke) color.
        borderColor.setStroke()
        path.stroke()
    }
}
