//
//  FourthViewController.swift
//  Martian Clock
//
//  Created by Connor McNaboe on 7/5/17.
//  Copyright © 2017 Connor McNaboe. All rights reserved.
//

import UIKit
import Foundation
import Kanna
import Alamofire


class FourthViewController: UIViewController {
  
    var tweetArray: [String] = []
    @IBOutlet weak var clouds: UILabel!
    @IBOutlet weak var high : UILabel!
    @IBOutlet weak var low: UILabel!
    @IBOutlet weak var pressure: UILabel!
    
    //Lock orientation
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup
        view.addBackground(imageName: "weatherBack.png", contextMode: .scaleAspectFit)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrapeData()
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrapeData() -> Void {
        Alamofire.request("https://twitter.com/MarsWxReport").responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                let weather = self.parseHTML(html: html)
                let cloudString = weather[5].components(separatedBy: ",")
                self.clouds.text = cloudString[0]
                let highString = weather[7].components(separatedBy: ",")
                self.high.text = highString[0] + "\u{00B0}"
                 let lowString = weather[9].components(separatedBy: ",")
                self.low.text = lowString[0] + "\u{00B0}"
                self.pressure.text = weather[12] + " hpa"
            }
        }
    }
    
    func parseHTML(html: String) -> Array<String>  {
        if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            
            let matched = matches(for: "stream-item-tweet-(\\d*)", in: html)
            print(matched)
            var x = 0
            var i = 0
            while x == 0 {
                let xpath = "//*[@id='" + matched[i] + "']/div[1]/div[2]/div[2]/p/text()"
                print(xpath)
                for tweet in doc.xpath(xpath) {
                    // Strip the string of surrounding whitespace.
                    let tweetString = tweet.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    
                    tweetArray = tweetString.components(separatedBy: " ")
                    
                
                }
                print(tweetArray)
                if (tweetArray.isEmpty == true) || (tweetArray[0] != "Sol") {
                    i = i +  1
                }
                else {
                    x = 1
                        
                }
            
    
            }
        }
       return (tweetArray)
    }
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    
    
}

