//
//  PhotoSelectorController.swift
//  Test task
//
//  Created by leanid niadzelin on 07.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit
import Photos
import CoreLocation

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var currentLocation: CLLocationCoordinate2D?
    weak var homeController: HomeController?
    
    let cellId = "cellId"
    let headerId = "headerId"
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        setupNavItems()
        fetchPhotos()
    }
    
    private func setupNavItems() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 3.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.7
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handlePostPhoto))
    }
    
    
    
    @objc private func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    // Save photo
    
    @objc private func handlePostPhoto() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let selectedImage = self.selectedImage else { return }
        
        guard let imageData = UIImageJPEGRepresentation(selectedImage.compressImageLow(), 0.1) else { return }
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
                    self.homeController?.collectionView?.reloadData()
                }
            }
        })
        handleCancel()
    }
    
    
    // Fetch photos from gallery
    
    private func assetFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 100
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
        
    }
    
    private func fetchPhotos() {

        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetFetchOptions())

        DispatchQueue.global(qos: .background).sync {
            allPhotos.enumerateObjects({ (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                let targetSize = CGSize(width: 200, height: 200)
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadInputViews()
                        }
                    }
                })
            })
        }
    }
    
    // Collection View
    
    var header: PhotoSelectorHeader?
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        self.header = header
        if let selectedImage = selectedImage {
            if let index = images.index(of: selectedImage) {
                let selectedAsset = assets[index]
                let targetSize = CGSize(width: 600, height: 600)
                let imageManager = PHImageManager.default()
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFit, options: nil, resultHandler: { (image, info) in
                    self.header?.imageView.image = image
                })
            }
        }
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = images[indexPath.item]
        collectionView.reloadData()
        
        let index = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: index, at: .bottom, animated: true)
 }
}
