//
//  ViewController.swift
//  Cabin
//
//  Created by QianTuFD on 2017/4/11.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AuthorizationManager.configure { (config) in
            config.title = "弹框标题" //
            config.message = "弹框内容" //
            config.presentingViewController = self
            }.authorizedContacts {
                
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

