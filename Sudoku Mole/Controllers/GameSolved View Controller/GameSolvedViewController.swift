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

class GameSolvedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordViewSetup()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }

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
        return cell
    }

    @IBOutlet weak var flag: CircularLabel!
    @IBOutlet weak var boardImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var superDummy: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func refreshTapped(_ sender: Any) {
        self.selectedButton = .refreshTapped
        if appDelegate.hasADRemoverBeenBought() {
            implementButtonAction()
        } else {
            DispatchQueue.main.async {
                self.popAD()
            }
        }
    }
    
    @IBAction func homeTapped(_ sender: Any) {
        self.selectedButton = .homeTapped
        if appDelegate.hasADRemoverBeenBought() {
            implementButtonAction()
        } else {
            DispatchQueue.main.async {
                self.popAD()
            }
        }
    }
    
    @IBAction func snsTapped(_ sender: Any) {
        self.selectedButton = .SNSTapped
        implementButtonAction()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var selectedButton: GameSolvedButtons = .none
    var hasADbeenUsed = false
    var interstitial: GADInterstitial!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var records: [Record]?
    var customAlertView = CustomAlertViewController()
    var delegate: GameViewControllerDelegate?
    var thumbnailImage: URL?
    var recordsImage: URL?
    
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
    
    func popAD() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            hasADbeenUsed = true
        } else {
            implementButtonAction()
        }
    }
    
    func instantiatingCustomAlertView() {
        customAlertView = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! CustomAlertViewController
        customAlertView.providesPresentationContextTransitionStyle = true
        customAlertView.definesPresentationContext = true
        customAlertView.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlertView.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.delegate = customAlertView
    }
    
    func saveImage(image: UIImage, compomentName: String) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        do {
            try data.write(to: directory.appendingPathComponent(compomentName)!)
            return
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func getSavedImageURL(named: String, from component: String) -> URL? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            let archiveURL = dir.appendingPathComponent(component)//.appendingPathExtension("plist")
            return archiveURL
        }
        return nil
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func implementButtonAction() {
        if selectedButton == .refreshTapped {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresher"), object: nil, userInfo: nil)
        } else if selectedButton == .homeTapped {
            self.dismiss(animated: true) {
                self.dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "abandon"), object: nil, userInfo: nil)
                }
            }
        } else if selectedButton == .SNSTapped {
            let url = URL(string: "SudokuMole://test")!
            //            let url = URL(string: "https://apps.apple.com/kr/app/keep-password-diary/id1482176404")! // FLAGED - CHANGE TO ACTUAL LINK
            
            let recordComponentKey = "thumbnail.png"
            let thumbnailCompenentKey = "MyRecords.png"
            saveImage(image: UIImage(named: "icon.png")!, compomentName: thumbnailCompenentKey)
            thumbnailImage = getSavedImageURL(named: "MyRecords.png", from: thumbnailCompenentKey)
            
            saveImage(image: takeScreenshot()!, compomentName: recordComponentKey)
            recordsImage = getSavedImageURL(named: "MyRecords.png", from: recordComponentKey)
            
            var items = [Any]()
            
            if UIApplication.shared.canOpenURL(url as URL) {
                items = [self]
            } else {
                items = [self, url]
            }
            
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityVC.excludedActivityTypes = [.addToReadingList, .assignToContact, .copyToPasteboard, .markupAsPDF, .openInIBooks, .print, .saveToCameraRoll]
            activityVC.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                if !completed {
                    return
                }
                self.appDelegate.storeItems(1)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userEarnedaChance"), object: nil, userInfo: nil)

                self.instantiatingCustomAlertView()
                self.delegate?.customAlertController(title: "THANK YOU FOR SHARING!".localized(), message: "You earned a free chance.".localized(), option: .oneButton)
                self.delegate?.customAction1(title: "OK".localized(), action: { xx in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                self.present(self.customAlertView, animated: true, completion: nil)
            }
            present(activityVC, animated: true, completion: nil)
        } else if selectedButton == .none {
            // None Tapped
        }
    }
    
    func recordViewSetup() {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
        
        let level = appDelegate.sudoku.grid.gameDiff
        if let records = Record.loadRecord(forKey: level) {
            self.records = records
            for r in self.records! {
                if r.isNew {
                    flag.text = r.record
                    let index = self.records!.firstIndex(of: r)
                    let indexPath = IndexPath(row: index!, section: 0)
                    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    
                    //                    if index != 0 {
                    if index == 0 {
                        AppStoreReviewOperator.incrementNewRecordCountAndRequestReview()
                        
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
                        
                        let firework = AnimationView(name: "Firework")
                        
                        view.addSubview(firework)
                        firework.isUserInteractionEnabled = false
//                        firework.frame = view.bounds
                        firework.frame.origin.x = 0
                        firework.frame.origin.y = 0
                        firework.backgroundColor = .clear
                        firework.animationSpeed = 1.00
                        firework.loopMode = .loop
                        firework.play()
                        
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
    
}
