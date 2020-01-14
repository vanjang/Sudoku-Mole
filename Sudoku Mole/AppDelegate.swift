//
//  AppDelegate.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 20/09/2019.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase
import AVFoundation
/// To delete
//import AppLovinAdapter
//import AppLovinSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var sudoku: SudokuClass = SudokuClass()
    var load: SudokuData?
    var item: SudokuIAP?
    let userDefault = UserDefaults.standard
    let itemKey = "IAPKey33"
    let ADRemoverKey = "ADRemover5"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// To delete
        //ALSdk.initializeSdk()
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        UserNotificationCentre.notificationCentre.requestAuthorization(options: [.alert, .sound])  { (didAllow, error) in
        }
        UserNotificationCentre.notificationSetup()
        
        if retrieveItems() != nil {
            item = retrieveItems()
        } else {
            let iap = SudokuIAP()
            iap.chances = ["CHANCE", "CHANCE"]
            item = iap
            storeItems(nil)
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        stopFirework()
        firework.stop()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        if isPlayingGame == true {
            saveLocalStorage(save: sudoku.grid)
        }
    }
    
    // ---------------------[ Get puzzles ]-----------------------------
    func getPuzzles(_ name : String) -> [String] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "plist") else { return [] }
        guard let data = try? Data(contentsOf: url) else { return [] }
        guard let array = try? PropertyListDecoder().decode([String].self, from: data) else { return [] }
        return array
    }
    
    // ---------------------[ Save game ]-----------------------------
    func saveLocalStorage(save: SudokuData) {
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(save)
        let saveKey = "saveData"
        if let savingData = data {
            userDefault.set(savingData, forKey: saveKey)
        } else {
            // Encoding failed
        }
    }
    
    // ---------------------[ Load saved game ]-----------------------------
    func loadLocalStorage() -> SudokuData? {
        let saveKey = "saveData"
        guard let retrievedItem = userDefault.data(forKey: saveKey) else {
            return nil }
        let jsonDecoder = JSONDecoder()
        do {
            let decoded = try jsonDecoder.decode(SudokuData.self, from: retrievedItem)
            load = decoded
        }
        catch {
            load = nil
        }
        return load
    }
    
    // ---------------------[ Save Chances ]-----------------------------
    func storeItems(_ chances: Int?) {
        if chances != nil {
            for _ in 1 ... chances! {
                item?.chances.append("CHANCE")
            }
        }
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(item)
        
        if let savingData = data {
            userDefault.set(savingData, forKey: itemKey)
        } else {
            // Encoding failed
        }
    }
    
    // ---------------------[ Spend Items ]-----------------------------
    func spendItem() {
        if !item!.chances.isEmpty {
            item?.chances.removeLast()
            storeItems(nil)
        } else {
            // No chance to use
        }
    }
    
    // ---------------------[ Load Items ]-----------------------------
    func retrieveItems() -> SudokuIAP? {
        let sudokuItem: SudokuIAP?
        guard let retrievedItem = userDefault.data(forKey: itemKey) else {
            return nil }
        
        let jsonDecoder = JSONDecoder()
        do {
            let decoded = try jsonDecoder.decode(SudokuIAP.self, from: retrievedItem)
            sudokuItem = decoded
        }
        catch {
            sudokuItem = nil
        }
        return sudokuItem
    }
    
    // ---------------------[ AD Remover checker ]-----------------------------
    func hasADRemoverBeenBought() -> Bool {
        var bought = false
        guard let _ = userDefault.string(forKey: ADRemoverKey) else {
            return false
        }
        bought = true
        return bought
    }
}
