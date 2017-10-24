//
//  PreviewPhotoContrainerView.swift
//  Test task
//
//  Created by leanid niadzelin on 08.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit
import Photos
import CoreData

class PreviewPhotoContainerView: UIView {
    var currentLocation: CLLocationCoordinate2D?
    weak var homeController: HomeController?
    let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleCancelButton() {
        self.removeFromSuperview()
    }
    
    // Save photo
    
    @objc private func handleSaveButton() {
        guard let image = imageView.image else { return }
        guard let imageData = UIImageJPEGRepresentation(image.compressImageLow(), 0.1) else { return }
        let timeInterval: Int = Int(Date().timeIntervalSince1970)
        
        API.shared.postPhoto(imageData: imageData.base64EncodedString(), date: timeInterval, latitude: currentLocation?.latitude ?? 0, longitude: currentLocation?.longitude ?? 0, completion: { success, response, error in
            
            if success {
                guard let entityDescription = self.homeController?.entityDescription else { return }
                let photo = Photo(entity: entityDescription, insertInto: CoreDataManager.shared.managedObjectContext)
                photo.itemId = (response?["data"]["id"].int32!)!
                photo.date = (response?["data"]["date"].int32!)!
                photo.imageURL = response?["data"]["url"].stringValue
                photo.comment = nil
                photo.latitude = (response?["data"]["lat"].doubleValue)!
                photo.longitude = (response?["data"]["lng"].doubleValue)!
                CoreDataManager.shared.saveContext()
                self.homeController?.fetchPhotos()
                DispatchQueue.main.async {
                    let savedLabel = UILabel()
                    savedLabel.text = "Saved Successfully"
                    savedLabel.textColor = .white
                    savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                    savedLabel.numberOfLines = 0
                    savedLabel.textAlignment = .center
                    savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                    savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                    savedLabel.center = self.center
                    self.addSubview(savedLabel)
                    
                    savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                    }, completion: { (isCompleted) in
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                            savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                            savedLabel.alpha = 0
                        }, completion: { (isCompleted) in
                            savedLabel.removeFromSuperview()
                            self.homeController?.fetchPhotos()
                            self.homeController?.collectionView?.reloadData()
                            self.handleCancelButton()
                        })
                    })
                }
            }
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(cancelButton)
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        addSubview(saveButton)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 0, width: 50, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

