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

var player: AVAudioPlayer?

func playSound(soundFile: String) {
    
    guard let url = Bundle.main.url(forResource: soundFile, withExtension: "mp3") else { return }

    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)

        /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

        /* iOS 10 and earlier require the following line:
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

        guard let player = player else { return }

        player.play()

    } catch let error {
        print(error.localizedDescription)
    }
}

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
