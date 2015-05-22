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
    
    class var defaultHelper : inAppPurchases {
        struct Static {
            static let instance : inAppPurchases = inAppPurchases()
        }
        
        return Static.instance
    }
    
    override init() {
        super.init()
    }
    func getProducts() {
        if(SKPaymentQueue.canMakePayments()) {
            println("IAP is enabled, loading")
            var productID:NSSet = NSSet(objects: "fbf.iap.add_money","fbf.iap.add_money500","fbf.iap.add_money1000","fbf.iap.remove_ads", "fbf.iap.save_life")
            request = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
            request!.delegate = self
            request!.start()
        } else {
            println("please enable IAPS")
        }

    }
    func setViewController(vc:UIViewController) {
        viewC = vc
    }
    func saveLife() {
        for product in list {
            var prodID = product.productIdentifier
            if(prodID == "fbf.iap.save_life") {
                p = product
                buyProduct(p)
                break;
            }
        }
    }
    func CoinsBtnOne() {
        for product in list {
            var prodID = product.productIdentifier
            if(prodID == "fbf.iap.add_money") {
                p = product
                buyProduct(p)
                break;
            }
        }
        
    }
    func CoinsBtnFive() {
        for product in list {
            var prodID = product.productIdentifier
            if(prodID == "fbf.iap.add_money500") {
                p = product
                buyProduct(p)
                break;
            }
        }
    }
    
    func CoinsBtnThousand() {
        for product in list {
            var prodID = product.productIdentifier
            if(prodID == "fbf.iap.add_money1000") {
                p = product
                buyProduct(p)
                break;
            }
        }
    }
    
    func RemoveAds() {
        for product in list {
            var prodID = product.productIdentifier
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
        var pay = SKPayment(product: prod)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        println("product request")
        var myProduct = response.products
        
        for product in myProduct {
            println("product added")
            println(product.productIdentifier)
            println(product.localizedTitle)
            println(product.localizedDescription)
            println(product.price)
            
            list.append(product as! SKProduct)
        }
    }
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        println("transactions restored")
        
        var purchasedItemIDS = []
        for transaction in queue.transactions {
            var t: SKPaymentTransaction = transaction as! SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "fbf.iap.remove_ads":
                println("remove ads")
                defaults.setInteger(1, forKey: "ads")
                Flurry.logEvent("Ads Removal Restored")
            default:
                println("IAP not setup")
            }
        }
    }
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        println("add paymnet")
        
        for transaction:AnyObject in transactions {
            var trans = transaction as! SKPaymentTransaction
            println(trans.error)
            
            switch trans.transactionState {
                
            case .Purchased:
                println("buy, ok unlock iap here")
                println(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID {
                    case "fbf.iap.add_money":
                        money+=100
                        saveData()
                        Flurry.logEvent("100 Coins Bought")
                    case "fbf.iap.add_money500":
                        money+=500
                        saveData()
                        Flurry.logEvent("500 Coins Bought")
                    case "fbf.iap.add_money1000":
                        money+=1000
                        saveData()
                        Flurry.logEvent("1000 Coins Bought")
                    case "fbf.iap.remove_ads":
                        defaults.setInteger(1, forKey: "ads")
                        self.appDelegate.adView.hidden = true
                        self.appDelegate.adView.removeFromSuperview()
                        Flurry.logEvent("Ad Removal Bought")
                    case "fbf.iap.save_life":
                        Flurry.logEvent("Second Chance Bought")
                    default:
                        println("IAP not setup")
                }
                queue.finishTransaction(trans)
                break;
            case .Deferred:
                let alertController = UIAlertController(title: "Uh Oh", message:
                    "Go get your parents to make this payment", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                viewC.presentViewController(alertController, animated: true, completion: nil)
                purchase_failed = true
                break;
            case .Failed:
                println("buy error")
                queue.finishTransaction(trans)
                purchase_failed = true
                break;
            default:
                println("default")
                break;
                
            }
        }
    }
    func finishTransaction(trans:SKPaymentTransaction) {
        println("finish trans")
    }
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!) {
        println("remove trans");
        //purchase_failed = true
    }

}