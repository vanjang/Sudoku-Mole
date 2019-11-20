//
//  AppDelegate.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 20/09/2019.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var sudoku: SudokuClass = SudokuClass()
    var load: SudokuData?
    var item: SudokuIAP?
    let userDefault = UserDefaults.standard
    let itemKey = "IAPKey33"
    let ADRemoverKey = "ADRemover5"
    
    // ---------[ getPuzzles ]---------------------
    func getPuzzles(_ name : String) -> [String] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "plist") else { return [] }
        guard let data = try? Data(contentsOf: url) else { return [] }
        guard let array = try? PropertyListDecoder().decode([String].self, from: data) else { return [] }
        return array
    }
    // ---------
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // retrieve items or nil
        if retrieveItems() != nil {
            print("retrievednitems IS NOT nil")
            item = retrieveItems()
        } else {
            print("retrievednitems IS nil")
            let iap = SudokuIAP()
            //            iap.chances = []
            iap.chances = ["CHANCE", "CHANCE", "CHANCE", "CHANCE", "CHANCE"]
            item = iap
            storeItems(nil)
        }
        
        //                window = UIWindow(frame: UIScreen.main.bounds)
        //                let containerViewController = ContainerViewController()
        //
        //                window!.rootViewController = containerViewController
        //
        //                window!.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    // ---------------------[ Save files ]----------------------------
    func saveLocalStorage(save: SudokuData) {
        // Use Filemanager to store Local files
        let documentsDirectory =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let saveURL = documentsDirectory.appendingPathComponent("sudoku_save")
            .appendingPathExtension("plist")
        // Encode and save to Local Storage
        //let propertyListEncoder = PropertyListEncoder()
        let saveGame = try? PropertyListEncoder().encode(save) // TODO: error here -- notes
        ((try? saveGame?.write(to: saveURL)) as ()??)
    } // end saveLocalStorage()
    
    // ---------------------[ Load Files ]-----------------------------
    func loadLocalStorage() -> SudokuData? {
        let documentsDirectory =
            FileManager.default.urls(for: .documentDirectory,
                                     in: .userDomainMask).first!
        let loadURL = documentsDirectory.appendingPathComponent("sudoku_save").appendingPathExtension("plist")
        // Decode and Load from Local Storage
        if let data = try? Data(contentsOf: loadURL) {
            let decoder = PropertyListDecoder()
            load = try? decoder.decode(SudokuData.self, from: data)
            // once loaded, delete save
            try? FileManager.default.removeItem(at: loadURL)
        }
        
        return load
    }
    
    // ---------------------[ Save Items ]-----------------------------
    func storeItems(_ chances: Int?) {
        
        if chances != nil {
            for _ in 1 ... chances! {
                item?.chances.append("CHANCE")
            }
        }
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(item)
        
        print("will save")
        if let savingData = data {
            print("data saved")
            userDefault.set(savingData, forKey: itemKey)
            dump(item?.chances)
        } else {
            print("encoding failed")
        }
    }
    //    func storeItems() {
    //        let jsonEncoder = JSONEncoder()
    //        let data = try? jsonEncoder.encode(item)
    //
    //        print("will save")
    //        if let savingData = data {
    //            print("data saved")
    //            userDefault.set(savingData, forKey: key)
    //            dump(item?.chances)
    //        } else {
    //            print("encoding failed")
    //        }
    //    }
    // ---------------------[ Spend Items ]-----------------------------
    func spendItem() {
        if !item!.chances.isEmpty {
            item?.chances.removeLast()
            storeItems(nil)
        } else {
            print("no chance to use")
        }
    }
    
    // ---------------------[ Load Items ]-----------------------------
    func retrieveItems() -> SudokuIAP? {
        let sudokuItem: SudokuIAP?
        guard let retrievedItem = userDefault.data(forKey: itemKey) else {
            print("////////////")
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
            print("ad remover has not been bought")
            return false
        }
        bought = true
//        var bought = true
        return bought
    }
    
}
