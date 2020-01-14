//
//  Array.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
extension Array where Element : Collection,Element.Iterator.Element : Equatable, Element.Index == Int {
    func indices(of x: Element.Iterator.Element) -> (Int, Int)? {
        for (i, row) in self.enumerated() {
            if let j = row.firstIndex(of: x) {
                return (i, j)
            }
        }
        return nil
    }
}
