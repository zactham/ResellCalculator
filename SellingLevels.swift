//
//  SellingLevels.swift
//  Selling Fees
//
//  Created by Zac on 9/19/18.
//  Copyright © 2018 Zac. All rights reserved.
//

import UIKit

var stockxlvlAmount = 2
var stockxPercent = 0.09
var customFee = 0.0


class SellingLevels: UIViewController {

    @IBOutlet weak var stockXLevel: UILabel!
    
    @IBOutlet weak var sliderValue: UISlider!
    
    @IBOutlet weak var customPercent: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customPercent.keyboardType = UIKeyboardType.decimalPad
        
        //Sets the stockX level that was previously assigned
        var stockXLevelDefault = UserDefaults.standard
        if(stockXLevelDefault.value(forKey: "stockXLevel") != nil)
        {
            stockxlvlAmount = stockXLevelDefault.value(forKey: "stockXLevel") as! NSInteger
            print("Loading StockX Level from user defaults as: ", stockxlvlAmount);
        }
        else
        {
            print("No StockXLevel key found");
        }
        stockXLevel.text = String(stockxlvlAmount)
        self.sliderValue.value = Float((stockxlvlAmount))
        
        var customFeeDefault = UserDefaults.standard
        if(customFeeDefault.value(forKey: "customFee") != nil)
        {
            customFee = customFeeDefault.value(forKey: "customFee") as! Double
            print("Loading Custom Fee from user defaults as: ", customFee);
        }
        else
        {
            print("No Custom Fee key found");
        }
       customPercent.text = String(customFee)
        
         customPercent?.addDoneToolbar(onDone: (target: self, action: #selector(doneButtonTappedForMyNumericTextField)))
        //customPercent.delegate = self as! UITextFieldDelegate


        // Do any additional setup after loading the view.
    }
    
    @objc func doneButtonTappedForMyNumericTextField() {
        print("Done");
        customPercent.resignFirstResponder()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider)
    {
        stockXLevel.text = String(Int(sliderValue.value))
        
        stockxlvlAmount = Int (stockXLevel.text!)!
        
        var stockXLevelDefault = UserDefaults.standard
        stockXLevelDefault.setValue(stockxlvlAmount, forKey: "stockXLevel")
        stockXLevelDefault.synchronize()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setPercentage(_ sender: UITextField) {
        customFee = double_t (customPercent.text!)!
        print("Custom Fee: ", customFee)
        
        var customFeeDefault = UserDefaults.standard
        customFeeDefault.setValue(customFee, forKey: "customFee")
        customFeeDefault.synchronize()
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if(settingsScreen == 1)//Sneaker Page
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SSID")as! SneakersStreetwear
            self.present(vc, animated: false, completion: nil)
        }
        else if(settingsScreen == 2)//Ticket Page
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TicketsID")as! Tickets
            self.present(vc, animated: false, completion: nil)
        }
        else if(settingsScreen == 3)//Toy Page
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TMID")as! ToysMisc
            self.present(vc, animated: false, completion: nil)
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

