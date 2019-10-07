

import UIKit
import AVFoundation
import StoreKit
import CoreData

var audioPlayer = AVAudioPlayer()//sound
var endScreen = 0
var purchasedRemoveAds = 0
var settingsScreen = 0
var playSound = true

class HomeScreen: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
   
    
    @IBOutlet weak var removeAdsButton: UIButton!
    
    @IBOutlet weak var soundToggleButton: UIButton!
    @IBOutlet weak var restorePurchasesButton: UIButton!
    
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    var purchasedRemovedAdsDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(playSound)
        {
            let image = UIImage(named: "icons8-speaker-26.png") as UIImage!
            let playButton  = UIButton(type: UIButtonType.custom) as! UIButton
            soundToggleButton.setImage(image, for: [])
           
            
        }
        else
        {
            let image = UIImage(named: "icons8-no-audio-26.png") as UIImage!
            let playButton  = UIButton(type: UIButtonType.custom) as! UIButton
            soundToggleButton.setImage(image, for: [])
            
        }
        
        removeAdsButton.isEnabled = false
        restorePurchasesButton.isEnabled = false
        if(purchasedRemoveAds == 1)
        {
            removeAdsButton.isHidden = true;
        }
        
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID: NSSet = NSSet(objects: "zac.SellingFees.RemoveAds")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
        // Do any additional setup after loading the view.
        
        
        var purchasedAdsDefault = UserDefaults.standard
        if(purchasedAdsDefault.value(forKey: "purchasedAds") != nil)
        {
            purchasedRemoveAds = purchasedAdsDefault.value(forKey: "purchasedAds") as! NSInteger
            print("Loading purchased ads value from user defaults as: ", purchasedRemoveAds);
        }
        else
        {
            print("No purchasedAds key found");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func muteButton(_ sender: UIButton)
    {
        if(playSound)
        {
            playSound = false;
            let image = UIImage(named: "icons8-no-audio-26.png") as UIImage!
            let playButton  = UIButton(type: UIButtonType.custom) as! UIButton
            soundToggleButton.setImage(image, for: [])
            
        }
        else{
            playSound = true;
            let image = UIImage(named: "icons8-speaker-26.png") as UIImage!
            let playButton  = UIButton(type: UIButtonType.custom) as! UIButton
            soundToggleButton.setImage(image, for: [])
           
        }
    }
    @IBAction func removeAds(_ sender: UIButton)
    {
        //purchasedRemoveAds = true
        print("rem ads")
        for product in list {
            let prodID = product.productIdentifier
            if(prodID == "zac.SellingFees.RemoveAds") {
                p = product
                buyProduct()
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let myProduct = response.products
        print("myProduct size=");
        print(myProduct.count);
        for product in myProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product)
        }
        removeAdsButton.isEnabled = true
        restorePurchasesButton.isEnabled = true
        
    }
    
    public func buyProduct() {
        print("buy " + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
        
    }
    
    func updateAdsVariable()
    {
        var purchasedAdsDefault = UserDefaults.standard
        purchasedAdsDefault.setValue(purchasedRemoveAds, forKey: "purchasedAds")
        print("Saving PURCHASED ADS to UserDefault as: ", purchasedRemoveAds);
        purchasedAdsDefault.synchronize()
    }
    
    @IBAction func restorePurchases(_ sender: Any)
    {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "zac.SellingFees.RemoveAds":
                print("remove ads")
                purchasedRemoveAds = 1
                updateAdsVariable()
                UserDefaults.standard.set(true, forKey: "Key") //Bool
            default:
                print("IAP not found")
            }
        }
        
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
            case .purchased:
                print("buy ok, unlock IAP HERE")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier
                switch prodID {
                case "zac.SellingFees.RemoveAds":
                    print("remove ads")
                    purchasedRemoveAds = 1
                    updateAdsVariable()
                default:
                    print("IAP not found")
                }
                queue.finishTransaction(trans)
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break
            default:
                print("Default")
                break
            }
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


