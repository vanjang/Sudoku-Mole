//
//  IAP.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/11.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import Foundation
import StoreKit

extension GameViewController: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
        }
        else {
            // There are no products
        }
        if response.invalidProductIdentifiers.count != 0 {
//            print(response.invalidProductIdentifiers.description)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchasing:
                if transactionInProgress == true {
                    let alert = UIAlertController(title: "Processing".localized(), message: nil, preferredStyle: .alert)
                    let activityIndicator = UIActivityIndicatorView(style: .gray)
                    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                    activityIndicator.isUserInteractionEnabled = false
                    activityIndicator.startAnimating()
                    alert.view.addSubview(activityIndicator)
                    alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true
                    activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
                    activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
                    present(alert, animated: true)
                }
            case SKPaymentTransactionState.purchased:
                transactionInProgress = false
                dismiss(animated: true, completion: nil)
                SKPaymentQueue.default().finishTransaction(transaction)
            case SKPaymentTransactionState.failed:
                transactionInProgress = false
                dismiss(animated: true, completion: nil)
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = Set(productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            // Cannot perform In App Purchases
        }
    }
    
    @objc func ADFreeButtonTapped() {
        if !transactionInProgress {
            let payment = SKPayment(product: self.productsArray[0] as SKProduct)
            SKPaymentQueue.default().add(payment)
            self.transactionInProgress = true
            IAPPurchase = .ADRemover
        }
    }
    
    @objc func getChanceButtonTapped() {
        if !transactionInProgress {
            if (appDelegate.item?.chances.count)! > 5 {
                instantiatingCustomAlertView()
                self.delegate?.customAlertController(title: "CHANCE SLOTS ARE FULL".localized(), message: "You can top up if chance is below 6.".localized(), option: .oneButton)
                self.delegate?.customAction1(title: "OK".localized(), action: { xx in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                self.present(self.customAlertView, animated: true, completion: nil)
            } else {
                let payment = SKPayment(product: self.productsArray[1] as SKProduct)
                SKPaymentQueue.default().add(payment)
                self.transactionInProgress = true
                IAPPurchase = .Chances
            }
        }
    }
    
}
