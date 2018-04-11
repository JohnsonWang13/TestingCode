//
//  PhotoSelectVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/3/6.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit
import Photos
import TLPhotoPicker

protocol EditPhotoDelegate {
    func editedPhoto(_ image: UIImage)
}

class PhotoSelectVC: UIViewController {
    
    @IBOutlet weak var photoSelectedCollectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageArray = [UIImage]()
    var selectedImageArray = [UIImage]()
    var selectedAssets = [TLPHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        grabPhotos()
        settingCollectionView()
    }
    
    func settingCollectionView() {
        
        photoSelectedCollectionView.delegate = self
        photoSelectedCollectionView.dataSource = self
        
        photoSelectedCollectionView.showsVerticalScrollIndicator = false
        photoSelectedCollectionView.showsHorizontalScrollIndicator = false
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        photoSelectedCollectionView.collectionViewLayout = layout
        
        photoSelectedCollectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        let nib = UINib(nibName: "PhotoCell", bundle: nil)
        photoSelectedCollectionView.register(nib, forCellWithReuseIdentifier: "photoCell")
    }
    @IBAction func selectPhotoAction(_ sender: UIButton) {
        let viewController = SelectSingleViewAndEditVC()
        
        
        viewController.photoEditDelegate = self
//        let viewController = TLPhotosPickerViewController()
        //        viewController.configure.mediaType = PHAssetMediaType.video
        //        viewController.configure.allowedVideo = false
        //        viewController.configure.allowedLivePhotos = false
                viewController.configure.singleSelectedMode = true
        //        viewController.configure.maxVideoDuration = 20
        //        viewController.configure.maxSelectedAssets = 5
        viewController.delegate = self
        viewController.selectedAssets = selectedAssets
        self.present(viewController.wrapNavigationControllerWithoutBar(), animated: true, completion: nil)
    }
}

extension PhotoSelectVC: EditPhotoDelegate {
    func editedPhoto(_ image: UIImage) {
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
    }
}

extension PhotoSelectVC: TLPhotosPickerViewControllerDelegate {
    
    func getAsyncCopyTemporaryFile() {
        if let asset = self.selectedAssets.first {
            asset.tempCopyMediaFile(progressBlock: { (progress) in
                print(progress)
            }, completionBlock: { (url, mimeType) in
                print(mimeType)
            })
        }
    }
    
    func getFirstSelectedImage() {
        
        for asset in selectedAssets {
            if asset.fullResolutionImage == nil {
                asset.cloudImageDownload(progressBlock: { (_) in
                    
                    }, completionBlock: { [weak self] (image) in
                        DispatchQueue.main.async {
                            self?.photoSelectedCollectionView.reloadData()
                        }
                })
            }
        }
        
//        if let asset = self.selectedAssets.first {
//            //            if asset.type == .video {
//            //                asset.videoSize(completion: { [weak self] (size) in
//            ////                    self?.label.text = "video file size\(size)"
//            //                })
//            //                return
//            //            }
//            if let image = asset.fullResolutionImage {
//                print(image)
//                //                self.label.text = "local storage image"
//                //                self.imageView.image = image
//            }else {
//                print("Can't get image at local storage, try download image")
//                asset.cloudImageDownload(progressBlock: { [weak self] (progress) in
//                    DispatchQueue.main.async {
//                        //                        self?.label.text = "download \(100*progress)%"
//                        print(progress)
//                    }
//                    }, completionBlock: { [weak self] (image) in
//                        if let image = image {
//                            //use image
//                            DispatchQueue.main.async {
//                                //                                self?.label.text = "complete download"
//                                //                                self?.imageView.image = image
//                            }
//                        }
//                })
//            }
//        }
    }
    
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        
    }
    
    
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        selectedAssets = withTLPHAssets
        getFirstSelectedImage()
        photoSelectedCollectionView.reloadData()
    }
}

//extension PhotoSelectVC: PhotoSelectDelegate {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? UINavigationController {
//            if let viewController = destination.visibleViewController as? PhotoSelectCollectionVC {
//                viewController.delegate = self
//                viewController.imageArray = imageArray
//                viewController.selectedImageArray = Set(selectedImageArray)
//            }
//        }
//    }
//
//    func sendPhotos(_ photos: Set<UIImage>) {
//        selectedImageArray = photos.reversed()
//        photoSelectedCollectionView.reloadData()
//    }
//
//    func grabPhotos() {
//        DispatchQueue.global().async {
//            let imgManager = PHImageManager.default()
//
//            let requestOptions = PHImageRequestOptions()
//            requestOptions.isSynchronous = true
//            requestOptions.deliveryMode = .highQualityFormat
//
//            let fetchOptions = PHFetchOptions()
//            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//
//            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
//            if fetchResult.count > 0 {
//                for i in 0..<fetchResult.count {
//                    imgManager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFit, options: requestOptions, resultHandler: { (image, error) in
//                        self.imageArray.append(image!)
//                    })
//                }
//            } else {
//                print("no photo")
//            }
//        }
//    }
//}

// MARK: - Collection View Delegate
extension PhotoSelectVC: UICollectionViewDelegate {
    
    
}

// MARK: - Collection View Flow Layout
extension PhotoSelectVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}

// MARK: - Collection View Data Source
extension PhotoSelectVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        cell.content(image: selectedAssets[indexPath.row].fullResolutionImage ?? UIImage(), isSelected: false)
        
        return cell
    }
}
