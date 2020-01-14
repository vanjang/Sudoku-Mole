//
//  Home VC Puzzle Generator.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController {
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)
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
//        dump(arrays)
    }
}
