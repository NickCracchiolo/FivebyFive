//
//  inAppPurchases.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/13/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import Foundation
import StoreKit

class inAppPurchases: NSObject,SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var request : SKProductsRequest?
    var queue : SKPaymentQueue = SKPaymentQueue.defaultQueue()
    var p = SKProduct()
    var list = [SKProduct]()
    var viewC:UIViewController = UIViewController()
    let defaults = NSUserDefaults.standardUserDefaults()
    static let defaultHelper:inAppPurchases = inAppPurchases()

    private override init() {
        super.init()
    }
    func getProducts() {
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID:NSSet = NSSet(objects: "fbf.iap.add_money","fbf.iap.add_money500","fbf.iap.add_money1000","fbf.iap.remove_ads", "fbf.iap.save_life")
            request = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request!.delegate = self
            request!.start()
        } else {
            print("please enable IAPS")
        }

    }
    func setViewController(vc:UIViewController) {
        viewC = vc
    }
    func saveLife() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "fbf.iap.save_life") {
                p = product
                buyProduct(p)
                break;
            }
        }
    }
    func CoinsBtnOne() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "fbf.iap.add_money") {
                p = product
                buyProduct(p)
                break;
            }
        }
        
    }
    func CoinsBtnFive() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "fbf.iap.add_money500") {
                p = product
                buyProduct(p)
                break;
            }
        }
    }
    
    func CoinsBtnThousand() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "fbf.iap.add_money1000") {
                p = product
                buyProduct(p)
                break;
            }
        }
    }
    
    func RemoveAds() {
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "fbf.iap.remove_ads") {
                p = product
                buyProduct(p)
                break;
            }
        }
    }
    func RestorePurchase() {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }

    func buyProduct(prod:SKProduct) {
        //println("buy " + prod.productIdentifier)
        let pay = SKPayment(product: prod)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product as SKProduct)
        }
    }
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("transactions restored")
        
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction as SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "fbf.iap.remove_ads":
                print("remove ads")
                defaults.setInteger(1, forKey: "ads")
            default:
                print("IAP not setup")
            }
        }
    }
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add paymnet")
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
                
            case .Purchased:
                print("buy, ok unlock iap here")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                var money = defaults.integerForKey(DefaultKeys.Money.description)
                
                switch prodID {
                    case "fbf.iap.add_money":
                        money+=100
                    case "fbf.iap.add_money500":
                        money+=500
                    case "fbf.iap.add_money1000":
                        money+=1000
                    case "fbf.iap.remove_ads":
                        defaults.setInteger(1, forKey: "ads")
                        self.appDelegate.adView.hidden = true
                        self.appDelegate.adView.removeFromSuperview()
                    case "fbf.iap.save_life":
                        break
                    default:
                        print("IAP not setup")
                }
                queue.finishTransaction(trans)
                break;
            case .Deferred:
                let alertController = UIAlertController(title: "Uh Oh", message:
                        "Go into setting and enable In App Purchases", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                viewC.presentViewController(alertController, animated: true, completion: nil)
                defaults.setInteger(1, forKey: DefaultKeys.Purchased.description)
                break;
            case .Failed:
                print("buy error")
                queue.finishTransaction(trans)
                defaults.setInteger(1, forKey: DefaultKeys.Purchased.description)
                break;
            default:
                print("default")
                break;
                
            }
            defaults.synchronize()

        }
    }
    func finishTransaction(trans:SKPaymentTransaction) {
        print("finish trans")
    }
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove trans");
        //purchase_failed = true
    }

}