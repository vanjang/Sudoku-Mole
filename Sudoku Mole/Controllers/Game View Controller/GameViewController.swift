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

class GameViewController: UIViewController, GADRewardedAdDelegate, GADBannerViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(timerStateInAction),name:NSNotification.Name(rawValue: "resumeTimer"), object: nil)
        self.navigationController?.didMove(toParent: self)
        
        // Detect if game is in play to save when terminating
        isPlayingGame = true
        
        // BGM play
        playBGM(soundFile: "BGM", lag: 0.0, numberOfLoops: -1)
        
        // IAP - written in order
        SKPaymentQueue.default().add(self)
        productIDs.append("ADRemover")
        productIDs.append("Chances")
        requestProductInfo()
        
        // Configurations
        biTitleSetup()
        loadGameData()
        boardSetup()
        redoUndoButtonState()
        redoUndoStateSetup()
        chanceSetup()
        lifeCounter()
        refreshKeypad()
        difficultyLabelOutlet.text = appDelegate.sudoku.grid.gameDiff
        pencilOn = false
        autoSaving()
        
        // Admob setup
        if !appDelegate.hasADRemoverBeenBought() {
            createAndLoadBanner()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        isPlayingGame = false
    }
    
    override func viewDidLayoutSubviews() {
        NotificationCenter.default.addObserver(self, selector: #selector(pageController),name:NSNotification.Name(rawValue: "pageControl"), object: nil)
        let scale: CGFloat = 0.65
        for dot in pageControl.subviews{
            dot.transform = CGAffineTransform.init(scaleX: 1/scale, y: 1/scale)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // if user terminated app while in the countdown of Home VC, sound will continue on Game VC - So should explict stop here
        stopLevelSound()
        // if user terminated app while in the Game VC, sound will not resume when resuming game - So should explict play here
        playBGM(soundFile: "BGM", lag: 0.0, numberOfLoops: -1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresher),name:NSNotification.Name(rawValue: "refresher"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(abandon),name:NSNotification.Name(rawValue: "abandon"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(popAD),name:NSNotification.Name(rawValue: "popAD"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chanceSetup),name:NSNotification.Name(rawValue: "userEarnedaChance"), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        stopBGM()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Switches
    var IAPPurchase: PurchasingIAP = .none {
        didSet {
            switch IAPPurchase {
            case .ADRemover :
                let removerKey = "ADRemover"
                let userDefault = appDelegate.userDefault
                userDefault.set("ADRemoverBought", forKey: removerKey)
                dismiss(animated: true) {
                    self.instantiatingCustomAlertView()
                    self.delegate?.customAlertController(title: "THANK YOU FOR PURCHASE".localized(), message: "Turn the app off and on to remove ADs!".localized(), option: .oneButton)
                    self.delegate?.customAction1(title: "OK".localized(), action: { xx in
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                    self.present(self.customAlertView, animated: true, completion: nil)
                }
            case .chances :
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
    static var isSaveAvailable = true
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
    var lifeChanceFlagUp = Bool()
    var shouldAddChance = false
    var randomNums = [Int]()
    var blanksNums = [Int]()
    var hasUserRewarded = false
    var isADFreeIAPButtonTapped = false
    var isChanceIAPButtonTapped = false
    let pinkPencil = UIImage(named: "btnBottomMemoSelected.png")
    let pinkPencilPressed = UIImage(named: "btnBottomMemoSelectedPressed.png")
    let yellowPencil = UIImage(named: "btnBottomMemoNormal.png")
    let yellowPencilPressed = UIImage(named: "btnBottomMemoPressed.png")
    let userDefault = UserDefaults.standard
    let saveKey = "saveData"
    var solvedTimer = Timer()
    
    // stop watch values
    var seconds = Int()
    var minutes = Int()
    var hours = Int()
    var record = "00:00:00"
    var counter = 0
    var isTimerInMotion = false
    
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
        let grid = appDelegate.sudoku.grid
        let row = puzzleArea.selected.row
        let col = puzzleArea.selected.column
        if (row != -1 && col != -1) {
            if pencilOn == false {
                if grid?.plistPuzzle[row][col] == 0 && grid?.userPuzzle[row][col] == 0  {
                    playSound(soundFile: "inGameKeypad", lag: 0.0, numberOfLoops: 0)  // When tap a keypad
                    appDelegate.sudoku.userGrid(n: sender.tag, row: row, col: col) //  SAVE POINT
                    
                    // check if row/col/3x3 is filled without conflicts
                    if appDelegate.sudoku.isRowFilledWithoutConflict(row: row) {
                        isRowSpinningInMotion = true
                    }
                    
                    if appDelegate.sudoku.isColFilledWithoutConflict(col: col) {
                        isColSpinningInMotion = true
                    }
                    
                    if appDelegate.sudoku.is3X3FilledWithoutConflict(row : row, col: col) {
                        is3X3SpinningInMotion = true
                    }
                    
                    // Game Finish Check - 0 : game not finished / 1 : game finished but not correctly / 2 : game finished and correct
                    if appDelegate.sudoku.isGameSet(row: row, column: col) == 2 {
                        // pop solved VC with a little bit delay to show spinning animation completely
                        solvedTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(solveDialogPops), userInfo: nil, repeats: true)
                    } else {
                        if appDelegate.sudoku.isConflictingEntryAt(row: row, column: col) {
                            playSound(soundFile: "inGameWrong", lag: 0.0, numberOfLoops: 0) // When tap a wrong answer
                            lives.append(false)
                            lifeCounter()
                            if lives.count == 3 {
                                instantiatingCustomAlertView()
                                self.delegate?.customAlertController(title: "NO LIFE".localized(), message: "Watch AD to get another life and continue solving!".localized(), option: .twoButtons)
                                self.delegate?.customAction1(title: "WATCH AD".localized(), action: { xx in
                                    // AD PLAY
                                    self.shouldAnotherLife = true
                                    self.lifeChanceFlagUp = true
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
                        } else {
                            if appDelegate.sudoku.isThisNumAllFilled(num: sender.tag) {
                                keypadStateInAction()
                            }
                        }
                    }
                } else if grid?.plistPuzzle[row][col] == 0 || grid?.userPuzzle[row][col] == sender.tag {
                    playSound(soundFile: "inGameKeypad", lag: 0.0, numberOfLoops: 0)  // When deleting by a keypad
                    appDelegate.sudoku.userGrid(n: 0, row: row, col: col)
                    if !appDelegate.sudoku.isThisNumAllFilled(num: sender.tag) {
                        keypadStateInAction()
                    }
                }
            } else {
                playSound(soundFile: "inGameKeypad", lag: 0.0, numberOfLoops: 0)  // When tapping a keypad in pencil mode
                appDelegate.sudoku.pencilGrid(n: sender.tag, row: row, col: col)
            }
            redoUndoButtonState()
            refresh()
        } else {
            playSound(soundFile: "inGameKeypad", lag: 0.0, numberOfLoops: 0)
        }
    }
    
    @IBAction func timerTapped(_ sender: UIButton) {
        guard let bgmPlayer = bgmPlayer else { return }
        if bgmPlayer.isPlaying {
            pauseBGM()
        } else {
            resumeBGM()
        }
        playSound(soundFile: "inGamePause", lag: 0.0, numberOfLoops: 0)
        timerStateInAction()
        let pauseVC = storyboard?.instantiateViewController(withIdentifier: "PauseVC") as? PauseViewController
        pauseVC!.providesPresentationContextTransitionStyle = true
        pauseVC!.definesPresentationContext = true
        pauseVC!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        pauseVC!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(pauseVC!, animated: true, completion: nil)
    }
    
    @IBAction func pencilOn(_ sender: UIButton) {
        playSound(soundFile: "inGameMenuAndButtons", lag: 0.0, numberOfLoops: 0)
        pencilOn = !pencilOn
        sender.isSelected = pencilOn
        if sender.isSelected == true {
            redoUndoButtonState()
            setPencilButtonStateWhenSelected()
        } else {
            redoUndoButtonState()
            setPencilButtonStateWhenUnselected()
        }
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        playSound(soundFile: "inGameMenuAndButtons", lag: 0.0, numberOfLoops: 0)
        instantiatingCustomAlertView()
        delegate?.customAlertController(title: "END GAME?".localized(), message: "Would you leave the game or save it for later?".localized(), option: .threeButtons)
        delegate?.customAction1(title: "LEAVE".localized(), action: { action in
            self.abandon()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        })
        delegate?.customAction2(title: "SAVE".localized(), action:  { action in
            self.appDelegate.saveLocalStorage(save: self.appDelegate.sudoku.grid)
            timer.invalidate()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                    self.delegate?.customAlertController(title: "SAVED".localized(), message: "You can continue the game later.".localized(), option: .oneButton)
                    self.delegate?.customAction1(title: "OK".localized(), action: { xx in
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: {
                                stopBGM()
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
        playSound(soundFile: "inGameMenuAndButtons", lag: 0.0, numberOfLoops: 0)
        if pencilOn {
            appDelegate.sudoku.undoPencil()
        } else {
            appDelegate.sudoku.undoGrid()
        }
        redoUndoButtonState()
        refresh()
    }
    
    @IBAction func redoButtonTapped(_ sender: Any) {
        playSound(soundFile: "inGameMenuAndButtons", lag: 0.0, numberOfLoops: 0)
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
        redoUndoButtonState()
        refresh()
    }
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        playSound(soundFile: "inGameMenuAndButtons", lag: 0.0, numberOfLoops: 0)
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
        playSound(soundFile: "inGameMenuAndButtons", lag: 0.0, numberOfLoops: 0)
        instantiatingCustomAlertView()
        delegate?.customAlertController(title: "REFRESH GAME?".localized(), message: "Tap OK to refresh.".localized(), option: .twoButtons)
        delegate?.customAction1(title: "OK".localized(), action:  { action in
            self.refresher()
            self.dismiss(animated: true, completion: nil)
        })
        delegate?.customAction2(title: "CANCEL".localized(), action : { action in
            self.customAlertView.dismiss(animated: true, completion: nil)
        })
        present(customAlertView, animated: true, completion: nil)
    }
    
    @IBAction func chanceButtonTapped(_ sender: Any) {
        playSound(soundFile: "inGameMenuAndButtons", lag: 0.0, numberOfLoops: 0)
        let row = puzzleArea.selected.row
        let col = puzzleArea.selected.column
        let grid = appDelegate.sudoku.grid
        let chance = appDelegate.item?.chances
        
        // 1. Fix값이 없고 셀이 선택된 상태라면
        if row > -1 || col > -1 {
            if grid?.plistPuzzle[row][col] == 0 {
                // 1. chance가 있을 경우 : 바로 animation을 띄워서 정답을 알려준다
                // 2. chance가 없을 경우 : 전면 광고를 한 번(혹은 2-3번) 띄운 후 정답을 알려준다
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
        } else if chance!.isEmpty {
            shouldAddChance = true
            popRewardADforChance() // check ad is avail first then play ad
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
    
    func embed(_ viewController:UIViewController, inParent controller:UIViewController, inView view:UIView){
        viewController.willMove(toParent: controller)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        controller.addChild(viewController)
        viewController.didMove(toParent: controller)
    }
    
    func setPencilButtonStateWhenSelected() {
        pencilButton.setImage(pinkPencilPressed, for: .normal)
        pencilButton.setImage(pinkPencil, for: .selected)
        for keypad in keypadCollection {
            keypad.setTitleColor(pink, for: .normal)
        }
    }
    
    func setPencilButtonStateWhenUnselected() {
        pencilButton.setImage(yellowPencil, for: .normal)
        pencilButton.setImage(yellowPencilPressed, for: .selected)
        for keypad in keypadCollection {
            keypad.setTitleColor(mintKeypad, for: .normal)
        }
    }
    
    func keypadStateInAction() {
        let filledNum = appDelegate.sudoku.grid.savedFilledNum
        var fontSize = CGFloat()
        let fontColor = #colorLiteral(red: 0.8421699405, green: 0.9555736184, blue: 1, alpha: 1)
        let clearColor = UIColor.clear
        var keypadNumber = Int()
        
        if deviceScreenHasNotch() {
            fontSize = 42.0
        } else {
            fontSize = 35.0
        }
        
        let font = UIFont(name: "LuckiestGuy-Regular", size: fontSize)
        var attributeKey = [NSAttributedString.Key : Any]()
        let clearAttributes: [NSAttributedString.Key : Any] = [ .font : font as Any ,.foregroundColor: clearColor ,.strokeWidth: 2.0, .strokeColor: fontColor]
        let normalAttributes: [NSAttributedString.Key : Any] = [ .font : font as Any ,.foregroundColor: fontColor,.strokeWidth: -2.0]//, .strokeColor: fontColor]
//        let normalAttributes: [NSAttributedString.Key : Any] = [ .font : font as Any ,.foregroundColor: fontColor]
        
        for button in keypadCollection {
            
            button.titleLabel?.numberOfLines = 1
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.contentMode = .scaleToFill
            button.titleLabel?.baselineAdjustment = .alignBaselines
            button.titleLabel?.adjustsFontForContentSizeCategory = true
            
            keypadNumber = button.tag
            
            if filledNum[keypadNumber] == true {
                attributeKey = clearAttributes
            } else {
                attributeKey = normalAttributes
            }
            
            let attribute = NSAttributedString(string: String(keypadNumber), attributes: attributeKey)
            button.setAttributedTitle(attribute, for: .normal)
        }
        
    }
    
    func refreshKeypad() {
        for i in 1...9 {
            if appDelegate.sudoku.isThisNumAllFilled(num: i) {
                keypadStateInAction()
            }
        }
    }
    
    @objc func solveDialogPops() {
        if isPlayingSavedGame {
            userDefault.removeObject(forKey: saveKey)
            isPlayingSavedGame = false
        }
        stopBGM()
        saveRecord()
        let gameSolvedVC = storyboard?.instantiateViewController(withIdentifier: "GameSolvedVC") as? GameSolvedViewController
        gameSolvedVC!.providesPresentationContextTransitionStyle = true
        gameSolvedVC!.definesPresentationContext = true
        gameSolvedVC!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        gameSolvedVC!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(gameSolvedVC!, animated: true, completion: nil)
        solvedTimer.invalidate()
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
    
    // CRASH POINT - abandon된 후에 appdelegate의 didenterbg가 실행되어 save되면 퍼즐은 모두 0으로 save된다 - 주의!!
    @objc func abandon() {
        let puzzle = self.appDelegate.sudoku
        puzzle.clearUserPuzzle()
        puzzle.clearPlistPuzzle()
        puzzle.clearPencilPuzzle()
        puzzle.grid.undonePuzzle.removeAll()
        puzzle.grid.puzzleStack.removeAll()
        puzzle.grid.undonePencil.removeAll()
        puzzle.grid.pencilStack.removeAll()
        timer.invalidate()
        DispatchQueue.main.async {
            stopBGM()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func refresher() {
        isPlayingSavedGame = false
        let puzzle = self.appDelegate.sudoku
        puzzle.clearUserPuzzle()
        puzzle.clearPlistPuzzle()
        puzzle.clearPencilPuzzle()
        puzzle.grid.undonePuzzle.removeAll()
        puzzle.grid.puzzleStack.removeAll()
        puzzle.grid.undonePencil.removeAll()
        puzzle.grid.pencilStack.removeAll()
        puzzle.grid.gameDiff = puzzle.grid.gameDiff
        pencilOn = false
        pencilButton.isSelected = false
        setPencilButtonStateWhenUnselected()
        
        let array = self.appDelegate.getPuzzles(puzzle.grid.gameDiff)
        let answerArray = appDelegate.getPuzzles(puzzle.grid.gameDiff+"Answers")
        let puzzleIndex = random(array.count)
        puzzle.grid.plistPuzzle = puzzle.plistToPuzzle(plist: array[puzzleIndex], toughness: puzzle.grid.gameDiff)
        puzzle.grid.puzzleAnswer = puzzle.plistToPuzzle(plist: answerArray[puzzleIndex], toughness: puzzle.grid.gameDiff+"Answers")
        
        // re-draw Board view
        timerOutlet.text = "00:00:00"
        timer.invalidate()
        counter = 0
        isTimerInMotion = false
        timerStateInAction()
        refreshKeypad()
        self.sudokuView.selected = (row: -1, column: -1)
        self.sudokuView.setNeedsDisplay()
        redoUndoButtonState()
        randomNums.removeAll()
        blanksNums.removeAll()
        lives.removeAll()
        lifeCounter()
    }
    
    @objc func pageController() {
        pageControl.currentPage = GameViewController.index
    }
}
