//
//  RecordCircularView.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/15.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

class RecordsCircleView: UIView {
    override func draw(_ rect: CGRect) {
        let ovalRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint.zero, radius: ovalRect.width / 3.2, startAngle: 180 * CGFloat(Double.pi)/180, endAngle: 0 * CGFloat(Double.pi)/180, clockwise: true)
        ovalPath.addLine(to: CGPoint.zero)
        ovalPath.close()

        var ovalTransform = CGAffineTransform(translationX: ovalRect.midX, y: ovalRect.maxY)
        ovalTransform = ovalTransform.scaledBy(x: 3.4, y: ovalRect.height/ovalRect.width)
        ovalPath.apply(ovalTransform)

        #colorLiteral(red: 0.008900940418, green: 0.6047113538, blue: 0.325410217, alpha: 1).setFill()
        ovalPath.fill()
    }
}

