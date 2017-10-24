//
//  MainNavController.swift
//  Test task
//
//  Created by leanid niadzelin on 06.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class MainNavController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.value(forKey: "token") != nil {
            let layout = UICollectionViewFlowLayout()
            let homeController = HomeController(collectionViewLayout: layout)
            viewControllers = [homeController]
        } else {
            let loginController = LoginController()
            viewControllers = [loginController]
        }
    }
}
