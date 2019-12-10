//
//  GameViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 21/09/2019.
//  Copyright © 2019 cochipcho. All rights reserved.
//
import UIKit
import StoreKit
import GoogleMobileAds
import Lottie

class GameViewController: UIViewController, GADRewardedAdDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(timerStateInAction),name:NSNotification.Name(rawValue: "resumeTimer"), object: nil)
        self.navigationController?.didMove(toParent: self)
        
        // IAP - written in order
        SKPaymentQueue.default().add(self)
        productIDs.append("ADRemover")
        productIDs.append("Chances")
        requestProductInfo()
        
        // Configurations
        loadSavedLivesAndSelectedBoxIfSaved()
        keypadAutoResize()
        biTitleSetup()
        timerSetup()
        boardSetup()
        undoRedoButtonState()
        redoUndoStateSetup()
        chanceSetup()
        lifeCounter()
        difficultyLabelOutlet.text = appDelegate.sudoku.grid.gameDiff
        pencilOn = false
        
        // Admob setup
        if !appDelegate.hasADRemoverBeenBought() {
            bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)//kGADAdSizeBanner)
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        interstitial = createAndLoadInterstitial()
        rewardedAD = createAndLoadRewardedAD()
        
        // Tap gesture setup
        if shouldTipView() {
            singleTapGestureRecognizer = CustomTapGestureRecognizer(target: self, action: #selector(singleTapped(sender:)))
            singleTapGestureRecognizer.numberOfTapsRequired = 1
            sudokuView.addGestureRecognizer(singleTapGestureRecognizer)
        }
        
        doubleTapGestureRecognizer = CustomTapGestureRecognizer(target: self, action: #selector(doubleTapped(sender:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        sudokuView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        NotificationCenter.default.addObserver(self, selector: #selector(pageController),name:NSNotification.Name(rawValue: "pageControl"), object: nil)
        let scale: CGFloat = 0.65
        for dot in pageControl.subviews{
            dot.transform = CGAffineTransform.init(scaleX: 1/scale, y: 1/scale)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(refresher),name:NSNotification.Name(rawValue: "refresher"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(abandon),name:NSNotification.Name(rawValue: "abandon"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(popAD),name:NSNotification.Name(rawValue: "popAD"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chanceSetup),name:NSNotification.Name(rawValue: "userEarnedaChance"), object: nil)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // Switches
    var IAPPurchase: PurchasingIAP = .none {
        didSet {
            switch IAPPurchase {
            case .ADRemover :
                let removerKey = "ADRemover5"
                let userDefault = appDelegate.userDefault
                userDefault.set("ADRemoverBought", forKey: removerKey)
                dismiss(animated: true) {
                    self.instantiatingCustomAlertView()
                    self.delegate?.customAlertController(title: "THANK YOU FOR PURCHASE".localized(), message: "Turn the app off and on to remove ADs forever!".localized(), option: .oneButton)
                    self.delegate?.customAction1(title: "OK".localized(), action: { xx in
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                    self.present(self.customAlertView, animated: true, completion: nil)
                }
                
            case .Chances :
                appDelegate.storeItems(5)
                dismiss(animated: true) {
                    self.instantiatingCustomAlertView()
                    self.delegate?.customAlertController(title: "THANK YOU FOR PURCHASE".localized(), message: "You just got 5 chances!.".localized(), option: .oneButton)
                    self.delegate?.customAction1(title: "OK".localized(), action: { xx in
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                    self.present(self.customAlertView, animated: true, completion: nil)
                }
                chanceSetup()
            default : break
            }
        }
    }
    
    var menuState: MenuState = .collapsed {
        didSet {
            switch menuState {
            case .collapsed :
                menuOptionSelected = .none
                isMenuCollased = true
                recordButton.isHidden = true
                selfInstructionButton.isHidden = true
                iapButton.isHidden = true
                menuRewindButton.isHidden = true
                recordButton.fadeIn(object: recordButton, withDuration: 0.3)
                selfInstructionButton.fadeIn(object: selfInstructionButton, withDuration: 0.3)
                iapButton.fadeIn(object: iapButton, withDuration: 0.3)
                view.animateXPosition(target: menuView, targetPosition: self.view.frame.maxX)
                view.fadeIn(object: fadeView, withDuration: 0.3)
            case .expanded :
                menuOptionSelected = .none
                if isMenuCollased {
                    view.fadeOut(object: fadeView, withDuration: 0.3)
                    isMenuCollased = !isMenuCollased
                }
                recordButton.isHidden = false
                selfInstructionButton.isHidden = false
                iapButton.isHidden = false
                menuRewindButton.isHidden = true
                recordButton.fadeOut(object: recordButton, withDuration: 0.3)
                selfInstructionButton.fadeOut(object: selfInstructionButton, withDuration: 0.3)
                iapButton.fadeOut(object: iapButton, withDuration: 0.3)
                let menuWidth = self.view.frame.width*0.82
                view.animateXPosition(target: menuView, targetPosition: self.view.frame.maxX-menuWidth)
                view.animateXPosition(target: dismissButton, targetPosition: (menuView.bounds.maxX-40)-(self.view.frame.maxX-menuWidth))
                view.animateXPosition(target: bannerCase, targetPosition: (dummyView.frame.size.width-bannerCase.frame.size.width)/2)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "recordsRefresher"), object: nil, userInfo: nil)
            case .fullyExpanded :
                menuOptionSelected = .none
                recordButton.isHidden = true
                selfInstructionButton.isHidden = true
                iapButton.isHidden = true
                menuRewindButton.isHidden = false
                recordButton.fadeIn(object: recordButton, withDuration: 0.3)
                selfInstructionButton.fadeIn(object: selfInstructionButton, withDuration: 0.3)
                iapButton.fadeIn(object: iapButton, withDuration: 0.3)
                menuView.frame.size.width = self.view.frame.size.width
                view.animateXPosition(target: menuView, targetPosition: self.view.frame.minX)
                view.animateXPosition(target: dismissButton, targetPosition: menuView.bounds.maxX-100)
                dismissButton.animateXPosition(target: dismissButton, targetPosition: menuView.bounds.maxX-40)
                view.animateXPosition(target: bannerCase, targetPosition: (menuView.frame.size.width-bannerCase.frame.size.width)/2)
            }
        }
    }
    
    var menuOptionSelected: MenuOptionSelected = .none {
        didSet {
            switch menuOptionSelected {
            case .none :
                shopLabel.isHidden = true
                recordLabel.isHidden = true
                recordsContainerView.isHidden = true
                recordIndicatorButtonLeft.isHidden = true
                recordIndicatorButtonRight.isHidden = true
                pageControl.isHidden = true
                recordBGView.isHidden = true
                recordViewSmoleImage.isHidden = true
                recordStackView.isHidden = true
                iapView.isHidden = true
                instructionView.isHidden = true
                smoleMenuImage.isHidden = true
            case .recordView :
                menuConsts()
                shopLabel.isHidden = true
                recordLabel.isHidden = false
                recordsContainerView.isHidden = false
                recordIndicatorButtonLeft.isHidden = false
                recordIndicatorButtonRight.isHidden = false
                pageControl.isHidden = false
                recordBGView.isHidden = false
                recordViewSmoleImage.isHidden = false
                recordStackView.isHidden = false
                iapView.isHidden = true
                instructionView.isHidden = true
                smoleMenuImage.isHidden = true
            case .instructionView :
                menuConsts()
                shopLabel.isHidden = true
                recordLabel.isHidden = true
                recordsContainerView.isHidden = true
                recordIndicatorButtonLeft.isHidden = true
                recordIndicatorButtonRight.isHidden = true
                pageControl.isHidden = true
                recordBGView.isHidden = true
                recordViewSmoleImage.isHidden = true
                recordStackView.isHidden = true
                iapView.isHidden = true
                instructionView.isHidden = false
                smoleMenuImage.isHidden = false
            case .iapView :
                menuConsts()
                shopLabel.isHidden = false
                recordLabel.isHidden = true
                recordsContainerView.isHidden = true
                recordIndicatorButtonLeft.isHidden = true
                recordIndicatorButtonRight.isHidden = true
                pageControl.isHidden = true
                recordBGView.isHidden = true
                recordViewSmoleImage.isHidden = true
                recordStackView.isHidden = true
                iapView.isHidden = false
                instructionView.isHidden = true
                smoleMenuImage.isHidden = true
            }
        }
    }
    
    // Written Views
//    let IAPtipView = UIView()
//    let IAPtipLabel = UILabel()
//    let IAPtipSmole = UIImageView()
//    var IAPtipSmoleImage = UIImage()
//    let IAPtipViewDismissButton = UIButton()
//    var IAPtipViewDismissImage = UIImage()
    let tipView = UIView()
    let tipLabel = UILabel()
    let tipSmole = UIImageView()
    var tipSmoleImage = UIImage()
    let tipViewDismissButton = UIButton()
    var tipViewDismissImage = UIImage()
    let menuView = UIView()
    let fadeView = UIView()
    let dummyView = UIView()
    let bannerCase = UIView()
    let instructionView = UIView()
    let iapView =  UIView()
    let recordStackView = UIStackView()
    let menuStackview = UIStackView()
    let dismissButton = UIButton()
    let recordButton = UIButton()
    let selfInstructionButton = UIButton()
    let iapButton = UIButton()
    let menuRewindButton = UIButton()
    let shopLabel = UILabel()
    let chanceView = UIView()
    let recordLabel = UILabel()
    let recordEasyBttn = UIButton()
    let recordNormalBttn = UIButton()
    let recordHardBttn = UIButton()
    let recordExpertBttn = UIButton()
    let recordHoriSV = UIStackView()
    let levelButtonsCollection = [UIButton]()
    let recordIndicatorButtonLeft = CustomButton()
    let recordIndicatorButtonRight = CustomButton()
    let pageControl = UIPageControl()
    let recordsContainerView = UIView()
    let recordsPageVC = RecordsPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    let recordViewSmoleImage = UIImageView()
    let smoleMenuImage = UIImageView()
    let recordBGView = RecordsCircleView()
    var interstitial: GADInterstitial!
    var bannerView: GADBannerView!
    var rewardedAD = GADRewardedAd.init(adUnitID: "ca-app-pub-3940256099942544/1712485313")
    var delegate: GameViewControllerDelegate?
    var customAlertView = CustomAlertViewController()
    var doubleTapGestureRecognizer = CustomTapGestureRecognizer()
    var singleTapGestureRecognizer = CustomTapGestureRecognizer()
    
    // Properties
    static var difficultyTitle: String!
    static var isPlayingSavedGame = false
    static var index = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let yellow = UIColor(red: 236.0 / 255.0, green: 224.0 / 255.0, blue: 98.0 / 255.0, alpha: 1.0)
    let mint = UIColor(red: 198.0 / 255.0, green: 237.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    let pink = #colorLiteral(red: 1, green: 0.7889312506, blue: 0.7353969216, alpha: 1)
    let mintKeypad = #colorLiteral(red: 0.7360653281, green: 0.9351958632, blue: 0.9233928323, alpha: 1)
    let screenWidth = UIScreen.main.bounds.width
    var pencilOn = false
    var isMenuCollased = true
    var productIDs: Array<String> = []
    var productsArray: Array<SKProduct> = []
    var transactionInProgress = false
    var lives = [Bool]()
    var isRewarded = false
    var shouldAnotherLife = false
    var shouldAddChance = false
    var randomNums = [Int]()
    var blanksNums = [Int]()
    var hasUserRewarded = false
    var isADFreeIAPButtonTapped = false
    var isChanceIAPButtonTapped = false
    
    // stop watch values
    var seconds = Int()
    var minutes = Int()
    var hours = Int()
    var record = String()
    var counter = 0
    var timer = Timer()
    var isPlaying = false
    
    // IB Action & Outlets
    @IBOutlet weak var puzzleArea: SudokuView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var sudokuView: SudokuView!
    @IBOutlet weak var biOutlet: UILabel!
    @IBOutlet weak var difficultyLabelOutlet: UILabel!
    @IBOutlet weak var timerOutlet: UILabel!
    @IBOutlet var dummyCollection: [UIView] = []
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerImageView: UIImageView!
    @IBOutlet var keypadCollection: [UIButton]!
    @IBOutlet weak var undoButtonOutlet: UIButton!
    @IBOutlet weak var redoButtonOutlet: UIButton!
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var timerSwitch: UIButton!
    @IBOutlet weak var chanceButtonOutlet: UIButton!
    @IBOutlet weak var lifeSmole: UIImageView!
    @IBOutlet weak var lifeRemained: UILabel!
    
    
    @IBAction func keypad(_ sender: UIButton) {
        playSound(soundFile: "sample1")
        let grid = appDelegate.sudoku.grid
        let row = puzzleArea.selected.row
        let col = puzzleArea.selected.column
        if (row != -1 && col != -1) {
            if pencilOn == false {
                if grid?.plistPuzzle[row][col] == 0 && grid?.userPuzzle[row][col] == 0  {
                    appDelegate.sudoku.userGrid(n: sender.tag, row: row, col: col)
                    // Game Finish Check - 0 is solved / 1 is unsolved / 2 is not finished
                    if appDelegate.sudoku.isGameSet(row: row, column: col) == 2 {
                        saveRecord()
                        let gameSolvedVC = storyboard?.instantiateViewController(withIdentifier: "GameSolvedVC") as? GameSolvedViewController
                        gameSolvedVC!.providesPresentationContextTransitionStyle = true
                        gameSolvedVC!.definesPresentationContext = true
                        gameSolvedVC!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        gameSolvedVC!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        self.present(gameSolvedVC!, animated: true, completion: nil)
                    } else {
                        if appDelegate.sudoku.isConflictingEntryAt(row: row, column: col) {
                            lives.append(false)
                            lifeCounter()
                            if lives.count == 3 {
                                // Stop timer
                                self.timerStateInAction()
                                // Pop dialog
                                instantiatingCustomAlertView()
                                self.delegate?.customAlertController(title: "NO LIFE".localized(), message: "Watch AD to get another life or leave the game.".localized(), option: .twoButtons)
                                self.delegate?.customAction1(title: "WATCH AD".localized(), action: { xx in
                                    // AD PLAY
                                    self.shouldAnotherLife = true
                                    self.dismiss(animated: true, completion: {
                                        self.popRewardADforLife()
                                        self.refresh()
                                    })
                                })
                                self.delegate?.customAction2(title: "LEAVE".localized(), action: { xx in
                                    DispatchQueue.main.async {
                                        self.dismiss(animated: true, completion: {
                                            self.dismiss(animated: true, completion: nil)
                                            self.abandon()
                                        })
                                    }
                                })
                                self.present(self.customAlertView, animated: true, completion: nil)
                            }
                        }
                    }
                } else if grid?.plistPuzzle[row][col] == 0 || grid?.userPuzzle[row][col] == sender.tag {
                    appDelegate.sudoku.userGrid(n: 0, row: row, col: col)
                }
            } else {
                appDelegate.sudoku.pencilGrid(n: sender.tag, row: row, col: col)
            }
            undoRedoButtonState()
            refresh()
        }
    }
    
    @IBAction func timerTapped(_ sender: UIButton) {
        timerStateInAction()
        let pauseVC = storyboard?.instantiateViewController(withIdentifier: "PauseVC") as? PauseViewController
        pauseVC!.providesPresentationContextTransitionStyle = true
        pauseVC!.definesPresentationContext = true
        pauseVC!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pauseVC!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(pauseVC!, animated: true, completion: nil)
    }
    
    @IBAction func pencilOn(_ sender: UIButton) {
        let pinkPencil = UIImage(named: "btnBottomMemoSelected.png")
        let pinkPencilPressed = UIImage(named: "btnBottomMemoSelectedPressed.png")
        let yellowPencil = UIImage(named: "btnBottomMemoNormal.png")
        let yellowPencilPressed = UIImage(named: "btnBottomMemoPressed.png")
        
        pencilOn = !pencilOn
        sender.isSelected = pencilOn
        if sender.isSelected == true {
            pencilButton.setImage(pinkPencilPressed, for: .normal)
            pencilButton.setImage(pinkPencil, for: .selected)
            for keypad in keypadCollection {
                keypad.setTitleColor(pink, for: .normal)
            }
        } else {
            pencilButton.setImage(yellowPencil, for: .normal)
            pencilButton.setImage(yellowPencilPressed, for: .selected)
            for keypad in keypadCollection {
                keypad.setTitleColor(mintKeypad, for: .normal)
            }
        }
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        instantiatingCustomAlertView()
        delegate?.customAlertController(title: "END GAME?".localized(), message: "Would you leave the game or save it for later?".localized(), option: .threeButtons)
        delegate?.customAction1(title: "LEAVE".localized(), action: { action in
            self.abandon()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
        delegate?.customAction2(title: "SAVE".localized(), action:  { action in
            let row = self.puzzleArea.selected.row
            let col = self.puzzleArea.selected.column
            
            self.appDelegate.sudoku.grid.savedTime = self.counter
            self.appDelegate.sudoku.grid.savedOutletTime = self.timerOutlet.text!
            self.appDelegate.sudoku.grid.lifeRemained = self.lives
            self.appDelegate.sudoku.grid.savedCol = col
            self.appDelegate.sudoku.grid.savedRow = row
            
            self.appDelegate.saveLocalStorage(save: self.appDelegate.sudoku.grid)
            self.timer.invalidate()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                    self.delegate?.customAlertController(title: "SAVED".localized(), message: "You can continue the game later.".localized(), option: .oneButton)
                    self.delegate?.customAction1(title: "OK".localized(), action: { xx in
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: {
                                self.dismiss(animated: true, completion: nil)
                            })
                        }
                    })
                    self.present(self.customAlertView, animated: true, completion: nil)
                })
            }
        })
        delegate?.customAction3(title: "CANCEL".localized(), action : { action in
            self.customAlertView.dismiss(animated: true, completion: nil)
        })
        present(customAlertView, animated: true, completion: nil)
    }
    
    @IBAction func undoButtonTapped(_ sender: Any) {
        if pencilOn {
            appDelegate.sudoku.undoPencil()
        } else {
            appDelegate.sudoku.undoGrid()
        }
        undoRedoButtonState()
        refresh()
    }
    
    @IBAction func redoButtonTapped(_ sender: Any) {
        let puzzle = self.appDelegate.sudoku
        if pencilOn {
            if !puzzle.grid.undonePencil.isEmpty {
                let redo = puzzle.grid.undonePencil.removeFirst()
                puzzle.grid.pencilPuzzle = redo
                puzzle.grid.pencilStack.append(redo)
            }
        } else {
            if !puzzle.grid.undonePuzzle.isEmpty {
                let redo = puzzle.grid.undonePuzzle.removeFirst()
                puzzle.grid.userPuzzle = redo
                puzzle.grid.puzzleStack.append(redo)
            }
        }
        undoRedoButtonState()
        refresh()
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        // methods in order (for constraints)
        timerStateInAction()
        makeFadeView()
        makeMenuRewindButton()
        makeMenuView()
        makeMenuButtons()
        makeMenuStackview()
        addMenuViewThenAnimate()
        makeConstToStackView()
        if !appDelegate.hasADRemoverBeenBought() {
            makeBannerCase()
        }
        makeRecordView()
        makeInstructionView()
        makeIAPView()
        
        menuState = .expanded
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        instantiatingCustomAlertView()
        delegate?.customAlertController(title: "REFRESH GAME?".localized(), message: "Tap OK to refresh.".localized(), option: .twoButtons)
        delegate?.customAction1(title: "OK".localized(), action:  { action in
            self.refresher()
        })
        delegate?.customAction2(title: "CANCEL".localized(), action : { action in
            self.customAlertView.dismiss(animated: true, completion: nil)
        })
        present(customAlertView, animated: true, completion: nil)
    }
    
    @IBAction func chanceButtonTapped(_ sender: Any) {
        let row = puzzleArea.selected.row
        let col = puzzleArea.selected.column
        let grid = appDelegate.sudoku.grid
        
        // 1. Fix값이 없고 셀이 선택된 상태라면
        if row > -1 || col > -1 {
            if grid?.plistPuzzle[row][col] == 0 {
                // 1. chance가 있을 경우 : 바로 animation을 띄워서 정답을 알려준다
                // 2. chance가 없을 경우 : 전면 광고를 한 번(혹은 2-3번) 띄운 후 정답을 알려준다
                let chance = appDelegate.item?.chances
                if !chance!.isEmpty {
                    if shouldRandomNum() {
                        let randomNum = random(4) // random rate (1/4) // 4(25%)
                        randomNums.append(randomNum)
                        if randomNum == 3 || (randomNums.count >= 9 && blanksNums.count == 0) { // 3. 1) randomNum이 3이면 꽝으로 한다, 2) 10회 찬스 사용할 동안 최소 1회는 꽝이 나오게 한다
                            blanksNums.append(0)
                            if col == 8 { // 3-1. 8th column은 다른 Chance<Index>Side를 실행
                                playAnimation(answer: appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col), point: sudokuView.cgPointForSelectedBox, isColumn8: true, isBlank: true)
                            } else { // 3-2. 나머지 column은 Chance<Index>를 실행
                                playAnimation(answer: appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col), point: sudokuView.cgPointForSelectedBox, isColumn8: false, isBlank: true)
                            }
                            appDelegate.spendItem()
                            self.chanceSetup()
                        } else {
                            activateChance()
                        }
                    } else {
                        activateChance()
                    }
                } else {
                    shouldAddChance = true
                    timerStateInAction()
                    popRewardADforChance() // check ad is avail first then play ad
                }
            } else {
                instantiatingCustomAlertView()
                self.delegate?.customAlertController(title: "WRONG BOX SELECTED".localized(), message: "Select a box you want to use your chance for!".localized(), option: .oneButton)
                self.delegate?.customAction1(title: "OK".localized(), action: { xx in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                self.present(self.customAlertView, animated: true, completion: nil)
            }
        } else {
            instantiatingCustomAlertView()
            self.delegate?.customAlertController(title: "NO BOX SELECTED".localized(), message: "Select a box you want to use your chance for!".localized(), option: .oneButton)
            self.delegate?.customAction1(title: "OK".localized(), action: { xx in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            self.present(self.customAlertView, animated: true, completion: nil)
        }
    }
    
    func saveRecord() {
        // timer 종료
        timer.invalidate()
        
        // 기존 기록 로드할 인스턴스
        var load = [Record]()
        
        // level 인스턴스
        let level = appDelegate.sudoku.grid.gameDiff
        
        // 기존 기록이 존재할 경우, 각 기록의 new기록 flag를 false로 변경 후 다시 기존 기록으로 저장 (new 기록을 흰색으로 바꿔야 하기 때문)
        if let records = Record.loadRecord(forKey: level) {
            for r in records {
                r.isNew = false
                load.append(r)
            }
        }
        
        // convert hours/minuntes to seconds
        let secondsCombined = seconds + (minutes*60) + ((hours*60)*60)
        
        // initialize Record() then append to load array
        let save = Record(record: record, recordInSecond: secondsCombined, isNew: true)
        load.append(save)
        
        // sort it out in big to small order
        let sorted = load.sorted { $0.recordInSecond < $1.recordInSecond }
        
        Record.saveRecord(record: sorted, forKey: level)
    }
    
    func loadSavedLivesAndSelectedBoxIfSaved() {
        if GameViewController.isPlayingSavedGame == true {
            if let load = appDelegate.load  {
                lives = appDelegate.sudoku.grid.lifeRemained
                sudokuView.selected.row = load.savedRow
                sudokuView.selected.column = load.savedCol
                GameViewController.isPlayingSavedGame = false
            }
        }
    }
    
    func embed(_ viewController:UIViewController, inParent controller:UIViewController, inView view:UIView){
        viewController.willMove(toParent: controller)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        controller.addChild(viewController)
        viewController.didMove(toParent: controller)
    }
    
    func allSet() { // In order
        makeFadeView()
        makeMenuRewindButton()
        makeMenuView()
        makeMenuButtons()
        makeMenuStackview()
        addMenuViewThenAnimate()
        makeConstToStackView()
        if !appDelegate.hasADRemoverBeenBought() {
            makeBannerCase()
        }
        makeRecordView()
        makeInstructionView()
        makeIAPView()
        
        menuState = .expanded
    }
    
    @objc func refresh() {
        sudokuView.setNeedsDisplay()
    }
    
    @objc func dismissButtonTapped() {
        timerStateInAction()
        menuState = .collapsed
    }
    
    @objc func recordButtonTapped() {
        menuState = .fullyExpanded
        menuOptionSelected = .recordView
    }
    
    @objc func selfInstructionButtonTapped() {
        menuState = .fullyExpanded
        menuOptionSelected = .instructionView
    }
    
    @objc func iapButtonTapped(){
        menuState = .fullyExpanded
        menuOptionSelected = .iapView
    }
    
    @objc func menuRewindButtonTapped() {
        menuState = .expanded
    }
    
    @objc func abandon() {
        let puzzle = self.appDelegate.sudoku
        puzzle.clearUserPuzzle()
        puzzle.clearPlistPuzzle()
        puzzle.clearPencilPuzzle()
        puzzle.grid.undonePuzzle.removeAll()
        puzzle.grid.puzzleStack.removeAll()
        timer.invalidate()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func refresher() {
        let puzzle = self.appDelegate.sudoku
        puzzle.clearUserPuzzle()
        puzzle.clearPencilPuzzle()
        puzzle.grid.undonePuzzle.removeAll()
        puzzle.grid.puzzleStack.removeAll()
        puzzle.grid.undonePuzzle.removeAll()
        puzzle.grid.gameDiff = puzzle.grid.gameDiff
        
        let array = self.appDelegate.getPuzzles(puzzle.grid.gameDiff)
        let answerArray = appDelegate.getPuzzles(puzzle.grid.gameDiff+"Answers")
        let puzzleIndex = random(array.count)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[puzzleIndex], toughness: puzzle.grid.gameDiff)
        puzzle.grid.puzzleAnswer = puzzle.plistToPuzzle(plist: answerArray[puzzleIndex], toughness: puzzle.grid.gameDiff+"Answers")
        
        // re-draw Board view
        timerOutlet.text = "00:00:00"
        timer.invalidate()
        counter = 0
        isPlaying = false
        timerStateInAction()
        self.sudokuView.selected = (row: -1, column: -1)
        self.sudokuView.setNeedsDisplay()
        undoRedoButtonState()
        randomNums.removeAll()
        blanksNums.removeAll()
        lives.removeAll()
        lifeCounter()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func pageController() {
        pageControl.currentPage = GameViewController.index
    }
    
}
