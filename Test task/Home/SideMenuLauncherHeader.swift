//
//  MenuLauncherHeader.swift
//  Test task
//
//  Created by leanid niadzelin on 07.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class SideMenuLauncherHeader: BaseCollectionViewCell {
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 247, green: 251, blue: 243)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Username"
        return label
    }()
    
    override func setupViews() {
        backgroundColor = UIColor.mainGreen()
        addSubview(usernameLabel)
        usernameLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 0, height: 40)
    }
}
