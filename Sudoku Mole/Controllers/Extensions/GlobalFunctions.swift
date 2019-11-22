//
//  GlobalFunctions.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/20.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

func random(_ n:Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

// Compute font size for target box.
// http://goo.gl/jPL9Yu
func fontSizeFor(_ string : NSString, fontName : String, targetSize : CGSize) -> CGFloat {
    let testFontSize : CGFloat = 20//30
    let font = UIFont(name: fontName, size: testFontSize)
    let attr = [NSAttributedString.Key.font : font!]
    let strSize = string.size(withAttributes: attr)
    return testFontSize*min(targetSize.width/strSize.width, targetSize.height/strSize.height)
}
