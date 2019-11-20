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
    
    enum PurchasingIAP {
        case ADRemover
        case Chances
        case none
    }
    
    @objc func ADFreeButtonTapped() {
        if !transactionInProgress {
            print("ad button tapped")
            dump(productsArray)
            let payment = SKPayment(product: self.productsArray[0] as SKProduct)
            print("ad button tapped2")
            SKPaymentQueue.default().add(payment)
            self.transactionInProgress = true
            IAPPurchase = .ADRemover
        }
    }
    
    @objc func getChanceButtonTapped() {
        if !transactionInProgress {
            print("chance tapped")
            if (appDelegate.item?.chances.count)! > 5 {
                // dialog to popup
                instantiatingCustomAlertView()
                self.delegate?.customAlertController(title: "There are enough chances!", message: "Max chance is 10. You can top chances up if it is below 6.", option: .oneButton)
                self.delegate?.customAction1(title: "OK", action: { xx in
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                self.present(self.customAlertView, animated: true, completion: nil)
                print("current number of items is \(String(describing: appDelegate.item?.chances.count)). You can have chances up to 10.")
            } else {
                let payment = SKPayment(product: self.productsArray[1] as SKProduct)
                SKPaymentQueue.default().add(payment)
                self.transactionInProgress = true
                IAPPurchase = .Chances
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        if response.products.count != 0 {
            print("there is product")
            for product in response.products {
                productsArray.append(product)
            }
        }
        else {
            print("There are no products.")
        }
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchasing:
                if transactionInProgress == true {
                    let alert = UIAlertController(title: "Processing", message: nil, preferredStyle: .alert)
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
                print("Transaction completed successfully.")
                transactionInProgress = false
                dismiss(animated: true, completion: nil)
                SKPaymentQueue.default().finishTransaction(transaction)
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
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
            print("request product info")
            let productIdentifiers = Set(productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }

}
