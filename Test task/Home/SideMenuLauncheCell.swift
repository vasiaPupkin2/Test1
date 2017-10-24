//
//  MoreLauncheCell.swift
//  Test task
//
//  Created by leanid niadzelin on 07.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class SideMenuLauncherCell: BaseCollectionViewCell {
    
    var menuCellContent: Menu? {
        didSet{
            guard let menuCellContent = menuCellContent else { return }
            imageView.image = UIImage(named: menuCellContent.imageName)
            titleLabel.text = menuCellContent.titleName.rawValue
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override func setupViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 6, paddingLeft: 12, paddingBottom: 6, paddingRight: 0, width: 48, height: 48)
        titleLabel.anchor(top: topAnchor, left: imageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        if isHighlighted {
            backgroundColor = .black
        }
    }
}
