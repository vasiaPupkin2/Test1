//
//  HomeCell.swift
//  Test task
//
//  Created by leanid niadzelin on 07.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class PhotoCell: BaseCollectionViewCell {
    
    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = UIColor.mainLightGray()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 3
        iv.clipsToBounds = true
        return iv
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    
    override func setupViews() {
        addSubview(imageView)
        addSubview(textLabel)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        imageView.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        textLabel.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 6, paddingBottom: 0, paddingRight: 6, width: 0, height: 20)
        
    }
}
