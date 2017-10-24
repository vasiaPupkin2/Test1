//
//  MoreLauncher.swift
//  Test task
//
//  Created by leanid niadzelin on 07.10.17.
//  Copyright © 2017 Leanid Niadzelin. All rights reserved.
//

import UIKit

class SideMenuLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    weak var homeController: HomeController?
    let cellId = "cellId"
    let headerId = "headerId"
    let cellHeight: CGFloat = 50
    let blackView = UIView()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let menuContent: [Menu] = {
        let photos = Menu(titleName: .photos, imageName: "icon")
        let map = Menu(titleName: .map, imageName: "map2")
        return [photos, map]
    }()
    
    override init() {
        super.init()
        collectionView.register(SideMenuLauncherCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(SideMenuLauncherHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.backgroundColor = UIColor.rgb(red: 252, green: 249, blue: 249)
    }
    
    func showMenu() {
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            let widthOfMenu: CGFloat = window.frame.width - 100
            
            collectionView.frame = CGRect(x: -widthOfMenu, y: 0, width: widthOfMenu, height: window.frame.height)
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: widthOfMenu, height: window.frame.height)
            }, completion: nil)
            
        }
    }
    
    @objc private func handleDismiss() {
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0
                self.collectionView.frame = CGRect(x: -self.collectionView.frame.width, y: 0, width: self.collectionView.frame.width, height: window.frame.height)
            }, completion: { (completion: Bool) in
                self.collectionView.visibleCells.forEach({ (cell) in
                    cell.backgroundColor = UIColor.rgb(red: 252, green: 249, blue: 249)
                })
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SideMenuLauncherCell
        cell.menuCellContent = menuContent[indexPath.item]
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentView = homeController?.collectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) as? MapCell
        if indexPath.item == 0 && currentView == nil {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.mainGray()
            handleDismiss()
        } else if indexPath.item == 1 && currentView != nil {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.mainGray()
            handleDismiss()
        } else if indexPath.item == 0 && currentView != nil {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.mainGray()
            homeController?.isMap = false
            homeController?.reloadCollectionView()
            handleDismiss()
        } else {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.mainGray()
            homeController?.isMap = true
            homeController?.reloadCollectionView()
            handleDismiss()
        
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuContent.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SideMenuLauncherHeader
        let username = UserDefaults.standard.value(forKey: "login") as? String
        header.usernameLabel.text = username?.capitalized
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 168)
        }
 
}
