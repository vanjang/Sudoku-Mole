//
//  GAD.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/29.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import GoogleMobileAds

// Interstitial delegate
extension GameSolvedViewController: GADInterstitialDelegate {
    func createAndLoadInterstitial() -> GADInterstitial {
//        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")// TestID
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2341224352662975/2139600458")// Actual
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    // Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {}
    
    // Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {}
    
    // Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {}
    
    // Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        implementButtonAction()
    }
    
    // Tells the delegate that a user click will open another app(such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {}
}
