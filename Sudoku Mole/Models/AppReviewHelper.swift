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
    
    static func incrementNewRecordCountAndRequestReview(completion: @escaping () -> Void) {
        guard var newRecordCount = defaults.value(forKey: userDefaultKey) as? Int else {
            defaults.set(1, forKey: userDefaultKey)
            return
        }
        newRecordCount += 1
        defaults.set(newRecordCount, forKey: userDefaultKey)
        if newRecordCount == 2 {
            completion()
        }
        if newRecordCount == 20 || newRecordCount == 45 || newRecordCount == 60 || newRecordCount == 75 || newRecordCount == 90 {
            SKStoreReviewController.requestReview()
        }
    }
    
    static func requestReview() {
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id1487378544?action=write-review") else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
}
