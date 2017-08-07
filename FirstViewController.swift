//
//  FirstViewController.swift
//  Martian Clock
//
//  Created by Connor McNaboe on 6/29/17.
//  Copyright © 2017 Connor McNaboe. All rights reserved.
//

import UIKit
import Foundation

class FirstViewController: UIViewController {
    
    let clock = MarsTime()
    var mctTimer = Timer()
    @IBOutlet weak var mctLabel: UILabel!
    @IBOutlet weak var auLabel: UILabel!
    
    //Lock orientation
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup
        view.addBackground(imageName: "marsDraw.png", contextMode: .scaleAspectFit)
        
        //fire timer
        mctTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(FirstViewController.updateTimeLabel)), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTimeLabel()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func updateTimeLabel() {
        //calculate paramaters needed for time function 
        let millis = clock.currentTimeMillis()
        let jdUT = clock.julianDateUT(millis: millis)
        let jdTT = clock.julianDateTT(julianDateUT: jdUT)
        let mct = clock.marsCoordinatedTime(julianDateTT: jdTT)
        let clockTime = clock.clockTime(mct: mct)
        
        //Sets MCT time label
        mctLabel.text = clockTime[0] + ":" + clockTime[1] + ":" + clockTime[2]
        
        //Sets AU distance label
        let deltaJ = clock.deltatJ2000(julianDateTT: jdTT)
        let ma = clock.marsMeanAnomaly(deltatJ2000: deltaJ)
        var au = clock.marsDistance(ma: ma)
        au = Double(round(au * 1000.00) / 1000.00)
        auLabel.text = String(au)
        
    }

}


class MarsTime {
    //Creates/ holds functions needed to calculate time and date info for mars
    
    
    func currentTimeMillis() -> (Int) {// Convert time to milliseconds
        let date = Date().timeIntervalSince1970
        let currentTimeMillis = Int(date * 1000)
        return (currentTimeMillis)
    }
    
    func julianDateUT(millis: Int) -> (Double) { // Convert julian date universial time
        let julianDateUT = 2440587.5 + (Double(millis) / (8.64 * pow(10, 7)))
        return (julianDateUT)
    }
    
    func julianDateTT(julianDateUT: Double) -> (Double) {// Convert to julian date Terrestrial time
        let julianDateTT = julianDateUT + ((32.184 + 37.0) / (86400.0))
        return (julianDateTT)
    }
    
    func deltatJ2000(julianDateTT: Double) -> (Double) {// Calculate time offset from J2000 Epoch
        let deltatJ2000 = julianDateTT - 2451545.0
        return (deltatJ2000)
    }
    
    func marsMeanAnomaly(deltatJ2000: Double) -> (Double) { // Calculate the mean anomaly of the martian orbit
        let maUncorrected = 19.3871 + 0.52402073*(deltatJ2000)
        let n360s = Int( maUncorrected / 360.0) * 360
        let marsMeanAnomaly = maUncorrected - Double(n360s)
        return marsMeanAnomaly
    }
    
    func angleFictionMeanSun(deltatJ2000: Double) -> (Double) {  // Calulate angle of Fiction mean sun
        let afmsUncorrected = 270.3871 + 0.524038496*(deltatJ2000)
        let n360s = Int(afmsUncorrected / 360.0) * 360
        let angleFictionMeanSun = afmsUncorrected - Double(n360s)
        return (angleFictionMeanSun)
    }
    
    func perturbers(deltatJ2000: Double) -> (Double) { // Calculate perturbers
        let pbs = 0.0071 * cos(.pi / 180.0 * (((0.985626*deltatJ2000)/2.2353) + 49.409)) +
            0.0057 * cos(.pi / 180.0 * (((0.985626*deltatJ2000)/2.7543) + 168.173)) +
            0.0039 * cos(.pi / 180.0 * (((0.985626*deltatJ2000)/1.1177) + 191.837)) +
            0.0037 * cos(.pi / 180.0 * (((0.985626*deltatJ2000)/15.7866) + 21.736)) +
            0.0021 * cos(.pi / 180.0 * (((0.985626*deltatJ2000)/2.1354) + 15.704)) +
            0.0020 * cos(.pi / 180.0 * (((0.985626*deltatJ2000)/2.4694) + 95.528)) +
            0.0018 * cos(.pi / 180.0 * (((0.985626*deltatJ2000)/32.8493) + 49.095))
        return (pbs)
    }
    
