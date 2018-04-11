//
//  PhotoSelectCollectionVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/3/6.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit
import Photos

protocol PhotoSelectDelegate {
    func sendPhotos(_ photos: Set<UIImage>)
}

class PhotoSelectCollectionVC: UIViewController {
    
    @IBOutlet weak var photoSelectCollectionView: UICollectionView!
    
    var imageArray = [UIImage]()
    var selectedImageArray = Set<UIImage>()
    var delegate: PhotoSelectDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCollectionView()
    }
    
    func settingCollectionView() {
        
        photoSelectCollectionView.delegate = self
        photoSelectCollectionView.dataSource = self
        
        photoSelectCollectionView.allowsSelection = true
        photoSelectCollectionView.allowsMultipleSelection = true
        
        photoSelectCollectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        let nib = UINib(nibName: "PhotoCell", bundle: nil)
        photoSelectCollectionView.register(nib, forCellWithReuseIdentifier: "photoCell")
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Collection View Delegate
extension PhotoSelectCollectionVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cell.content(image: imageArray[indexPath.row], isSelected: true)
            selectedImageArray.insert(imageArray[indexPath.row])
            delegate.sendPhotos(selectedImageArray)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell {
            cell.content(image: imageArray[indexPath.row], isSelected: false)
            selectedImageArray.remove(imageArray[indexPath.row])
            delegate.sendPhotos(selectedImageArray)
        }
    }
}

// MARK: - Collection View Flow Layout
extension PhotoSelectCollectionVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 5
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

// MARK: - Collection View Data Source
extension PhotoSelectCollectionVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        let isSelected = selectedImageArray.contains(imageArray[indexPath.row])
        cell.content(image: imageArray[indexPath.row], isSelected: isSelected)
        
        return cell
    }
}
