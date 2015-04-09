//
//  GameViewController.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 3/24/15.
//  Copyright (c) 2015 Nick Cracchiolo. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit
import iAd
import StoreKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file as String, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}
var adView = ADBannerView()
var gameCenterEnabled = false
var leaderBoardID = NSString()
var p = SKProduct()
var list = [SKProduct]()

class GameViewController: UIViewController, ADBannerViewDelegate, GKGameCenterControllerDelegate, SKProductsRequestDelegate,SKPaymentTransactionObserver {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(SKPaymentQueue.canMakePayments()) {
            println("IAP is enabled, loading")
            var productID:NSSet = NSSet(objects: "fbf.iap.add_money")
            var request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
            request.delegate = self
            request.start()
        } else {
            println("please enable IAPS")
        }
        
        let frme = CGRectMake(0, self.view.frame.size.height-50, 320, 50)
        adView = ADBannerView(frame: frme)
        var frame:CGRect = CGRectZero
        frame.size = adView.frame.size;
        frame.origin = CGPointMake(0.0, self.view.frame.size.height-adView.frame.size.height);
        adView.frame = frame
        adView.delegate = self
        self.view.addSubview(adView)
        
        self.authenticateLocalPlayer()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        adView.hidden = false;
    }
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
    }
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        adView.hidden = true
    }
    
    //ADD GAME CENTER AND iAD AND IN APP PURCHASES
    func authenticateLocalPlayer(){
        let localPlayer = GKLocalPlayer()
        let viewController = UIViewController()
        let error = NSError()
        let leaderBoardIdentifier = NSString()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                self.presentViewController(viewController, animated: true, completion: nil)
            } else {
                if (localPlayer.authenticated) {
                    GKNotificationBanner.showBannerWithTitle("Game Center", message: ("Welcome, " + String(format: localPlayer.displayName)) , completionHandler: {
                        gameCenterEnabled = true
                    })
                    localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler{(viewController, error) -> Void in
                        if error != nil {
                            print(error)
                        } else {
                            leaderBoardID = leaderBoardIdentifier
                        }
                    }
                }
                else {
                    gameCenterEnabled = false
                }
            }
        }
    }
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func reportScore(identifier:NSString) {
        if GKLocalPlayer.localPlayer().authenticated == true{
            var highScore = defaults.integerForKey("level")
            var scoreReporter = GKScore(leaderboardIdentifier: identifier as String)
            scoreReporter.value = Int64(highScore)
            var scoreArray: [GKScore] = [scoreReporter]
            println("report score \(scoreReporter)")
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError!) -> Void in
                if error != nil {
                    NSLog(error.localizedDescription)
                }
            })
            
            
        }
    }
    
    //StoreKit
    func buyProduct() {
        println("buy " + p.productIdentifier)
        var pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    //3
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
    
    // 4
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        println("transactions restored")
        
        var purchasedItemIDS = []
        for transaction in queue.transactions {
            var t: SKPaymentTransaction = transaction as! SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "fbf,iap,add_money":
                println("remove ads")
                money+=100
                saveData()
            default:
                println("IAP not setup")
            }
            
        }
    }
    
    // 5
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
                    println("remove ads")
                    money+=100
                    saveData()
                default:
                    println("IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break;
            case .Deferred:
                let alertController = UIAlertController(title: "Uh Oh", message:
                    "Go get your parents to make this payment", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                break;
            case .Failed:
                println("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                println("default")
                break;
                
            }
        }
    }
    
    // 6
    func finishTransaction(trans:SKPaymentTransaction)
    {
        println("finish trans")
    }
    
    //7
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!)
    {
        println("remove trans");
    }
}