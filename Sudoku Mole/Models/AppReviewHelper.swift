//
//  AppReviewHelper.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/28.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import StoreKit

struct AppStoreReviewOperator {
    
    static let defaults = UserDefaults.standard
    static let userDefaultKey = "reviewOperator"
    
    static func incrementNewRecordCountAndRequestReview() {
        guard var newRecordCount = defaults.value(forKey: userDefaultKey) as? Int else {
            defaults.set(1, forKey: userDefaultKey)
            return
        }
        newRecordCount += 1
        defaults.set(newRecordCount, forKey: userDefaultKey)
        if newRecordCount == 15 || newRecordCount == 30 || newRecordCount == 45 {
            SKStoreReviewController.requestReview()
        }
    }
    
}
