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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AuthorizationManager.config { (config) in
            config.title = "aa"
            config.message = "aa"
            config.presentingViewController = self
        }.authorizedContacts { (result) in
            print(result)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

