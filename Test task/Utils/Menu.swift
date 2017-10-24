//
//  Menu.swift
//  Test task
//
//  Created by leanid niadzelin on 07.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import Foundation

class Menu: NSObject {
    let titleName: MenuNames
    let imageName: String

    init(titleName: MenuNames, imageName: String) {
        self.titleName = titleName
        self.imageName = imageName
    }
}

enum MenuNames: String {
    case photos = "Photos"
    case map = "Map"
}

