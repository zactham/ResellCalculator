//
//  ViewController.swift
//  Selling Fees
//
//  Created by Zac on 7/20/18.
//  Copyright © 2018 Zac. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import StoreKit

//TESTING - ca-app-pub-3940256099942544/4411468910
// PUBLISHING - ca-app-pub-9397447406737552/7484291205
class Tickets: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    
    var bannerView: GADBannerView!
    
    
    @IBOutlet weak var amountSpent: UITextField!
    @IBOutlet weak var sellingPrice: UITextField!
  
    @IBOutlet weak var amountReceived: UILabel!
    
    @IBOutlet weak var totalProfit: UILabel!
    ////////
   
    @IBOutlet weak var marketplace: UIPickerView!
    
    //Takes a screenshot for the share
    var screenshot = UIGraphicsGetImageFromCurrentImageContext()
    
    let markets = ["Stubhub", "SeatGeek", "eBay", "Paypal", "Custom"]
    
    var currentMarket = "Stubhub"
    
    var audioPlayer = AVAudioPlayer()//sound
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountSpent.keyboardType = UIKeyboardType.decimalPad
        sellingPrice.keyboardType = UIKeyboardType.decimalPad
        
        if(purchasedRemoveAds == 0)
        {
            bannerAds()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        
        self.marketplace.delegate = self;
        self.marketplace.dataSource = self;
        
        amountSpent?.addDoneToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        sellingPrice?.addDoneToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
      
        amountSpent.delegate = self
        sellingPrice.delegate = self
        
        
        sounds();
        
    }
    
    @objc func doneButtonTappedForMyNumericTextField() {
        print("Done");
        amountSpent.resignFirstResponder()
        sellingPrice.resignFirstResponder()
    }
    
    func bannerAds()
    {
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.delegate = self as? GADBannerViewDelegate
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-9397447406737552/7484291205"
        bannerView.rootViewController = self
        
        bannerView.load(GADRequest())
        
        
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    func sounds()
    {
        //Allows background music like spotify to be played while app is running
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError {
            print(error)
        }
        
    }
    
    func cashSound()
    {
        //Plays the cash register sound even if phone is on silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            // report for an error
        }
        
        //Cash Register Sound
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "cashRegisterSound", ofType: "mp3")!))
            audioPlayer.volume = 0.2;
            audioPlayer.prepareToPlay()
            
            
        }
        catch{
            print(error)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //AMOUNT OF ROWS
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return markets[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return markets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentMarket = markets[row]
    }
    
    @IBAction func restartButton(_ sender: UIButton)
    {
        amountSpent.text = String(describing: 0)
        sellingPrice.text = String(describing: 0)
        amountReceived.text = String(describing: 0)
        totalProfit.text = String(describing: 0)
        var currentMarket = "Stubhub"
    }
    
    @IBAction func backButtonPushed(_ sender: UIButton)
    {
        amountSpent.text = String(describing: 0)
        sellingPrice.text = String(describing: 0)
        amountReceived.text = String(describing: 0)
        totalProfit.text = String(describing: 0)
        var currentMarket = "Stubhub"
    }
    
   
    
    @IBAction func calculateButton(_ sender: UIButton)
    {
        if(playSound)
        {
            cashSound()
        }
        var aS = double_t (amountSpent.text!)
        var sP = double_t (sellingPrice.text!)
        
        if(sP == nil)
        {
            sP = 0.0
        }
        
        if(aS == nil)
        {
            aS = 0.0
        }
        
        var aR = double_t(0.0)
        
        //ebay takes 10% + paypal 2.9% and $0.30 = about 13%
        if (currentMarket == "eBay")
        {
            aR = double_t (sP! * 0.871 - 0.30)
        }
            //stubhub takes 10%
        else if (currentMarket == "Stubhub")
        {
            aR = double_t (sP! * 0.90)
        }
            //seatgeek takes 15%
        else if (currentMarket == "SeatGeek")
        {
            aR = double_t (sP! * 0.85)
        }
            //paypal takes 2.9% + 0.30
        else if (currentMarket == "Paypal")
        {
            aR = double_t (sP! * 0.971 - 0.30)
        }
        else if (currentMarket == "Custom")
        {
            var tempCustomFee = (1 - customFee/100)
            print(" Custom Fee: ", tempCustomFee)
            aR = double_t (sP! * tempCustomFee)
        }
        
        var profit = aR - aS!
        
        amountReceived.text = String(format: "%.2f", aR)
        totalProfit.text = String(format: "%.2f", profit)
        
        //Plays cash register sound
        if(playSound)
        {
        audioPlayer.play()
        }
        
        
    }
    
    //Screenshot
    func takeScreenshot()
    {
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
        takeScreenshot()
        
        let activityController = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        
        present(activityController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func settingsPressed(_ sender: UIButton) {
         settingsScreen = 2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sellingPrice.resignFirstResponder()
    }
}
extension Tickets : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}





