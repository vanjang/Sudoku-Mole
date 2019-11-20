//
//  GameSolvedViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/01.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit
import Lottie
import GoogleMobileAds
import LinkPresentation

enum GameSolvedButtons {
    case refreshTapped
    case homeTapped
    case SNSTapped
    case none
}

extension GameSolvedViewController: GADInterstitialDelegate {
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        //        popAD()
        print("interstitialDidReceiveAd")
    }
    
    //    /// Tells the delegate an ad request failed.
    //    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
    //      print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    //    }
    //
    //    /// Tells the delegate that an interstitial will be presented.
    //    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
    //      print("interstitialWillPresentScreen")
    //    }
    //
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        tappedButton()
        
        
        //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresher"), object: nil, userInfo: nil)
        print("interstitialWillDismissScreen")
    }
    //
    //    /// Tells the delegate that a user click will open another app
    //    /// (such as the App Store), backgrounding the current app.
    //    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
    //      print("interstitialWillLeaveApplication")
    //    }
}


class GameSolvedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var selectedButton: GameSolvedButtons = .none
    
    // Tableview datasource
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        records!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordsCell", for: indexPath) as! GameSolvedTableViewCell
        cell.cellUpdate(records: records!, indexPath: indexPath)
//        var number = 1
//        var numbers = [String]()
//        
//        for _ in records! {
//            numbers.append("\(number).")
//            number += 1
//        }
//        
//        cell.textLabel?.adjustsFontSizeToFitWidth = true
//        cell.textLabel?.text = numbers[indexPath.row]
//        cell.textLabel?.backgroundColor = .clear
//        cell.textLabel?.font = UIFont(name: "LuckiestGuy-Regular", size: 32.0)
//        
//        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
//        cell.detailTextLabel?.text = records![indexPath.row].record
//        cell.detailTextLabel?.backgroundColor = .clear
//        cell.detailTextLabel?.font = UIFont(name: "LuckiestGuy-Regular", size: 32.0)
//        
//        if records![indexPath.row].isNew {
//            cell.textLabel?.textColor = .white
//            cell.detailTextLabel?.textColor = .white
//        } else {
//            cell.textLabel?.textColor = #colorLiteral(red: 1, green: 0.7889312506, blue: 0.7353969216, alpha: 1)
//            cell.detailTextLabel?.textColor = #colorLiteral(red: 1, green: 0.7889312506, blue: 0.7353969216, alpha: 1)
//        }
//        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        buttonSetup()
        if !appDelegate.hasADRemoverBeenBought() {
            interstitial = createAndLoadInterstitial()
        }
        
if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "Simulator iPhone 8" || UIDevice.modelName == "Simulator iPhone 7" {
            flag.font = UIFont(name: "LuckiestGuy-Regular", size: 39)
        }
                
