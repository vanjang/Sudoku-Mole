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
                // Error occured
            } else {
                // No error
            }
        }
        return rewardedAD
    }
}