    func v_M(deltatJ2000: Double, pbs: Double, marsMeanAnomaly: Double) -> (Double) { // Determine the equation of center
        let A = (10.691 + (3*pow(10, -7))*deltatJ2000)
        let B = Int((10.691 + (3*pow(10, -7))*deltatJ2000) / 360)*360
        let leadingConstant = A + Double(B)
        let v_M = (leadingConstant)*sin(.pi / 180.0 * (marsMeanAnomaly)) +
            0.623*sin(.pi / 180.0 * (2*marsMeanAnomaly)) + 0.050*sin(.pi / 180.0 * (3*marsMeanAnomaly)) +
            0.005*sin(.pi / 180.0 * (4*marsMeanAnomaly)) + 0.0005*sin(.pi / 180.0 * (5*marsMeanAnomaly)) +
        pbs
        return (v_M)
    }
    
    func aerocentSolarLong(angleFictionMeanSun: Double, v_M: Double) -> (Double) {
        let l_s = (angleFictionMeanSun + v_M) - Double(Int((angleFictionMeanSun + v_M) / 360)*360)
        return (l_s)
    }
    
    func martianEquationOfTime(l_s: Double, v_M: Double) -> (Double) {
        let eot = 2.861*sin(.pi / 180.0 * (2*l_s)) - 0.071*sin(.pi / 180.0 * (4*l_s)) +
            0.002*sin(.pi / 180.0 * (6*l_s)) - v_M
        return (eot)
    }
    
    
    func marsCoordinatedTime(julianDateTT: Double) -> (Double) {
        let mct = (24.0 * (((julianDateTT - 2451549.5) / 1.0274912517) + 44769.0 - 0.0009626))
        let mctFinal = mct.truncatingRemainder(dividingBy: 24.0)
        return (mctFinal)
    }
    
    func localMeanSolarTime(mct: Double, deg: Double) -> (Double)  { // Solar time for any longtitude west of the prime meridian
        let lmst = mct - deg*(1.0 / 15.0)
        return (lmst)
    }
    
    
    func marsDistance(ma: Double) -> (Double) {
        let helioDistance = 1.5236*(1.00436 - 0.09309*cos(.pi / 180.0 * (ma))
            - 0.00436*cos(.pi / 180.0 * (2*ma)) - 0.00031*cos(.pi / 180.0 * (3*ma)))
        return (helioDistance)
    }
    
    
    
    func clockTime(mct: Double) -> Array<String> {
        
        
        let mctStr = String(mct)
        var strHours = mctStr.components(separatedBy: ".")
        var mctHours  = strHours[0]
        var strMin = String(60 * Double("." + strHours[1])!).components(separatedBy: ".")
        var mctMin = strMin[0]
        var strSec = String(60 * Double("." + strMin[1])!).components(separatedBy: ".")
        var mctSec = strSec[0]
        let sec = mctSec.characters.count
        let min =  mctMin.characters.count
        let hour = mctHours.characters.count
        if 1 <= sec && sec < 2 {
            mctSec = "0" + mctSec
        } else if mctSec.characters.count < 1 {
            mctSec = "00"
        }
        if 1 <= min && min < 2 {
            mctMin = "0" + mctMin
        } else if mctMin.characters.count < 1 {
            mctMin = "00"
        }
        if 1 <= hour && hour < 2 {
            mctHours = "0" + mctHours
        } else if hour < 1 {
            mctHours = "00"
        }
        
        let mctClockTime = [mctHours , mctMin ,  mctSec]
        return (mctClockTime)
    }
    
    
    func marsSolDate(deltatJ2000: Double) -> (Double) {
        let msd = ((deltatJ2000 - 4.5)  / 1.027491252) + 44796.0 - 0.00096
        return (msd)
        
    }
    
    func marsYear(msd: Double) -> (Int) {
        let deltaMY1 = msd - 28222.51
        let mY = Int(deltaMY1 / 668.59)
        return (mY)
    }
    
    func mySol(msd: Double, mY: Int) -> (Int) {
        let deltaMY1 = Int(msd - 28222.51)
        let deci = (Double(deltaMY1 ) / 668.5910) - Double(mY)
        let sol = Int(deci * 668.5910)
        
        return (sol)
    }

}
//global struct which locks screen orientation 

// Code fills image to fit any iphone screen
extension UIView {
    func addBackground(imageName: String = "YOUR DEFAULT IMAGE NAME", contextMode: UIViewContentMode = .scaleToFill) {
        // setup the UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = contentMode
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundImageView)
        sendSubview(toBack: backgroundImageView)
        
        // adding NSLayoutConstraints
        let leadingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
    
}
// locks screen orientation
extension UITabBarController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let selectedVC = selectedViewController{
                return selectedVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let selectedVC = selectedViewController{
                return selectedVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let selectedVC = selectedViewController{
                return selectedVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }}

