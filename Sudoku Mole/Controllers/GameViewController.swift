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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.didMove(toParent: self)
        
        // IAP - written in order
        SKPaymentQueue.default().add(self)
        productIDs.append("ADRemover")
        productIDs.append("Chances")
        requestProductInfo()
        
        // Configurations
        keypadAutoResize()
        biTitleSetup()
        timerSetup()
        boardSetup()
        undoRedoButtonState()
        buttonStateSetup()
        chanceSetup()
        lifeCounter()
        difficultyLabelOutlet.text = appDelegate.sudoku.grid.gameDiff
        pencilOn = false
        
        // Admob setup
        if !appDelegate.hasADRemoverBeenBought() {
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }
        interstitial = createAndLoadInterstitial()
        rewardedAD = createAndLoadRewardedAD()
        
        // Double tap gesture setup
        let doubleTapGestureRecognizer = CustomTapGestureRecognizer(target: self, action: #selector(doubleTapped(sender:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        sudokuView.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        pageControl.currentPage = GameViewController.index
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
        NotificationCenter.default.addObserver(self, selector: #selector(timerStateInAction),name:NSNotification.Name(rawValue: "resumeTimer"), object: nil)
    }
    
    // Switches
    var IAPPurchase: PurchasingIAP = .none {
        didSet {
            switch IAPPurchase {
            case .ADRemover :
                let removerKey = "ADRemover5"
                let userDefault = appDelegate.userDefault
                userDefault.set("ADRemoverBought", forKey: removerKey)
            case .Chances :
                appDelegate.storeItems(5)
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
                let menuWidth = self.view.frame.width*0.8
                view.animateXPosition(target: menuView, targetPosition: self.view.frame.maxX-menuWidth)
                view.animateXPosition(target: dismissButton, targetPosition: (menuView.bounds.maxX-40)-(self.view.frame.maxX-menuWidth))
                view.animateXPosition(target: bannerCase, targetPosition: (dummyView.frame.size.width-bannerCase.frame.size.width)/2)
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
            case .recordView :
                menumConsts()
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
            case .instructionView :
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
            case .iapView :
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
            }
        }
    }
    
    // Written Views
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
    let smole = AnimationView(name: "159-servishero-loading")
    let smoleSide = AnimationView(name: "11282-bread-toaster")
    let chanceView = UIView()
    let recordLabel = UILabel()
    let recordEasyBttn = UIButton()
    let recordNormalBttn = UIButton()
    let recordHardBttn = UIButton()
    let recordExpertBttn = UIButton()
    let recordHoriSV = UIStackView()
    let levelButtonsCollection = [UIButton]()
    let recordIndicatorButtonLeft = UIButton()
    let recordIndicatorButtonRight = UIButton()
    let pageControl = UIPageControl()
    let recordsContainerView = UIView()
    let recordsPageVC = RecordsPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    let recordViewSmoleImage = UIImageView()
    let recordBGView = RecordsCircleView()
    var interstitial: GADInterstitial!
    var bannerView: GADBannerView!
    var rewardedAD = GADRewardedAd.init(adUnitID: "ca-app-pub-3940256099942544/1712485313")
    var delegate: GameViewControllerDelegate?
    var customAlertView = CustomAlertViewController()
    
    // Properties
    static var difficultyTitle: String!
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
    @IBOutlet var keypadCollection: [UIButton]!
    @IBOutlet weak var undoButtonOutlet: UIButton!
    @IBOutlet weak var redoButtonOutlet: UIButton!
    @IBOutlet weak var pencilButton: UIButton!
    @IBOutlet weak var timerSwitch: UIButton!
    @IBOutlet weak var chanceButtonOutlet: UIButton!
    @IBOutlet weak var lifeSmole: UIImageView!
    @IBOutlet weak var lifeRemained: UILabel!
    
    @IBAction func keypad(_ sender: UIButton) {
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
                            print(lives)
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
                                        self.popRewardAD()
                                        self.appDelegate.sudoku.userGrid(n: 0, row: row, col: col)
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
        delegate?.customAlertController(title: "IS IT AN END GAME?".localized(), message: "Would you leave the game or save for later?".localized(), option: .threeButtons)
        delegate?.customAction1(title: "LEAVE".localized(), action: { action in
            self.abandon()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
        delegate?.customAction2(title: "SAVE".localized(), action:  { action in
            self.appDelegate.sudoku.grid.savedTime = self.counter
            self.appDelegate.sudoku.grid.savedOutletTime = self.timerOutlet.text!
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
    
    @IBAction func chanceButtonTapped(_ sender: Any) {
        let row = puzzleArea.selected.row
        let col = puzzleArea.selected.column
        
        // 1. 셀이 선택된 상태라면
        if row > -1 || col > -1 {
            // 1. chance가 있을 경우 : 바로 animation을 띄워서 정답을 알려준다
            // 2. chance가 없을 경우 : 전면 광고를 한 번(혹은 2-3번) 띄운 후 정답을 알려준다
            let chance = appDelegate.item?.chances
            if !chance!.isEmpty {
                if shouldRandomNum() {
                    let randomNum = random(2) // random rate (1/4) // 4(25%)
                    randomNums.append(randomNum)
                    if randomNum == 1 || (randomNums.count >= 9 && blanksNums.count == 0) { // 3. randomNum이 3이면 꽝으로 한다, 2) 10회 찬스 사용할 동안 최소 1회는 꽝이 나오게 한다
                        blanksNums.append(0)
                        if col == 8 {
                            animateChanceView(lottie: smoleSide, point: sudokuView.cgPointForSelectedBox, size: sudokuView.sizeForSelectedBox)
                        } else {
                            animateChanceView(lottie: smole, point: sudokuView.cgPointForSelectedBox, size: sudokuView.sizeForSelectedBox)
                        }
                        appDelegate.spendItem()
                        self.chanceSetup()
                    } else {
                        chanceAction()
                    }
                } else {
                    chanceAction()
                }
            } else {
                shouldAddChance = true
                timerStateInAction()
                popRewardAD()
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
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        // methods in order (for constraints)
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
    
    // Methods for AD
    func popRewardAD() {
        if rewardedAD.isReady {
            rewardedAD.present(fromRootViewController: self, delegate: self)
        }
    }
    
    func createAndLoadRewardedAD() -> GADRewardedAd {
        let rewardedAD = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        rewardedAD.load(GADRequest()) { (error) in
            if error != nil {
                // No occured
            } else {
                // No error
            }
        }
        return rewardedAD
    }
    
    func keypadAutoResize() {
        for button in keypadCollection {
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.contentMode = .scaleToFill
            button.titleLabel?.baselineAdjustment = .alignBaselines
            button.titleLabel?.adjustsFontForContentSizeCategory = true
            if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "Simulator iPhone 8" || UIDevice.modelName == "Simulator iPhone 7" {
                button.titleLabel?.font = UIFont(name: "LuckiestGuy-Regular", size: 39.0)
            }
        }
    }
    
    func buttonStateSetup() {
        let undoNormal = UIImage(named: "btnBottomUndoNormal.png")
        let undoDisabled = UIImage(named: "btnBottomUndoDisabled.png")
        let undoPressed = UIImage(named: "btnBottomUndoPressed.png")
        let redoNormal = UIImage(named: "btnBottomRedoNormal.png")
        let redoDisabled = UIImage(named: "btnBottomRedoDisabled.png")
        let redoPressed = UIImage(named: "btnBottomRedoPressed.png")
        
        undoButtonOutlet.setImage(undoNormal, for: .normal)
        undoButtonOutlet.setImage(undoDisabled, for: .disabled)
        undoButtonOutlet.setImage(undoPressed, for: .highlighted)
        redoButtonOutlet.setImage(redoNormal, for: .normal)
        redoButtonOutlet.setImage(redoDisabled, for: .disabled)
        redoButtonOutlet.setImage(redoPressed, for: .highlighted)
    }
    
    func lifeCounter() {
        if lives.isEmpty {
            lifeRemained.text = "3"
        } else if lives.count == 1 {
            lifeRemained.text = "2"
        } else if lives.count == 2 {
            lifeRemained.text = "1"
        } else if lives.count == 3 {
            lifeRemained.text = "0"
        }
        self.view.layoutIfNeeded()
    }
    
    func undoRedoButtonState() {
        let puzzle = self.appDelegate.sudoku
        if pencilOn {
            if puzzle.grid.pencilStack.isEmpty {
                undoButtonOutlet.isEnabled = false
            } else {
                undoButtonOutlet.isEnabled = true
            }
            
            if puzzle.grid.undonePencil.isEmpty {
                redoButtonOutlet.isEnabled = false
            } else {
                redoButtonOutlet.isEnabled = true
            }
        } else {
            if puzzle.grid.puzzleStack.isEmpty {
                undoButtonOutlet.isEnabled = false
            } else {
                undoButtonOutlet.isEnabled = true
            }
            
            if puzzle.grid.undonePuzzle.isEmpty {
                redoButtonOutlet.isEnabled = false
            } else {
                redoButtonOutlet.isEnabled = true
            }
        }
    }
    
    func shouldRandomNum() -> Bool {
        var shouldBeRandom = Bool()
        if randomNums.count <= 5 && blanksNums.count >= 2 {
            shouldBeRandom = false
        } else if randomNums.count <= 10 && blanksNums.count >= 3 {
            shouldBeRandom = false
        } else {
            shouldBeRandom = true
        }
        return shouldBeRandom
    }
    
    func chanceAction() {
        let row = puzzleArea.selected.row
        let col = puzzleArea.selected.column
        if col == 8 {
            animateChanceView(lottie: smoleSide, point: sudokuView.cgPointForSelectedBox, size: sudokuView.sizeForSelectedBox)
        } else {
            animateChanceView(lottie: smole, point: sudokuView.cgPointForSelectedBox, size: sudokuView.sizeForSelectedBox)
        }
        appDelegate.spendItem()
        self.chanceSetup()
        print("chance : \(appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col))")
    }
    
    func animateChanceView(lottie: AnimationView, point: CGPoint, size: CGRect) {
        self.chanceButtonOutlet.isUserInteractionEnabled = false
        let p = ((size.width*1.35)-size.width)/2
        let frame = CGRect(x: point.x-p, y: point.y, width: size.width*1.35, height: size.height*1.35)
        chanceView.frame = frame
        chanceView.backgroundColor = .clear
        
        lottie.frame = frame
        lottie.center = chanceView.center
        lottie.contentMode = .scaleAspectFit
        lottie.backgroundColor = .clear
        
        sudokuView.addSubview(chanceView)
        sudokuView.addSubview(lottie)
        
        lottie.play { (finished) in
            self.chanceView.removeFromSuperview()
            lottie.removeFromSuperview()
            self.chanceButtonOutlet.isUserInteractionEnabled = true
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
    
    func embed(_ viewController:UIViewController, inParent controller:UIViewController, inView view:UIView){
        viewController.willMove(toParent: controller)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        controller.addChild(viewController)
        viewController.didMove(toParent: controller)
    }
    
    func menumConsts() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        let pageControlCenterConstraints = NSLayoutConstraint(item: self.pageControl, attribute: .centerX, relatedBy: .equal, toItem: menuView, attribute: .centerX, multiplier: 1, constant: -10)
        let pageControlTopConstraints = NSLayoutConstraint(item: self.pageControl, attribute: .top, relatedBy: .equal, toItem: recordsContainerView, attribute: .bottom, multiplier: 1, constant: -55)
        recordViewSmoleImage.translatesAutoresizingMaskIntoConstraints = false
        let smoleRightConstraints = NSLayoutConstraint(item: recordViewSmoleImage, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1, constant: -3)
        let smoleTopConstraints = NSLayoutConstraint(item: recordViewSmoleImage, attribute: .top, relatedBy: .equal, toItem: recordsContainerView, attribute: .bottom, multiplier: 1, constant: -115)
        
        menuView.bringSubviewToFront(recordViewSmoleImage)
        self.menuView.addConstraints([pageControlTopConstraints, pageControlCenterConstraints, smoleRightConstraints, smoleTopConstraints])
        menuView.bringSubviewToFront(recordIndicatorButtonLeft)
        menuView.bringSubviewToFront(recordIndicatorButtonRight)
        
        recordIndicatorButtonLeft.translatesAutoresizingMaskIntoConstraints = false
        let centerXRecordIndicatorButtonLeftConstraints = NSLayoutConstraint(item: recordIndicatorButtonLeft, attribute: .centerY, relatedBy: .equal, toItem: recordsContainerView, attribute: .centerY, multiplier: 1, constant: -30)
        let leftRecordIndicatorButtonLeftConstraints = NSLayoutConstraint(item: recordIndicatorButtonLeft, attribute: .left, relatedBy: .equal, toItem: menuView, attribute: .left, multiplier: 1, constant: 17)
        
        recordIndicatorButtonRight.translatesAutoresizingMaskIntoConstraints = false
        let centerXRecordIndicatorButtonRightConstraints = NSLayoutConstraint(item: recordIndicatorButtonRight, attribute: .centerY, relatedBy: .equal, toItem: recordsContainerView, attribute: .centerY, multiplier: 1, constant: -30)
        let rightRecordIndicatorButtonLeftConstraints = NSLayoutConstraint(item: recordIndicatorButtonRight, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1, constant: -17)
        
        self.menuView.addConstraints([centerXRecordIndicatorButtonLeftConstraints, leftRecordIndicatorButtonLeftConstraints, centerXRecordIndicatorButtonRightConstraints, rightRecordIndicatorButtonLeftConstraints])
    }
    
    func allSet() {
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
    
    @objc func popAD() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            // Ad wasn't ready
        }
    }
    
    @objc func doubleTapped(sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: sudokuView)
        let gridSize = sudokuView.bounds.width
        let gridOrigin = CGPoint(x: (sudokuView.bounds.width - gridSize)/2, y: (sudokuView.bounds.height - gridSize)/2)
        let d = gridSize/9
        let col = Int((tapPoint.x - gridOrigin.x)/d)
        let row = Int((tapPoint.y - gridOrigin.y)/d)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let puzzle = appDelegate.sudoku
        
        if  0 <= col && col < 9 && 0 <= row && row < 9 {
            if (!puzzle.numberIsFixedAt(row: row, column: col)) {
                if puzzle.grid?.userPuzzle[row][col] != 0 {
                    appDelegate.sudoku.userGrid(n: 0, row: row, col: col)
                    refresh()
                }
            }
        }
    }
    
    @objc func chanceSetup() {
        if !(appDelegate.item?.chances.isEmpty)! {
            let chanceImage = UIImage(named: "chance"+String(appDelegate.item!.chances.count)+".png")
            chanceButtonOutlet.setImage(chanceImage, for: .normal)
        } else {
            let chanceImage = UIImage(named: "chanceAD.png")
            chanceButtonOutlet.setImage(chanceImage, for: .normal)
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func timerStateInAction() {
        let play = UIImage(named: "icTimePlay.png")
        let pause = UIImage(named: "icTimeStop.png")
        
        isPlaying = !isPlaying
        if isPlaying == true {
            timerSwitch.setImage(pause, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            timerSwitch.setImage(play, for: .normal)
            timer.invalidate()
        }
    }
    
    @objc func refresh() {
        sudokuView.setNeedsDisplay()
    }
    
    @objc func updateTimer() {
        counter = counter + 1
        seconds = counter % 60
        minutes = (counter / 60) % 60
        hours = (counter / 3600)
        record = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        timerOutlet.text = record
    }
    
    @objc func dismissButtonTapped() {
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
        puzzle.grid.gameDiff = puzzle.grid.gameDiff
        let array = self.appDelegate.getPuzzles(puzzle.grid.gameDiff)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[random(array.count)], toughness: puzzle.grid.gameDiff)
        
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
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
