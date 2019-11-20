//
//  DialogLabel.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/20.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

class DialogLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
    let topInset = CGFloat(15)
    let bottomInset = CGFloat(0)
    let leftInset = CGFloat(0)
    let rightInset = CGFloat(0)
    
}
