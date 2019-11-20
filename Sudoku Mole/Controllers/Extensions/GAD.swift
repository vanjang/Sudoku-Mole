//
//  GAD.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/10/29.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import GoogleMobileAds

// Banner delegates
extension GameViewController {
    
  /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
    
}

// Interstitial delegates
extension GameViewController: GADInterstitialDelegate {

    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
        appDelegate.storeItems(1)
        self.chanceSetup()
    }
}

// Rewarded Video delegates
extension GameViewController {
    
    /// Tells the delegate that the user earned a reward.
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
//            timerStateInAction()
        }
        
        
         print("rewardedAd:userDidEarnReward")
    }
    
    /// Tells the delegate that the rewarded ad was presented.
    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
        print("rewardedAdDidPresent")
        
    }
    
    /// Tells the delegate that the rewarded ad failed to present.
    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
        print("rewardedAd:didFailToPresentWithError")
    }
    
    /// Tells the delegate that the rewarded ad was dismissed.
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("rewardedAdDidDismiss")
        rewardedAD = createAndLoadRewardedAD()
        self.chanceSetup()
        self.timerStateInAction()
        
        
        if !isRewarded {
            abandon()
            isRewarded = !isRewarded
        }
            isRewarded = false
        
        
    }
}
