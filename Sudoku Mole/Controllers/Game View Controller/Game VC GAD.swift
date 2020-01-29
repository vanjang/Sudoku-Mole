//
//  Game VC GAD.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

// Interstitial delegates
extension GameViewController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        self.refresher()
    }
}

// Banner delegates
extension GameViewController {
    // Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {}
    
    // Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {}
    
    // Tells the delegate that a full-screen view will be presented in response
    // to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {}
    
    // Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {}
    
    // Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {}
    
    // Tells the delegate that a user click will open another app (such as the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {}
}

// Rewarded delegate
extension GameViewController {
    // Tells the delegate that the user earned a reward.
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        isRewarded = true
        
        if shouldAddChance {
            appDelegate.storeItems(1)
            shouldAddChance = false
        }
        
        if shouldAnotherLife {
            lives.removeLast()
            lifeCounter()
            shouldAnotherLife = false
            lifeChanceFlagUp = false
        }
    }
    
    // Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {}
    
    // Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {}
    
    // Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        rewardedAD = createAndLoadRewardedAD()
        self.chanceSetup()
        self.timerStateInAction()
        
        if !isRewarded {
            // Call ONLY When terminating
            if lifeChanceFlagUp {
                abandon()
            }
            isRewarded = !isRewarded
        } else {
            resumeBGM()
        }
        isRewarded = false
    }
}
