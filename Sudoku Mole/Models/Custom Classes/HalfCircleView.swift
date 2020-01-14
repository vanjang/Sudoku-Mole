//
//  HalfCircleView.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/12.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

class HalfCircleView: UIView {
    override func draw(_ rect: CGRect) {
        let ovalRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint.zero, radius: ovalRect.width / 2, startAngle: 180 * CGFloat(Double.pi)/180, endAngle: 0 * CGFloat(Double.pi)/180, clockwise: true)
        ovalPath.addLine(to: CGPoint.zero)
        ovalPath.close()

        var ovalTransform = CGAffineTransform(translationX: ovalRect.midX, y: ovalRect.maxY)
        ovalTransform = ovalTransform.scaledBy(x: 1.35, y: ovalRect.height/ovalRect.width)
        ovalPath.apply(ovalTransform)

        #colorLiteral(red: 0, green: 0.5206592083, blue: 0.2923181951, alpha: 1).setFill()
        ovalPath.fill()
    }
}
