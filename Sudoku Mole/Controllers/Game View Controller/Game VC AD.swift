//
//  Game VC AD.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/30.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

extension GameViewController {
    @objc func popAD() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            // Ad wasn't ready
        }
    }
    
    func popRewardADforChance() {
        if rewardedAD.isReady {
            pauseBGM()
            timerStateInAction()
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
            pauseBGM()
            timerStateInAction()
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
    
    // new admob id cochipcho.director@gmail.com IDs
    func createAndLoadInterstitial() -> GADInterstitial {
//        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")// TestID
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-2341224352662975/2139600458")// Actual
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func createAndLoadBanner() {
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)//kGADAdSizeBanner)
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"// TestID
        bannerView.adUnitID = "ca-app-pub-2341224352662975/6078845467"// Actual
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    func createAndLoadRewardedAD() -> GADRewardedAd {
//        let rewardedAD = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")// TestID
        let rewardedAD = GADRewardedAd(adUnitID: "ca-app-pub-2341224352662975/5887273778")// Actual
        rewardedAD.load(GADRequest()) { (error) in
            if error != nil {
                // Error occured
            } else {
                // No error
            }
        }
        return rewardedAD
    }
}
