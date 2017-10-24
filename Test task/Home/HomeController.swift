//
//  HomeController.swift
//  Test task
//
//  Created by leanid niadzelin on 06.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreData


class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate {
    
    let cellId = "cellId"
    let mapCellId = "mapCellId"
    let locationManager = CLLocationManager()
    var entityDescription: NSEntityDescription?
    var resultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var curentLocation = CLLocationCoordinate2D()
    var isMap: Bool = false
    
    lazy var menuLauncher: SideMenuLauncher = {
        let launcher = SideMenuLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), for: .normal)
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.shadowRadius = 1.5
        button.layer.shadowOpacity = 1
        button.addTarget(self, action: #selector(handlePlusButton), for: .touchUpInside)
        return button
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsController?.delegate = self
        locationManager.delegate = self
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        fetchPhotos()
        setupLocationManager()
        setupInsets()
        setupNavItems()
        setupPlusButton()
        setupCollectionView()
    }
    
    func reloadCollectionView() {
        collectionView?.reloadData()
        setupInsets()
        guard let count = resultsController?.fetchedObjects?.count, count > 0 else { return }
        let index = IndexPath(item: 0, section: 0)
        collectionView?.scrollToItem(at: index, at: .bottom, animated: false)
    }
    
    @objc private func handleMenuButtonItem() {
        menuLauncher.showMenu()
    }
    
    private func setupInsets() {
        let inset = view.frame.width / 16
        if isMap {
            collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            collectionView?.contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        }
    }
    
    private func setupNavItems() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 3.0
        navigationController?.navigationBar.layer.shadowOpacity = 0.7
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menu-icon"), style: .plain, target: self, action: #selector(handleMenuButtonItem))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    private func setupPlusButton() {
        view.addSubview(plusButton)
        plusButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 12, width: 72, height: 72)
    }
    
    // Long press delete
    
    @objc private func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.collectionView)

            if let indexPath = collectionView?.indexPathForItem(at: touchPoint) {
                guard let resultsController = resultsController else { return }
                let photo = resultsController.object(at: indexPath) as! Photo
                
                let alert = UIAlertController(title: "", message: "Do you want to delete this photo?", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                    
                    API.shared.removePhoto(itemId: Int(photo.itemId), completion: { success, response, error in
                        if success {
                            if error == "removePhotoError" {
                                let alert = UIAlertController(title: "", message: "Internal Server Error", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: nil))
                                CoreDataManager.shared.managedObjectContext.delete(photo)
                                CoreDataManager.shared.saveContext()
                                self.fetchPhotos()
                                self.collectionView?.reloadData()
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                CoreDataManager.shared.managedObjectContext.delete(photo)
                                CoreDataManager.shared.saveContext()
                                self.fetchPhotos()
                                self.collectionView?.reloadData()
                            }
                        }
                    })
                    
                }))
                
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    // Get photos
    
    func fetchPhotos() {
        entityDescription = NSEntityDescription.entity(forEntityName: "Photo", in: CoreDataManager.shared.managedObjectContext)
        resultsController = CoreDataManager.shared.getFetchedResultController(entityName: "Photo", sortDescriptor: "date", ascending: false)
        do {
            try resultsController?.performFetch()
        } catch {
            let err = error as NSError
            print("Failed fetch request:", err.localizedDescription)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.reloadData()
    }
    
    @objc private func handlePlusButton() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (_) in
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            photoSelectorController.homeController = self
            photoSelectorController.currentLocation = self.curentLocation
            self.navigationController?.pushViewController(photoSelectorController, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            let cameraController = CameraController()
            cameraController.homeController = self
            cameraController.currentLocation = self.curentLocation
            self.present(cameraController, animated: true, completion: nil)
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // Get location
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let coordinate = manager.location?.coordinate else { return }
        self.curentLocation = coordinate
        locationManager.stopUpdatingLocation()
    }
    
    // Collection View
    
    private func setupCollectionView() {
        collectionView?.backgroundColor = .white
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(MapCell.self, forCellWithReuseIdentifier: mapCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isMap {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapCellId, for: indexPath) as! MapCell
            let camera = GMSCameraPosition.camera(withTarget: curentLocation, zoom: 5.5)
            let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
            
            
            let objects = resultsController?.fetchedObjects
            objects?.forEach({ (object) in
                let photo = object as! Photo
                let marker = GMSMarker()
                let imageView = CustomImageView()
                imageView.loadImage(urlString: photo.imageURL!)
                imageView.image = imageView.image?.compressImageHigh()
                imageView.backgroundColor = UIColor.mainLightGray()
                imageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
                imageView.layer.cornerRadius = 5
                imageView.layer.borderColor = UIColor.gray.cgColor
                imageView.layer.borderWidth = 2
                imageView.contentMode = .scaleAspectFill
                imageView.layer.masksToBounds = true
                marker.iconView = imageView
                marker.position = CLLocationCoordinate2D(latitude: photo.latitude, longitude: photo.longitude)
                marker.map = mapView
            })
            cell.mapView = mapView
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoCell
            let photo = resultsController?.object(at: indexPath) as! Photo
            cell.imageView.loadImage(urlString: photo.imageURL ?? "")
            let date = Date(timeIntervalSince1970: TimeInterval(photo.date))
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            cell.textLabel.text = formatter.string(from: date)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMap {
            return 1
        } else {
            if let count = resultsController?.fetchedObjects?.count  {
                return count
            } else {
                return 0
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailPhotoController = DetailPhotoController()
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        if isMap {
            return CGSize(width: width, height: view.frame.height)
        } else {
            return CGSize(width: width / 4, height: (width / 4) + 20)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if isMap {
            return 0
        } else {
            return view.frame.width / 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if isMap {
            return 0
        } else {
            return view.frame.width / 16
        }
    }
    
    
   
}
