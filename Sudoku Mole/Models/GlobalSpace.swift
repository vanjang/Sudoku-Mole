//
//  GlobalFunctions.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/20.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Lottie

// Timer
var timer = Timer()
// Game in play checkin & checkout
var isPlayingSavedGame = Bool()
var isPlayingGame = Bool()
// Global Lottie
let firework = AnimationView(name: "Firework")
// AV Player properties
var player: AVAudioPlayer?
var bgmPlayer: AVAudioPlayer?
var levelPlayer: AVAudioPlayer?
var fireworkPlayer: AVAudioPlayer?
var boardPlayer: AVAudioPlayer?
var isBGMMute = Bool()
var isSoundEffectMute = Bool()
// Sound Volume
var bgmVolume:Float = 0.05
var fireworkVolume:Float = 0.1
var levelVolume:Float = 0.4
var soundVolume:Float = 0.2
var boardVolume:Float = 0.05

// Return random Int
func random(_ n:Int) -> Int {
    return Int(arc4random_uniform(UInt32(n)))
}

// Compute font size for target box.
// http://goo.gl/jPL9Yu
func fontSizeFor(_ string : NSString, fontName : String, targetSize : CGSize) -> CGFloat {
    let testFontSize : CGFloat = 20//30
    let font = UIFont(name: fontName, size: testFontSize)
    let attr = [NSAttributedString.Key.font : font!]
    let strSize = string.size(withAttributes: attr)
    return testFontSize*min(targetSize.width/strSize.width, targetSize.height/strSize.height)
}

// Screen Type Checker
func deviceScreenHasNotch() -> Bool {
    var hasNotch = Bool()
    if UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "iPhone 6 Plus"  || UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "iPhone SE" || UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "iPhone 7 Plus" || UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "iPhone 8 Plus" || UIDevice.modelName == "Simulator iPhone 8" || UIDevice.modelName == "Simulator iPhone 8 Plus" || UIDevice.modelName == "Simulator iPhone 7" {
        hasNotch = false
    } else {
        hasNotch = true
    }
    return hasNotch
}

func playFirework() {
    guard let url = Bundle.main.url(forResource: "gameSolvedFirework", withExtension: "mp3") else { return }
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try AVAudioSession.sharedInstance().setActive(true)
        
        fireworkPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        fireworkPlayer?.numberOfLoops = -1
        
        guard let player = fireworkPlayer else { return }
        player.volume = fireworkVolume
        player.play()
    } catch let error {
        print(error.localizedDescription)
    }
}

func stopFirework() {
    guard let player = fireworkPlayer else { return }
    player.stop()
}

func playBGM(soundFile: String, lag: Double, numberOfLoops: Int) {
    isPlayingGame = true
    let randomBGM = random(2)
    let bgm = "BGM" + String(randomBGM)
    
    guard let url = Bundle.main.url(forResource: bgm, withExtension: "mp3") else { return }
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        try AVAudioSession.sharedInstance().setActive(true)
        
        bgmPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        bgmPlayer?.numberOfLoops = numberOfLoops
        
        let seconds = lag//Time To Delay
        let when = DispatchTime.now() + seconds
        
        guard let player = bgmPlayer else { return }
        DispatchQueue.main.asyncAfter(deadline: when) {
            player.volume = bgmVolume
            player.play()
        }
    } catch let error {
        print(error.localizedDescription)
    }
}

func pauseBGM() {
    guard let player = bgmPlayer else { return }
    player.pause()
}

func resumeBGM() {
    guard let player = bgmPlayer else { return }
    player.play()
}

func stopBGM() {
    guard let player = bgmPlayer else { return }
    player.stop()
}

func playLevelSound(soundFile: String, lag: Double, numberOfLoops: Int) {
    guard let url = Bundle.main.url(forResource: soundFile, withExtension: "mp3") else { return }
    do {
        try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
        
        levelPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        levelPlayer?.numberOfLoops = numberOfLoops
        
        let seconds = lag//Time To Delay
        let when = DispatchTime.now() + seconds
        
        guard let player = levelPlayer else { return }
        DispatchQueue.main.asyncAfter(deadline: when) {
            player.volume = levelVolume
            player.play()
        }
    } catch let error {
        print(error.localizedDescription)
    }
}

func stopLevelSound() {
    guard let player = levelPlayer else { return }
    player.stop()
}

func playSound(soundFile: String, lag: Double, numberOfLoops: Int) {
    guard let url = Bundle.main.url(forResource: soundFile, withExtension: "mp3") else { return }
    do {
        try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
        
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        player?.numberOfLoops = numberOfLoops
        
        let seconds = lag//Time To Delay
        let when = DispatchTime.now() + seconds
        
        guard let player = player else { return }
        DispatchQueue.main.asyncAfter(deadline: when) {
            player.volume = soundVolume
            player.play()
        }
    } catch let error {
        print(error.localizedDescription)
    }
}

func playBoardSound(soundFile: String, lag: Double, numberOfLoops: Int) {
    guard let url = Bundle.main.url(forResource: soundFile, withExtension: "mp3") else { return }
    do {
        try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
        
        boardPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        boardPlayer?.numberOfLoops = numberOfLoops
        
        let seconds = lag//Time To Delay
        let when = DispatchTime.now() + seconds
        
        guard let player = boardPlayer else { return }
        DispatchQueue.main.asyncAfter(deadline: when) {
            player.volume = boardVolume
            player.play()
        }
    } catch let error {
        print(error.localizedDescription)
    }
}
