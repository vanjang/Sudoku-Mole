//
//  RecordsData.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/03.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation


//class Record: Codable, Equatable {
//
//    static func == (lhs: Record, rhs: Record) -> Bool {
//        return lhs.record == rhs.record && lhs.recordInSecond == rhs.recordInSecond && lhs.isNew == rhs.isNew
//    }
//
//    var record: String
//    var recordInSecond: Int
//    var isNew: Bool
//
//    init (record: String, recordInSecond: Int, isNew: Bool) {
//        self.record = record
//        self.recordInSecond = recordInSecond
//        self.isNew = isNew
//    }
//
//    static let userDefault = UserDefaults.standard
//    // tag1
//    //static let key = "record12"
//    static let key = "record20"
//    static let jsonEncoder = JSONEncoder()
//    static let jsonDecoder = JSONDecoder()
//
//    static func saveRecord(record: [Record]) {
//        if record.isEmpty != true {
//            let data = try? jsonEncoder.encode(record)
//            if let savingData = data {
//                userDefault.set(savingData, forKey: key)
//            }
//        } else {
//            print("record data array is empty")
//        }
//    }
//
//    static func loadRecord() -> [Record]? {
//        guard let load = userDefault.data(forKey: key) else {
//            print("it is nil")
//            return nil }
//        let loadedData: [Record]?
//        do {
//            let data = try jsonDecoder.decode(Array<Record>.self, from: load)
//            loadedData = data
//            print("do")
//        }
//        catch {
//            loadedData = nil
//            print("catch")
//        }
//        return loadedData
//    }
//
//
//
//}

// tag1 - recover below class instead
////
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

    var record: String
    var recordInSecond: Int
    var isNew: Bool

    init (record: String, recordInSecond: Int, isNew: Bool) {
        self.record = record
        self.recordInSecond = recordInSecond
        self.isNew = isNew
    }

    static let userDefault = UserDefaults.standard
    //static let key = "record12"
    static let jsonEncoder = JSONEncoder()
    static let jsonDecoder = JSONDecoder()

    static func saveRecord(record: [Record], forKey key: String) {
        if record.isEmpty != true {
            let data = try? jsonEncoder.encode(record)
            if let savingData = data {
                userDefault.set(savingData, forKey: key)
            }
        } else {
            print("record data array is empty")
        }
    }

    static func loadRecord(forKey key: String) -> [Record]? {
        guard let load = userDefault.data(forKey: key) else {
            print("it is nil")
            return nil }
        let loadedData: [Record]?
        do {
            let data = try jsonDecoder.decode(Array<Record>.self, from: load)
            loadedData = data
            print("do")
        }
        catch {
            loadedData = nil
            print("catch")
        }
        return loadedData
    }



}
