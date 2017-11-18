//
//  StoreScene.swift
//  FiveByFive
//
//  Created by Nicholas Cracchiolo on 5/4/16.
//  Copyright © 2016 Nick Cracchiolo. All rights reserved.
//

import SpriteKit
import StoreKit

class StoreScene:SKScene, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var wheel:FFWheel = FFWheel()
	var gameData:GameData?
    var p = SKProduct()
    var productsList = [SKProduct]()
    var activityIndicator:UIActivityIndicatorView!
    
	override func didMove(to view: SKView) {
        gameData = loadInstance()
        setupGestures()
        setupScene()
		SKPaymentQueue.default().add(self)
        getProducts()
        
//        activityIndicator = UIActivityIndicatorView()
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.activityIndicatorViewStyle = .Gray
//        activityIndicator.color = UIColor(red: 255/255, green: 36/255, blue: 31/255, alpha: 1.0)
//        activityIndicator.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
//        print("About to add activity indicator")
//        self.scene!.view!.addSubview(activityIndicator)
    }
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch:AnyObject in touches {
			let location = (touch as! UITouch).location(in: self)
			let node = self.atPoint(location)
			if node.name == "Purchase Button" {
				if SKPaymentQueue.default().transactions.count <= 1 {
					let item = wheel.currentObject() as! PurchaseItem
					purchaseProduct(withID: item.purchaseID)
				}
			}
			if node.name == "Back Button" {
				let scene = StartScene(size: self.size)
				scene.gameData = self.gameData
				self.view?.presentScene(scene)
			}
		}
	}
    
    // MARK: Scene Setup
    private func setupScene() {
        self.backgroundColor = UIColor.white
        let scale = self.frame.size.width/414.0
        
        let storeLabel = SKLabelNode(text: "Store")
        storeLabel.setScale(scale)
        storeLabel.fontName = Constants.FontName.Game_Font
        storeLabel.fontSize = Constants.FontSize.Title
        storeLabel.fontColor = UIColor.black
		storeLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.85)
        self.addChild(storeLabel)
        
        wheel = FFWheel(withNodes: getPurchaseItems())
        wheel.setScale(scale)
		wheel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.addChild(wheel)
        
        let backButton = SKSpriteNode(imageNamed: "backButton")
        backButton.setScale(scale)
		backButton.position = CGPoint(x: self.frame.minX+backButton.frame.size.width, y: self.frame.size.height*0.85+backButton.frame.size.height/2)
        backButton.name = "Back Button"
        self.addChild(backButton)
        
        let purchaseButton = SKSpriteNode(imageNamed: "purchaseButton")
        purchaseButton.setScale(scale)
		purchaseButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200)
        purchaseButton.name = "Purchase Button"
        self.addChild(purchaseButton)
		var coins = 0
		var lives = 0
		if let data = gameData {
			coins = data.getCoins()
			lives = data.getLives()
		}
        let coinsLabel = SKLabelNode(text: "Your Coins: " + String(coins))
        coinsLabel.setScale(scale)
		coinsLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.65)
        coinsLabel.fontName = Constants.FontName.Title_Font
        coinsLabel.fontSize = Constants.FontSize.DispFontSize
        coinsLabel.fontColor = UIColor.black
        coinsLabel.name = "Coins Label"
        self.addChild(coinsLabel)
        
        let livesLabel = SKLabelNode(text: "Your Lives: " + String(lives))
        livesLabel.setScale(scale)
		livesLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height*0.7)
        livesLabel.fontName = Constants.FontName.Title_Font
        livesLabel.fontSize = Constants.FontSize.DispFontSize
        livesLabel.fontColor = UIColor.black
        livesLabel.name = "Lives Label"
        self.addChild(livesLabel)
    }
    
    // MARK: Gesture Setup
    private func setupGestures() {
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view?.addGestureRecognizer(swipeRightGesture)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left
        self.view?.addGestureRecognizer(swipeLeftGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.numberOfTapsRequired = 1
        //self.view?.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap(sender:UITapGestureRecognizer) {
		if sender.state == .ended {
			if sender.location(in: self.view).x > self.frame.midX {
                swipeLeft()
			} else if sender.location(in: self.view).x <= self.frame.midX {
                swipeRight()
            }
        }
    }
    @objc func swipeRight() {
        self.wheel.moveRight()
    }
    @objc func swipeLeft() {
        self.wheel.moveLeft()
    }
    // MARK Purchase Items from Plist
    private func getPurchaseItems() -> [PurchaseItem] {
        var purchases:[PurchaseItem] = []
        if let plist = Plist(name: "PurchasesList") {
            let dict = plist.getValuesInPlist()!
            for (key,value) in dict {
                let subDict = value as! NSDictionary
                let value = subDict["coins"] as! Int
                let cost  = subDict["cost"]  as! Float
                let image = subDict["image"] as! String
                let productID = subDict["purchaseID"] as! String
				let item = PurchaseItem(value: String(describing: value), forAPriceOf: cost, withID: productID, withImage: image)
                purchases.append(item)
                item.name = key as? String
                item.isHidden = true
                item.zPosition = 0
            }
        } else {
            print("Unable to get Plist")
        }
        return purchases.reversed()
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
            let alert_controller = UIAlertController(title: "Enable In App Purchases", message: "please enable in app purchase in the iOS settings app", preferredStyle: UIAlertControllerStyle.alert)
            
            let dismiss_action = UIAlertAction(title: "No Thanks.", style: UIAlertActionStyle.default) {
                UIAlertAction in
            }
            alert_controller.addAction(dismiss_action)
			self.scene?.view?.window?.rootViewController?.present(alert_controller, animated: true, completion: nil)
        }
        
    }
    func RestorePurchase() {
		SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    func purchaseProduct(withID:String) {
        for product in productsList {
            if(withID == product.productIdentifier) {
                if withID == ProductIDs.saveLife {
                    if let data = self.gameData, data.getCoins() >= 200 {
                        purchaseLifeForCoins()
                    } else {
                        p = product
						buyProduct(prod: p)
                        break
                    }
                } else {
                    p = product
					buyProduct(prod: p)
                    break
                }
            }
        }
    }
    private func purchaseLifeForCoins() {
        let alertController = UIAlertController(title: "Life for 200 Coins", message: "Would you like to purchase a life for 200 coins", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let purchaseAction = UIAlertAction(title: "Yes Please!", style: UIAlertActionStyle.default) {
            UIAlertAction in
			guard let data = self.gameData else {
				return
			}
			data.removeCoins(value: 200)
            data.addLife()
			self.saveGame(withData: data)
			let coinsLabel = self.childNode(withName: "Coins Label") as! SKLabelNode
			coinsLabel.text = "Your Coins: " + String(data.getCoins())
			let livesLabel = self.childNode(withName: "Lives Label") as! SKLabelNode
            livesLabel.text = "Your Lives: " + String(data.getLives())
        }
        let dismissAction = UIAlertAction(title: "No Thanks.", style: UIAlertActionStyle.default) {
            UIAlertAction in
        }
        alertController.addAction(purchaseAction)
        alertController.addAction(dismissAction)
		self.scene?.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    func buyProduct(prod:SKProduct) {
        //println("buy " + prod.productIdentifier)
        let pay = SKPayment(product: prod)
		SKPaymentQueue.default().add(pay as SKPayment)
    }
	
	func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
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
	func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction as SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case ProductIDs.removeAds:
                print("remove ads")
				UserDefaults.standard.set(1, forKey: "ads")
            default:
                print("IAP not setup")
            }
        }
    }
    
	func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add paymnet")
        
        //activityIndicator.startAnimating()
		self.isUserInteractionEnabled = false
		guard let data = self.gameData else {
			return
		}
        for transaction:AnyObject in transactions {
			
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
				case .purchased:
                    let prodID = p.productIdentifier as String
                    
                    switch prodID {
                    case ProductIDs.onehundredCoins:
						data.addCoins(value: 100)
                    case ProductIDs.fiveHundredcoins:
						data.addCoins(value: 500)
                    case ProductIDs.onethousandCoins:
						data.addCoins(value: 1000)
                    case ProductIDs.removeAds:
                        //defaults.setInteger(1, forKey: "ads")
                        //self.appDelegate.adView.hidden = true
                        //self.appDelegate.adView.removeFromSuperview()
                        break
                    case ProductIDs.saveLife:
                        data.addLife()
                        break
                    default:
                        print("IAP not setup")
                    }
					saveGame(withData: data)
                    print("Product Purchased");
					let coinsLabel = self.childNode(withName: "Coins Label") as! SKLabelNode
                    coinsLabel.text = "Your Coins: " + String(data.getCoins())
					let livesLabel = self.childNode(withName: "Lives Label") as! SKLabelNode
					livesLabel.text = "Your Lives: " + String(data.getLives())
                    //self.activityIndicator.stopAnimating()
					self.isUserInteractionEnabled = true
					SKPaymentQueue.default().finishTransaction(trans)
                    break;
				case .failed:
                    print("Purchased Failed");
					SKPaymentQueue.default().finishTransaction(trans)
                    break;
				case .restored:
					SKPaymentQueue.default().restoreCompletedTransactions()
                default:
                    break;
                }
            }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction) {
        print("finish trans")
		if let e = trans.error {
        	print(e.localizedDescription)
		}
        //activityIndicator.stopAnimating()
        self.isUserInteractionEnabled = true
    }
	func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove trans");
        //purchase_failed = true
        //if activityIndicator.isAnimating() {
        //    activityIndicator.stopAnimating()
        //}
        self.isUserInteractionEnabled = true
    }
}
