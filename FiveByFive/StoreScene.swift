//
//  StoreScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit
import StoreKit
import FirebaseAnalytics

class StoreScene:SKScene, GameDataProtocol,SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var wheel:FFWheel = FFWheel()
    var gameData = GameData()
    var p = SKProduct()
    var productsList = [SKProduct]()
    var activityIndicator:UIActivityIndicatorView!
    
    override func didMoveToView(view: SKView) {
        gameData = loadInstance()
        setupGestures()
        setupScene()
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        getProducts()
        
//        activityIndicator = UIActivityIndicatorView()
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = .Gray
//        activityIndicator.color = UIColor(red: 255/255, green: 36/255, blue: 31/255, alpha: 1.0)
//        activityIndicator.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
//        print("About to add activity indicator")
//        self.scene!.view!.addSubview(activityIndicator)
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = (touch as! UITouch).locationInNode(self)
            let node = self.nodeAtPoint(location)
            if node.name == "Purchase Button" {
                if SKPaymentQueue.defaultQueue().transactions.count <= 1 {
                    let item = wheel.currentObject() as! PurchaseItem
                    purchaseProduct(item.purchaseID)
                }
            }
            if node.name == "Back Button" {
                self.view?.presentScene(StartScene(size: self.size))
            }
        }
    }
    
    // MARK: Scene Setup
    private func setupScene() {
        self.backgroundColor = UIColor.whiteColor()
        let scale = self.frame.size.width/414.0
        
        let storeLabel = SKLabelNode(text: "Store")
        storeLabel.setScale(scale)
        storeLabel.fontName = Constants.FontName.Game_Font
        storeLabel.fontSize = Constants.FontSize.Title
        storeLabel.fontColor = UIColor.blackColor()
        storeLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.85)
        self.addChild(storeLabel)
        
        wheel = FFWheel(withNodes: getPurchaseItems())
        wheel.setScale(scale)
        wheel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(wheel)
        
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.setScale(scale)
        backButton.position = CGPointMake(CGRectGetMinX(self.frame)+backButton.frame.size.width, self.frame.size.height*0.85+backButton.frame.size.height/2)
        backButton.name = "Back Button"
        self.addChild(backButton)
        
        let purchaseButton = SKSpriteNode(imageNamed: "purchaseButton")
        purchaseButton.setScale(scale)
        purchaseButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 200)
        purchaseButton.name = "Purchase Button"
        self.addChild(purchaseButton)
        
        let coinsLabel = SKLabelNode(text: "Your Coins: " + String(gameData.getCoins()))
        coinsLabel.setScale(scale)
        coinsLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.65)
        coinsLabel.fontName = Constants.FontName.Title_Font
        coinsLabel.fontSize = Constants.FontSize.DispFontSize
        coinsLabel.fontColor = UIColor.blackColor()
        coinsLabel.name = "Coins Label"
        self.addChild(coinsLabel)
        
        let livesLabel = SKLabelNode(text: "Your Lives: " + String(gameData.getLives()))
        livesLabel.setScale(scale)
        livesLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.7)
        livesLabel.fontName = Constants.FontName.Title_Font
        livesLabel.fontSize = Constants.FontSize.DispFontSize
        livesLabel.fontColor = UIColor.blackColor()
        livesLabel.name = "Lives Label"
        self.addChild(livesLabel)
    }
    
    // MARK: Gesture Setup
    private func setupGestures() {
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view?.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        self.view?.addGestureRecognizer(swipeLeftGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.numberOfTapsRequired = 1
        //self.view?.addGestureRecognizer(tapGesture)
    }
    func handleTap(sender:UITapGestureRecognizer) {
        if sender.state == .Ended {
            if sender.locationInView(self.view).x > CGRectGetMidX(self.frame) {
                swipeLeft()
            } else if sender.locationInView(self.view).x <= CGRectGetMidX(self.frame) {
                swipeRight()
            }
        }
    }
    func swipeRight() {
        self.wheel.moveRight()
    }
    func swipeLeft() {
        self.wheel.moveLeft()
    }
    // MARK Purchase Items from Plist
    private func getPurchaseItems() -> [PurchaseItem] {
        var purchases:[PurchaseItem] = []
        if let plist = Plist(name: "PurchasesList") {
            let dict = plist.getValuesInPlist()!
            for (key,value) in dict {
                let subDict = value as! NSDictionary
                let value = subDict["coins"] as! String
                let cost  = subDict["cost"]  as! Float
                let image = subDict["image"] as! String
                let productID = subDict["purchaseID"] as! String
                let item = PurchaseItem(value: value, forAPriceOf: cost, withID: productID, withImage: image)
                purchases.append(item)
                item.name = key as? String
                item.hidden = true
                item.zPosition = 0
            }
        } else {
            print("Unable to get Plist")
        }
        return purchases.reverse()
    }
    
    // MARK: Game Data Protocol
    func saveGame(withData:GameData) {
        let encodedData = NSKeyedArchiver.archiveRootObject(gameData, toFile: GameData.archiveURL.path!)
        if !encodedData {
            print("Save Failed")
        }
    }
    func loadInstance() -> GameData {
        let data = NSKeyedUnarchiver.unarchiveObjectWithFile(GameData.archiveURL.path!) as? GameData
        if data == nil {
            print("Data could not be loaded properly")
            return GameData()
        }
        return data!
    }
    
    //--------------------------------------------------------
    // MARK: STORE KIT METHODS
    //--------------------------------------------------------
    func getProducts() {
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            
            let productIDs:Set = Set(arrayLiteral: ProductIDs.onehundredCoins, ProductIDs.fiveHundredcoins,
                                        ProductIDs.onethousandCoins, ProductIDs.removeAds, ProductIDs.saveLife)
            
            let requests = SKProductsRequest(productIdentifiers: productIDs)
            requests.delegate = self
            requests.start()
            
        } else {
            print("please enable IAPS")
            let alert_controller = UIAlertController(title: "Enable In App Purchases", message: "please enable in app purchase in the iOS settings app", preferredStyle: UIAlertControllerStyle.Alert)
            
            let dismiss_action = UIAlertAction(title: "No Thanks.", style: UIAlertActionStyle.Default) {
                UIAlertAction in
            }
            alert_controller.addAction(dismiss_action)
            self.scene?.view?.window?.rootViewController?.presentViewController(alert_controller, animated: true, completion: nil)
        }
        
    }
    func RestorePurchase() {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    func purchaseProduct(withID:String) {
        for product in productsList {
            if(withID == product.productIdentifier) {
                if withID == ProductIDs.saveLife {
                    if gameData.getCoins() >= 200 {
                        purchaseLifeForCoins()
                    } else {
                        p = product
                        buyProduct(p)
                        break
                    }
                } else {
                    p = product
                    buyProduct(p)
                    break
                }
            }
        }
    }
    private func purchaseLifeForCoins() {
        let alertController = UIAlertController(title: "Life for 200 Coins", message: "Would you like to purchase a life for 200 coins", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let purchaseAction = UIAlertAction(title: "Yes Please!", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.gameData.removeCoins(200)
            self.gameData.addLife()
            self.saveGame(self.gameData)
            let coinsLabel = self.childNodeWithName("Coins Label") as! SKLabelNode
            coinsLabel.text = "Your Coins: " + String(self.gameData.getCoins())
            let livesLabel = self.childNodeWithName("Lives Label") as! SKLabelNode
            livesLabel.text = "Your Lives: " + String(self.gameData.getLives())
            FIRAnalytics.logEventWithName(kFIREventSpendVirtualCurrency, parameters: nil)
        }
        let dismissAction = UIAlertAction(title: "No Thanks.", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            FIRAnalytics.logEventWithName("Save_Life_Purchase_Canceled", parameters: nil)
        }
        alertController.addAction(purchaseAction)
        alertController.addAction(dismissAction)
        self.scene?.view?.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
    func buyProduct(prod:SKProduct) {
        //println("buy " + prod.productIdentifier)
        let pay = SKPayment(product: prod)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        
        for product in myProduct {
//            print("product added")
//            print(product.productIdentifier)
//            print(product.localizedTitle)
//            print(product.localizedDescription)
//            print(product.price)
            
            productsList.append(product as SKProduct)
        }
    }
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("transactions restored")
        
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction as SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case ProductIDs.removeAds:
                print("remove ads")
                NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "ads")
            default:
                print("IAP not setup")
            }
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add paymnet")
        
        //activityIndicator.startAnimating()
        self.userInteractionEnabled = false
        for transaction:AnyObject in transactions {
            
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    let prodID = p.productIdentifier as String
                    
                    switch prodID {
                    case ProductIDs.onehundredCoins:
                        gameData.addCoins(100)
                        FIRAnalytics.logEventWithName("100_Coins_Purchased", parameters: nil)
                    case ProductIDs.fiveHundredcoins:
                        gameData.addCoins(500)
                        FIRAnalytics.logEventWithName("500_Coins_Purchased", parameters: nil)
                    case ProductIDs.onethousandCoins:
                        gameData.addCoins(1000)
                        FIRAnalytics.logEventWithName("1000_Coins_Purchased", parameters: nil)
                    case ProductIDs.removeAds:
                        //defaults.setInteger(1, forKey: "ads")
                        //self.appDelegate.adView.hidden = true
                        //self.appDelegate.adView.removeFromSuperview()
                        break
                    case ProductIDs.saveLife:
                        gameData.addLife()
                        FIRAnalytics.logEventWithName("Save_Life_Purchased", parameters: nil)
                        break
                    default:
                        print("IAP not setup")
                    }
                    saveGame(self.gameData)
                    print("Product Purchased");
                    let coinsLabel = self.childNodeWithName("Coins Label") as! SKLabelNode
                    coinsLabel.text = "Your Coins: " + String(self.gameData.getCoins())
                    let livesLabel = self.childNodeWithName("Lives Label") as! SKLabelNode
                    livesLabel.text = "Your Lives: " + String(self.gameData.getLives())
                    //self.activityIndicator.stopAnimating()
                    self.userInteractionEnabled = true
                    SKPaymentQueue.defaultQueue().finishTransaction(trans)
                    break;
                case .Failed:
                    print("Purchased Failed");
                    SKPaymentQueue.defaultQueue().finishTransaction(trans)
                    break;
                case .Restored:
                    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
                default:
                    break;
                }
            }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction) {
        print("finish trans")
        print(trans.error?.localizedDescription)
        //activityIndicator.stopAnimating()
        self.userInteractionEnabled = true
    }
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove trans");
        //purchase_failed = true
        //if activityIndicator.isAnimating() {
        //    activityIndicator.stopAnimating()
        //}
        self.userInteractionEnabled = true
    }
}