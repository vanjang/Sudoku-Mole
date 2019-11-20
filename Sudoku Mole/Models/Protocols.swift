//
//  Protocols.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/20.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation

protocol GameViewControllerDelegate: AnyObject {
    func customAlertController(title: String, message: String, option: DialogOption)
    func customAction1(title: String, action: ((Any) -> Void)!)
    func customAction2(title: String, action: ((Any) -> Void)!)
    func customAction3(title: String, action: ((Any) -> Void)!)
}
