//
//  MapCell.swift
//  Test task
//
//  Created by leanid niadzelin on 09.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class MapCell: BaseCollectionViewCell {
    
    var mapView: UIView? {
        didSet{
            guard let mapView = mapView else { return }
            addSubview(mapView)
            mapView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        }
    }
}
