//
//  FifthViewController.swift
//  Martian Clock
//
//  Created by Connor McNaboe on 7/6/17.
//  Copyright © 2017 Connor McNaboe. All rights reserved.
//

import Foundation
import UIKit

class FifthViewController: UIViewController {
    
    //Lock orientaiton
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup
        view.addBackground(imageName: "arabiaterra.jpg", contextMode: .scaleAspectFit)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


} 
