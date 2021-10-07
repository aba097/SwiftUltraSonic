//
//  ViewController.swift
//
//  Created by aba097 on 2021/09/26.
//

import UIKit

class ViewController: UIViewController {

    var ultrasonic = UltraSonic()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            
        //再生する
        ultrasonic.startSound()
        
        //再生を停止する
        //ultrasonic.stopSound()
    
    }
    
}

