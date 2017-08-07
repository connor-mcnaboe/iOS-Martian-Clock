//
//  ThirdViewController.swift
//  Martian Clock
//
//  Created by Connor McNaboe on 7/2/17.
//  Copyright © 2017 Connor McNaboe. All rights reserved.
//

import UIKit
import Foundation


class ThirdViewController: UIViewController {
    
    let clock = MarsTime()
    var lsTimer = Timer()
    @IBOutlet weak var lsLabel: UILabel!
    @IBOutlet weak var monthLabel : UILabel!
    @IBOutlet weak var weekSolLabel: UILabel!
    @IBOutlet weak var solLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    //Lock orientation 
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup
        view.addBackground(imageName: "marsSun.png", contextMode: .scaleAspectFit)
        
        //Fire timer 
        lsTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ThirdViewController.updateDateLabels)), userInfo: nil, repeats: true)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDateLabels()
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func updateDateLabels() {
        //Calculate paramaters needed for mars sol and year functions, set labels
        let millis = clock.currentTimeMillis()
        let jdUT = clock.julianDateUT(millis: millis)
        let jdTT = clock.julianDateTT(julianDateUT: jdUT)
        let deltaj = clock.deltatJ2000(julianDateTT: jdTT)
        let ptb = clock.perturbers(deltatJ2000: deltaj)
        let aFm  = clock.angleFictionMeanSun(deltatJ2000: deltaj)
        let ma = clock.marsMeanAnomaly(deltatJ2000: deltaj)
        let vM = clock.v_M(deltatJ2000: deltaj, pbs: ptb, marsMeanAnomaly: ma)
        var l_s = clock.aerocentSolarLong(angleFictionMeanSun: aFm, v_M: vM)
        l_s = Double(round(l_s * 1000.00) / 1000.00)
        lsLabel.text = String(l_s) + "\u{00B0}"
        
        let months = ["Sagittarius", "Dhanus", "Capricornus","Makara", "Aquarius", "Kumbha", "Pisces", "Mina", "Aries", "Mesha", "Taurus", "Rishabha", "Gemini", "Mithuna", "Cancer", "Karka", "Leo", "Simha", "Virgo", "Kanya", "Libra", "Tula", "Scorpius", "Vrishika"]
        let week = ["Solis", "Lunae", "Martis", "Mercurii", "Jovis", "Veneris", "Saturni"]
        
        let msd = clock.marsSolDate(deltatJ2000: deltaj)
        let mY = clock.marsYear(msd: msd)
        let sol = clock.mySol(msd: msd, mY: mY)
        var msol = 28
        
       
        //Determine which month of the Darian year it is
        if 0 < sol && sol <= 28 {
            monthLabel.text = months[0]
        }
        else if 28 < sol && sol <= 56 {
            monthLabel.text = months[1]
            msol = sol - 28
        }
        else if 56 < sol && sol <= 84 {
            monthLabel.text = months[2]
            msol = sol - 56
        }
        else if 84 < sol && sol <= 112 {
            monthLabel.text = months[3]
            msol = sol - 84
        }
        else if 112 < sol && sol <= 140 {
            monthLabel.text = months[4]
            msol = sol - 112
        }
        else if 140 < sol && sol <= 167 { //27
            monthLabel.text = months[5]
            msol = sol - 140
        }
        else if 167 < sol && sol <= 195 {
            monthLabel.text = months[6]
            msol = sol - 167
        }
        else if 195 < sol && sol <= 223 {
            monthLabel.text = months[7]
            msol = sol - 195
        }
        else if 223 < sol && sol <= 251 {
            monthLabel.text = months[8]
            msol = sol - 223
        }
        else if 251 < sol && sol <= 279 {
            monthLabel.text = months[9]
            msol = sol - 251
        }
        else if 279 < sol && sol <= 307 {
            monthLabel.text = months[10]
            msol = sol - 279
        }
        else if 307 < sol && sol <= 334 { //27
            monthLabel.text = months[11]
            msol = sol - 307
        }
        else if 334 < sol && sol <= 362 {
            monthLabel.text = months[12]
            msol = sol - 334
        }
        else if 362 < sol && sol <= 390 {
            monthLabel.text = months[13]
            msol = sol - 362
        }
        else if 290 < sol && sol <= 418 {
            monthLabel.text = months[14]
            msol = sol - 290
        }
        else if 418 < sol && sol <= 446 {
            monthLabel.text = months[15]
            msol = sol - 418
        }
        else if 446 < sol && sol <= 474 {
            monthLabel.text = months[16]
            msol = sol - 446
        }
        else if 474 < sol && sol <= 501 { //27
            monthLabel.text = months[17]
            msol = sol - 474
        }
        else if 501 < sol && sol <= 529 {
            monthLabel.text = months[18]
            msol = sol - 501
        }
        else if 529 < sol && sol <= 557 {
            monthLabel.text = months[19]
            msol = sol - 529
        }
        else if 557 < sol && sol <= 585 {
            monthLabel.text = months[20]
            msol = sol - 557
        }
        else if 585 < sol && sol <= 613 {
            monthLabel.text = months[21]
            msol = sol - 585
        }
        else if 613 < sol && sol <= 641 {
            monthLabel.text = months[22]
            msol = sol - 613
        }
        else if 641 < sol && sol <= 668 {
            monthLabel.text = months[23]
            msol = sol - 641
        }
        
        // Day of the month logic
        if msol <= 7 {
            let i = msol - 1
            weekSolLabel.text = week[i]
        }
        else if msol > 7 && msol <= 14 {
            let i = msol - 8
            weekSolLabel.text = week[i]
        }
        else if msol > 14 && msol <= 21 {
            let i = msol - 15
            weekSolLabel.text = week[i]
        }
        else {
            let i = msol - 22
            weekSolLabel.text = week[i]
        }
        
        yearLabel.text = String(mY)
        solLabel.text = String(sol)
    }
    
    
}
