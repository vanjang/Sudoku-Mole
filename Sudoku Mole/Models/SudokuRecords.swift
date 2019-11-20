//
//  RecordsData.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/03.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation

class Record: Codable, Equatable {
    static func == (lhs: Record, rhs: Record) -> Bool {
        return lhs.record == rhs.record && lhs.recordInSecond == rhs.recordInSecond && lhs.isNew == rhs.isNew
    }
    
    init (record: String, recordInSecond: Int, isNew: Bool) {
        self.record = record
        self.recordInSecond = recordInSecond
        self.isNew = isNew
    }
    
    static let userDefault = UserDefaults.standard
    static let jsonEncoder = JSONEncoder()
    static let jsonDecoder = JSONDecoder()
    var record: String
    var recordInSecond: Int
    var isNew: Bool
    
    static func saveRecord(record: [Record], forKey key: String) {
        if record.isEmpty != true {
            let data = try? jsonEncoder.encode(record)
            if let savingData = data {
                userDefault.set(savingData, forKey: key)
            }
        } else {
            // Rrecord data array is empty
        }
    }
    
    static func loadRecord(forKey key: String) -> [Record]? {
        guard let load = userDefault.data(forKey: key) else {
            return nil }
        let loadedData: [Record]?
        do {
            let data = try jsonDecoder.decode(Array<Record>.self, from: load)
            loadedData = data
        }
        catch {
            loadedData = nil
        }
        return loadedData
    }
    
}
