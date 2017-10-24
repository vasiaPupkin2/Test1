//
//  DetailPhotoCell.swift
//  Test task
//
//  Created by leanid niadzelin on 09.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class DetailPhotoCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.text = "Привет"
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 3
        return label
    }()
    
    let commentDateLabel: UILabel = {
        let label = UILabel()
        label.text = "21.01.2017 2:37PM"
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        containerView.addSubview(commentDateLabel)
        commentDateLabel.anchor(top: nil, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 6, paddingRight: 6, width: 100, height: 12)
        
        containerView.addSubview(commentLabel)
        commentLabel.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: commentDateLabel.leftAnchor, paddingTop: 0, paddingLeft: 6, paddingBottom: 0, paddingRight: 0, width: 0, height: 0
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            containerView.backgroundColor = UIColor.mainGray()
        } else {
            containerView.backgroundColor = UIColor.rgb(red: 240, green: 247, blue: 250)
        }
    }
    
    override func prepareForReuse() {
        commentLabel.text = nil
        commentDateLabel.text = nil
    }
    
}
