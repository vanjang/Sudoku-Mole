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
//    let vc = PauseViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
                NotificationCenter.default.addObserver(self, selector: #selector(timerStateInAction),name:NSNotification.Name(rawValue: "resumeTimer"), object: nil)
//        makeTipView()
//        vc.delegate = self
        
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
        buttonStateSetup()
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
        
        // tap gesture setup
        if shouldTipView() {
            singleTapGestureRecognizer = CustomTapGestureRecognizer(target: self, action: #selector(singleTapped(sender:)))
            singleTapGestureRecognizer.numberOfTapsRequired = 1
            sudokuView.addGestureRecognizer(singleTapGestureRecognizer)
        }
        
        
        doubleTapGestureRecognizer = CustomTapGestureRecognizer(target: self, action: #selector(doubleTapped(sender:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        sudokuView.addGestureRecognizer(doubleTapGestureRecognizer)
//        print("view did load")
    }
    
    func shouldTipView() -> Bool {
        let tipViewKey = "TipViewShownOnce3"
        let userDefault = appDelegate.userDefault
        
        guard let value = userDefault.value(forKey: tipViewKey) as? Int else {
            userDefault.set(0, forKey: tipViewKey)
            return true
        }
        
        if value < 2 {
            return true
        } else {
            return false
        }
       
        }

    
    var doubleTapGestureRecognizer = CustomTapGestureRecognizer()
    var singleTapGestureRecognizer = CustomTapGestureRecognizer()
    
    override func viewWillLayoutSubviews() {
//        print("view will layout subviews")
//        pageControl.currentPage = GameViewController.index
    }

    override func viewDidAppear(_ animated: Bool) {
//        print("view did appear")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        print("view will transition")
    }
    
    override func viewDidLayoutSubviews() {
//        print("view did layout subviews")
        NotificationCenter.default.addObserver(self, selector: #selector(pageController),name:NSNotification.Name(rawValue: "pageControl"), object: nil)
        
//        pageControl.currentPage = GameViewController.index
        let scale: CGFloat = 0.65
        for dot in pageControl.subviews{
            dot.transform = CGAffineTransform.init(scaleX: 1/scale, y: 1/scale)
        }
    }
    
    @objc func pageController() {
//        print("page control")
         pageControl.currentPage = GameViewController.index
    }
        
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")
        NotificationCenter.default.addObserver(self, selector: #selector(refresher),name:NSNotification.Name(rawValue: "refresher"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(abandon),name:NSNotification.Name(rawValue: "abandon"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(popAD),name:NSNotification.Name(rawValue: "popAD"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chanceSetup),name:NSNotification.Name(rawValue: "userEarnedaChance"), object: nil)

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
                    self.delegate?.customAlertController(title: "THANK YOU FOR PURCHASE".localized(), message: "Turn the app on and off to remove ADs forever!".localized(), option: .oneButton)
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
    
 @objc func tipViewButtonDismissButtonTapped() {
        tipView.animateYPosition(target: tipView, targetPosition: view.frame.size.height+300, completion: { (action) in
            self.tipView.removeFromSuperview()
            self.sudokuView.removeGestureRecognizer(self.singleTapGestureRecognizer)
            self.sudokuView.isUserInteractionEnabled = true
        })
    }
    
    func makeTipView() {
        let width = self.view.frame.size.width*0.88
        let height = width*0.50
        
//        let poppedFrame = CGRect(x: (view.frame.size.width-width)/2, y: view.frame.size.height-height-((view.frame.size.width-width)/2), width: width, height: height)
        let dismissedFrame = CGRect(x: (view.frame.size.width-width)/2, y: view.frame.size.height+300, width: width, height: height)
        tipView.frame = dismissedFrame
        tipView.backgroundColor = #colorLiteral(red: 0.9364990592, green: 0.3447085321, blue: 0.3428477943, alpha: 1)
        tipView.alpha = 0.98
        tipView.layer.cornerRadius = tipView.frame.size.height/5.5
        view.addSubview(tipView)
        tipView.addSubview(tipLabel)
        
        tipLabel.text = "이 창 닫으면 병처리 바보 ㅎㅎ"
//        tipLabel.text = "Tap the input field twice to delete the number you entered.".localized()
        tipLabel.numberOfLines = 0
        tipLabel.textColor = .white
        tipLabel.font = UIFont(name: "SFProDisplay-Light", size: 18)
        tipLabel.contentMode = .topLeft
        tipLabel.textAlignment = .left
        
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: tipLabel, attribute: .left, relatedBy: .equal, toItem: tipView, attribute: .left, multiplier: 1, constant: 20)
        let rightConstraint = NSLayoutConstraint(item: tipLabel, attribute: .right, relatedBy: .equal, toItem: tipView, attribute: .right, multiplier: 1, constant: -100)
        let topConstraint = NSLayoutConstraint(item: tipLabel, attribute: .top, relatedBy: .equal, toItem: tipView, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: tipLabel, attribute: .bottom, relatedBy: .equal, toItem: tipView, attribute: .bottom, multiplier: 1, constant: -tipView.frame.size.height/3)
        self.tipView.addConstraints([leftConstraint, rightConstraint, topConstraint, bottomConstraint])
        
        tipViewDismissImage = UIImage(named: "icSideClose.png")!
        tipViewDismissButton.setImage(tipViewDismissImage, for: .normal)
        tipViewDismissButton.frame.size.width = 20
        tipViewDismissButton.frame.size.height = 20
        tipViewDismissButton.addTarget(self, action: #selector(tipViewButtonDismissButtonTapped), for: .touchUpInside)
        tipView.addSubview(tipViewDismissButton)
        
        tipViewDismissButton.translatesAutoresizingMaskIntoConstraints = false
        let xRightConstraint = NSLayoutConstraint(item: tipViewDismissButton, attribute: .right, relatedBy: .equal, toItem: tipView, attribute: .right, multiplier: 1, constant: -10)
        let xTopConstraint = NSLayoutConstraint(item: tipViewDismissButton, attribute: .top, relatedBy: .equal, toItem: tipView, attribute: .top, multiplier: 1, constant: 10)
        self.tipView.addConstraints([xRightConstraint, xTopConstraint])
        
        tipSmoleImage = UIImage(named: "menuMyrecordSmolenote.png")!
        tipSmole.image = tipSmoleImage
        tipSmole.contentMode = .scaleAspectFit
        tipView.addSubview(tipSmole)
        
        tipSmole.translatesAutoresizingMaskIntoConstraints = false
        let smoleLeftConstraint = NSLayoutConstraint(item: tipSmole, attribute: .left, relatedBy: .equal, toItem: tipLabel, attribute: .right, multiplier: 1, constant: 10)
        let smoleRightConstraint = NSLayoutConstraint(item: tipSmole, attribute: .right, relatedBy: .equal, toItem: tipView, attribute: .right, multiplier: 1, constant: -10)
        let smoleTopConstraint = NSLayoutConstraint(item: tipSmole, attribute: .top, relatedBy: .equal, toItem: tipView, attribute: .top, multiplier: 1, constant: tipView.frame.size.height/3)
        let smoleBottomConstraint = NSLayoutConstraint(item: tipSmole, attribute: .bottom, relatedBy: .equal, toItem: tipView, attribute: .bottom, multiplier: 1, constant: -10)
        self.tipView.addConstraints([smoleLeftConstraint, smoleRightConstraint, smoleTopConstraint, smoleBottomConstraint])

        tipView.animateYPosition(target: tipView, targetPosition: view.frame.size.height-height-((view.frame.size.width-width)/2), completion: nil)
    }
//
//    func disableViewsWhileTipViewPopped() {
//        sudokuView.isUserInteractionEnabled = false
//
//        for keypad in keypadCollection {
//            keypad.isUserInteractionEnabled = false
//        }
//
//    }
//
//
    
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
//    let iap1Label = UILabel()
//    let iap2Label = UILabel()
//    let iapSmoleImageView = UIImageView()
//    let smole = AnimationView(name: "159-servishero-loading")
//    let smoleSide = AnimationView(name: "11282-bread-toaster")
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
    
//    var boardSelectedOnce:(row: Int, column: Int) = (row: Int(), column: Int()) {
//        didSet {
//            print("board selected")
//            makeTipView()
//        }
//    }
    
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
//            boardSelectedOnce = puzzleArea.selected
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
//                                        self.appDelegate.sudoku.userGrid(n: 0, row: row, col: col)
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
        
        // 0. fix값이 없고
        //        if grid?.plistPuzzle[row][col] == 0 {
        // 1. 셀이 선택된 상태라면
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
                            if col == 8 { // 3-1. 8th column은 다른 <Lottie>를 실행
                                print("chance : \(appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col))")
                                playAnimation(answer: appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col), point: sudokuView.cgPointForSelectedBox, isColumn8: true, isBlank: true)
                            } else { // 3-2. 나머지 column은 <Lottie>를 실행
                                print("chance : \(appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col))")
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
                    
                    // check ad is avail first then play ad
                    
                    popRewardADforChance()
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
    
    func activateChance() {
        let row = puzzleArea.selected.row
        let col = puzzleArea.selected.column
        if col == 8 {
            print("chance : \(appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col))")
            playAnimation(answer: appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col), point: sudokuView.cgPointForSelectedBox, isColumn8: true, isBlank: false)
        } else {
            print("chance : \(appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col))")
            playAnimation(answer: appDelegate.sudoku.correctAnswerForSelectedBox(row: row, col: col), point: sudokuView.cgPointForSelectedBox, isColumn8: false, isBlank: false)
        }
        appDelegate.spendItem()
        self.chanceSetup()
    }
    
    func playAnimation(answer: Int?, point: CGPoint, isColumn8: Bool, isBlank: Bool) {
        self.chanceButtonOutlet.isUserInteractionEnabled = false
        let boxSize = sudokuView.sizeForSelectedBox
        let frame = CGRect(x: point.x+3, y: (point.y-boxSize.height*0.75)+biOutlet.frame.size.height+view.safeAreaInsets.top+3, width: boxSize.width*1.75, height: boxSize.height*1.80)
        let flippedFrame = CGRect(x: point.x-boxSize.width*0.72, y: (point.y-boxSize.height*0.75)+biOutlet.frame.size.height+view.safeAreaInsets.top+3, width: boxSize.width*1.75, height: boxSize.height*1.80)
        chanceView.frame = frame
        chanceView.backgroundColor = .clear
        
        let side = "Side"
        var lottieName = "Chance"
        let lottieNumber = String(answer!)
        
        if isBlank == false {
            if isColumn8 {
                lottieName += lottieNumber + side
                print(lottieName)
            } else {
                lottieName += lottieNumber
                print(lottieName)
            }
        } else {
            //play 꽝
            lottieName = "Blank"
            print(lottieName)
        }
        
        let lottie = AnimationView(name: lottieName)
        
        if isColumn8 {
            print("it is 8")
            if lottieName == "Blank" {
                lottie.transform = CGAffineTransform(scaleX: -1, y: 1)
                lottie.frame = flippedFrame
                chanceView.frame = flippedFrame
            } else {
                lottie.frame = flippedFrame
                chanceView.frame = flippedFrame
            }
        } else if !isColumn8 {
            print("NOT 8")
            
            
            lottie.transform = CGAffineTransform(scaleX: 1, y: 1)
            lottie.frame = frame
            chanceView.frame = frame
        }
        
        lottie.center = chanceView.center
        lottie.contentMode = .scaleAspectFit
        lottie.backgroundColor = .clear
        view.addSubview(lottie)
        
        lottie.play { (finished) in
            self.chanceView.removeFromSuperview()
            lottie.removeFromSuperview()
            self.chanceButtonOutlet.isUserInteractionEnabled = true
        }
        // Build test code - infinite chances
                appDelegate.storeItems(1)
                self.chanceSetup()
    }

    // Methods for AD
    func popRewardADforChance() {
        if rewardedAD.isReady {
            rewardedAD.present(fromRootViewController: self, delegate: self)
        } else {
            instantiatingCustomAlertView()
            self.delegate?.customAlertController(title: "AD NOT AVAILABLE".localized(), message: "Try later when network is connected.".localized(), option: .oneButton)
            self.delegate?.customAction1(title: "OK".localized(), action: { xx in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            self.present(self.customAlertView, animated: true, completion: nil)
        }
    }
    
    func popRewardADforLife() {
        if rewardedAD.isReady {
            rewardedAD.present(fromRootViewController: self, delegate: self)
        } else {
            instantiatingCustomAlertView()
            self.delegate?.customAlertController(title: "AD NOT AVAILABLE".localized(), message: "Sorry, game is terminated.".localized(), option: .oneButton)
            self.delegate?.customAction1(title: "OK".localized(), action: { xx in
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
    
    func createAndLoadRewardedAD() -> GADRewardedAd {
        let rewardedAD = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        rewardedAD.load(GADRequest()) { (error) in
            if error != nil {
                print("error")
                // Error occured
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
    
    func menuConsts() {
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
        
        smoleMenuImage.translatesAutoresizingMaskIntoConstraints = false
//        let smoleImageTopConstraints = NSLayoutConstraint(item: smoleMenuImage, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: menuView, attribute: .top, multiplier: 1, constant: menuView.frame.size.height*0.35)
        print("menuviewfram : \(menuView.frame)")
        let smoleImageBottomConstraints = NSLayoutConstraint(item: smoleMenuImage, attribute: .bottom, relatedBy: .equal, toItem: menuView, attribute: .bottom, multiplier: 1, constant: 0)
//        let smoleImageRightConstraints = NSLayoutConstraint(item: smoleMenuImage, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1, constant: -95)
        let smoleImageLeftConstraints = NSLayoutConstraint(item: smoleMenuImage, attribute: .left, relatedBy: .equal, toItem: menuView, attribute: .left, multiplier: 1, constant: 0)
//        let smoleImageRightConstraints = NSLayoutConstraint(item: smoleMenuImage, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1, constant: -menuView.frame.size.width*0.23)
//
        smoleMenuImage.heightAnchor.constraint(equalTo: smoleMenuImage.widthAnchor, multiplier: 498/334).isActive = true
        smoleMenuImage.heightAnchor.constraint(equalTo: menuView.heightAnchor, multiplier: 3/5).isActive = true
        
        self.menuView.addConstraints([smoleImageBottomConstraints, smoleImageLeftConstraints])
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
    
    @objc func singleTapped(sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: sudokuView)
        let gridSize = sudokuView.bounds.width
        let gridOrigin = CGPoint(x: (sudokuView.bounds.width - gridSize)/2, y: (sudokuView.bounds.height - gridSize)/2)
        let d = gridSize/9
        let col = Int((tapPoint.x - gridOrigin.x)/d)
        let row = Int((tapPoint.y - gridOrigin.y)/d)
        
        if  0 <= col && col < 9 && 0 <= row && row < 9 {
            makeTipView()
            sudokuView.isUserInteractionEnabled = false
            
            let tipViewKey = "TipViewShownOnce3"
            let userDefault = appDelegate.userDefault
            var count = Int()//userDefault.value(forKey: tipViewKey) as? Int
            
            guard let tipViewCount = userDefault.value(forKey: tipViewKey) as? Int else {
                userDefault.set(1, forKey: tipViewKey)
                return
            }
            count = tipViewCount + 1
            userDefault.set(count, forKey: tipViewKey)
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
            if (appDelegate.item?.chances.count)! > 10 {
                let chanceImage = UIImage(named: "chance10+.png")
                chanceButtonOutlet.setImage(chanceImage, for: .normal)
            } else {
                let chanceImage = UIImage(named: "chance"+String(appDelegate.item!.chances.count)+".png")
                chanceButtonOutlet.setImage(chanceImage, for: .normal)
            }
        } else {
            let chanceImage = UIImage(named: "chanceAD.png")
            chanceButtonOutlet.setImage(chanceImage, for: .normal)
        }
        self.view.layoutIfNeeded()
    }
    
    // Timer Methods
    @objc func timerStateInAction() {
        
        print("###################timer state in action###################")
        let play = UIImage(named: "icTimePlay.png")
        let pause = UIImage(named: "icTimeStop.png")
//        timerImageView.contentMode = .scaleToFill
        
        isPlaying = !isPlaying
        if isPlaying == true {
            timerImageView.image = pause
//            timerSwitch.setImage(pause, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        } else {
            timerImageView.image = play
//            timerSwitch.setImage(play, for: .normal)
            timer.invalidate()
        }
        
    }
 
    @objc func updateTimer() {
        counter = counter + 1
        seconds = counter % 60
        minutes = (counter / 60) % 60
        hours = (counter / 3600)
        record = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        timerOutlet.text = record
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