//        recordViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordViewSetup()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    var hasADbeenUsed = false
    var interstitial: GADInterstitial!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var records: [Record]?
    
    @IBOutlet weak var flag: CircularLabel!
    @IBOutlet weak var boardImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var superDummy: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    func buttonSetup() {
        let refreshNormal = UIImage(named: "btnBottomResetLargeNormal.png")
        let refreshPressed = UIImage(named: "btnBottomResetLargePressed.png")
        let homeNormal = UIImage(named: "btnBottomHomeLargeNormal.png")
        let homePressed = UIImage(named: "btnBottomHomeLargePressed.png")
        let shareNormal = UIImage(named: "btnBottomShareLargeNormal.png")
        let sharePressed = UIImage(named: "btnBottomShareLargePressed.png")
        
        refreshButton.setImage(refreshNormal, for: .normal)
        refreshButton.setImage(refreshPressed, for: .selected)
        homeButton.setImage(homeNormal, for: .normal)
        homeButton.setImage(homePressed, for: .selected)
        shareButton.setImage(shareNormal, for: .normal)
        shareButton.setImage(sharePressed, for: .selected)
    }
    
    
    func takeScreenshot(_ shouldSave: Bool = true) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
   
    
    func tappedButton() {
        if selectedButton == .refreshTapped {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresher"), object: nil, userInfo: nil)
        } else if selectedButton == .homeTapped {
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "abandon"), object: nil, userInfo: nil)
            }
        } else if selectedButton == .SNSTapped {
            
            print("SNS Tapped")
            let title = "Share Sudoku Mole through your SNS and get free chance!"
//            let url = URL(string: "https://apps.apple.com/kr/app/keep-password-diary/id1482176404")!
            let url = URL(string: "SudokuMole://test")!
            let image = takeScreenshot()
            var items = [Any]()
            
            if UIApplication.shared.canOpenURL(url as URL)
            {
                print("app installed")
//                UIApplication.shared.open(url)
                items = [title, image!]

            } else {
                print("App not installed")
                items = [image!, title, url]
//                items = [url, image!]
            }
            
            
     
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            
            
            
//            let activityVC = UIActivityViewController(activityItems: [title, url, image!], applicationActivities: nil)
            activityVC.excludedActivityTypes = [.addToReadingList, .assignToContact, .copyToPasteboard, .markupAsPDF, .openInIBooks, .print, .saveToCameraRoll]
//            let activity = UIActivityViewController(activityItems: [title, url, image, nil], applicationActivities: nil)
//            activity.popoverPresentationController?.barButtonItem = sender
            
            activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                if !completed {
                    // User canceled
                    return
                }
                // User completed activity
                self.appDelegate.storeItems(1)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userEarnedaChance"), object: nil, userInfo: nil)
                
                // dialog to pop
                self.instantiatingCustomAlertView()
                self.delegate?.customAlertController(title: "Thank you for sharing!", message: "You earned a free chance!", option: .oneButton)
                self.delegate?.customAction1(title: "OK", action: { xx in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                self.present(self.customAlertView, animated: true, completion: nil)
                print("user completed sharing")
            }
            
            
            // 3
            present(activityVC, animated: true, completion: nil)
            
            
        } else if selectedButton == .none {
            print("None Tapped")
        }
    }
    
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        self.selectedButton = .refreshTapped
        if appDelegate.hasADRemoverBeenBought() {
            tappedButton()
        } else {
            DispatchQueue.main.async {
                self.popAD()
            }
        }
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        self.selectedButton = .homeTapped
        if appDelegate.hasADRemoverBeenBought() {
            tappedButton()
        } else {
            DispatchQueue.main.async {
                self.popAD()
            }
        }
    }
    
    @IBAction func snsTapped(_ sender: Any) {
        self.selectedButton = .SNSTapped
            tappedButton()

    }
     

    func recordViewSetup() {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
        
         let level = appDelegate.sudoku.grid.gameDiff
        
        if let records = Record.loadRecord(forKey: level) {
 //       if let records = Record.loadRecord() {
            self.records = records
            for r in self.records! {
                if r.isNew {
                    flag.text = r.record
                    
                    let index = self.records!.firstIndex(of: r)
                    let indexPath = IndexPath(row: index!, section: 0)
                    
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    
                    if index == 0 {
                        let easy = UIImage(named: "boardRecordNewEasy.png")
                        let normal = UIImage(named: "boardRecordNewNormal.png")
                        let hard = UIImage(named: "boardRecordNewHard.png")
                        let expert = UIImage(named: "boardRecordNewExpert.png")
                        
                        switch appDelegate.sudoku.grid.gameDiff {
                        case "Easy" : boardImage.image = easy
                        case "Normal" : boardImage.image = normal
                        case "Hard" : boardImage.image = hard
                        case "Expert" : boardImage.image = expert
                        default : break
                        }
                        flag.textColor = #colorLiteral(red: 1, green: 0.9337611198, blue: 0.2692891061, alpha: 1)
                        
                        let leftAni = AnimationView(name: "159-servishero-loading")
                        let centreAni = AnimationView(name: "159-servishero-loading")
                        let rightAni = AnimationView(name: "159-servishero-loading")
                        
                        let leftFrame = CGRect(x: view.frame.minX, y: view.frame.height*0.22, width: view.frame.size.width*0.18, height: view.frame.size.width*0.18)
                        print(view.frame.minX)
                        let centreFrame = CGRect(x: view.frame.width*0.3, y: view.frame.height*0.01, width: view.frame.size.width*0.18, height: view.frame.size.width*0.18)
                        let rightFrame = CGRect(x: view.frame.width*0.75, y: view.frame.height*0.1, width: view.frame.size.width*0.24, height: view.frame.size.width*0.24)
                        
                        view.addSubview(leftAni)
                        view.addSubview(centreAni)
                        view.addSubview(rightAni)

                        leftAni.frame = leftFrame
                        leftAni.backgroundColor = .clear
                        leftAni.animationSpeed = 1.15
                        leftAni.loopMode = .loop
                        leftAni.play()
                        
                        centreAni.frame = centreFrame
                        centreAni.backgroundColor = .clear
                        centreAni.animationSpeed = 1.00
                        centreAni.loopMode = .loop
                        centreAni.play()

                        rightAni.frame = rightFrame
                        rightAni.backgroundColor = .clear
                        rightAni.animationSpeed = 1.5
                        rightAni.loopMode = .loop
                        rightAni.play()
                    } else {
                        let easy = UIImage(named: "boardRecordNormalEasy.png")
                        let normal = UIImage(named: "boardRecordNormalNormal.png")
                        let hard = UIImage(named: "boardRecordNormalHard.png")
                        let expert = UIImage(named: "boardRecordNormalExpert.png")
                        
                        switch appDelegate.sudoku.grid.gameDiff {
                        case "Easy" : boardImage.image = easy
                        case "Normal" : boardImage.image = normal
                        case "Hard" : boardImage.image = hard
                        case "Expert" : boardImage.image = expert
                        default : break
                        }
                        flag.textColor = #colorLiteral(red: 0.1999788582, green: 0.2000134587, blue: 0.1999712586, alpha: 1)
                    }
                }
            }
        } else {
            self.records = [Record(record: "", recordInSecond: 0, isNew: false)]
        }
    }
    
    func popAD() { //completion: () -> Void) {
//        if !hasADbeenUsed {
            if interstitial.isReady {
                print("pop addddd")
                interstitial.present(fromRootViewController: self)
                hasADbeenUsed = true
            }
            else {
                print("not ready")
            }
            
//        }
//        completion()
    }
     var customAlertView = CustomAlertViewController()
    var delegate: GameViewControllerDelegate?
    
    func instantiatingCustomAlertView() {
         customAlertView = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertViewController
         customAlertView.providesPresentationContextTransitionStyle = true
         customAlertView.definesPresentationContext = true
         customAlertView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
         customAlertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
         self.delegate = customAlertView
     }
    
}
