//
//  SecondViewController.swift
//  Martian Clock
//
//  Created by Connor McNaboe on 6/29/17.
//  Copyright © 2017 Connor McNaboe. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    let clock = MarsTime()
    var lmstTimer = Timer()
    @IBOutlet weak var lmstLabel: UILabel!
    @IBOutlet weak var lmstField: UITextField!
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lmstField.delegate = self as? UITextFieldDelegate;
         self.addDoneButton()
        
        //Asthetics
        view.addBackground(imageName: "lmstBack.png", contextMode: .scaleAspectFit)
        
        //fire timer
        lmstTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(FirstViewController.updateTimeLabel)), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimeLabel()
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    func updateTimeLabel() {
        //Calc paramaters needed for lmst call, limit text field to numbers under 360
        let millis = clock.currentTimeMillis()
        let jdUT = clock.julianDateUT(millis: millis)
        let jdTT = clock.julianDateTT(julianDateUT: jdUT)
        let mct = clock.marsCoordinatedTime(julianDateTT: jdTT)
        var deg = lmstField.text
        
        if deg == "" {
            deg = "0"
        }
        if Int(deg!)! > 360 {
            deg = "0"
            lmstField.text = "0"
        }
        
        var lmst = clock.localMeanSolarTime(mct: mct, deg: Double(deg!)!)
        print(lmst)
        if lmst < 0 {
            lmst = lmst + 24
        }
        var clockTime = clock.clockTime(mct: lmst)
        
        print(clockTime)
        //Sets MCT time label
        lmstLabel.text = clockTime[0] + ":" + clockTime[1] + ":" + clockTime[2]
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        lmstField.inputAccessoryView = keyboardToolbar
    }
    

    
}

