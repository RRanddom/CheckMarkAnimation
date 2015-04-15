//
//  ViewController.swift
//  
//
//  Created by apple on 15-4-14.
//  Copyright (c) 2015年 apple.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var checkMarkButton: CheckMarkButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkMarkButton.addTarget(self, action: "toggle:", forControlEvents: UIControlEvents.TouchDown)
    }
    
    func toggle(sender: AnyObject!) {
        checkMarkButton.showAnimation = !checkMarkButton.showAnimation
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

