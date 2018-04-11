//
//  DragDorpCollectionVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/2/23.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit

class DragDorpCollectionVC: UIViewController {
    
    var images: [UIImage] = [#imageLiteral(resourceName: "AppCoverPhoto"), #imageLiteral(resourceName: "Astonishing-Pic-of-a-Huge-Waterspount-at-Tampa-Bay-Florida"), #imageLiteral(resourceName: "web link")]
    var longPressGestureRecognizer: UILongPressGestureRecognizer?
    var currentDragCell: DragCell?
    var currentDragAndDropIndexPath: IndexPath?
    var currentDragAndDropSnapshot: UIView?
    
    //-----
    var statusImageView = UIImageView()
    var zoomImageView = UIImageView()
    var imageBackgroundView = UIView()
    
    //    fileprivate var animationController: PhotoShowTransitionController = PhotoShowTransitionController()
    //    var selectedIndex: Int?
    //    var hideSelectedCell: Bool = false
    
    @IBOutlet weak var dragAndDropCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCollectionView()
    }
    
    private func settingCollectionView() {
        dragAndDropCollectionView.delegate = self
        dragAndDropCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        
        dragAndDropCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        dragAndDropCollectionView.setCollectionViewLayout(layout, animated: false)
        
        dragAndDropCollectionView.showsVerticalScrollIndicator = false
        dragAndDropCollectionView.showsHorizontalScrollIndicator = false
        
        longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGustureAction))
        //        longPressGestureRecognizer?.isEnabled = false
        dragAndDropCollectionView.addGestureRecognizer(longPressGestureRecognizer!)
        
    }
    
    @objc private func longPressGustureAction(sender: UILongPressGestureRecognizer) {
        
        let currentLocation = sender.location(in: dragAndDropCollectionView)
        let indexPathForLocation: IndexPath? = dragAndDropCollectionView.indexPathForItem(at: currentLocation)
        
        switch sender.state {
        case .began:
            if let indexPathForLocation = indexPathForLocation {
                currentDragAndDropIndexPath = indexPathForLocation
                currentDragCell = dragAndDropCollectionView.cellForItem(at: indexPathForLocation) as? DragCell
                currentDragAndDropSnapshot = currentDragCell?.snapshot
                self.updateDragAndDropSnapshotView(alpha: 0.0, center: currentDragCell!.center, transform: CGAffineTransform.identity)
                dragAndDropCollectionView.addSubview(currentDragAndDropSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: {
                    self.updateDragAndDropSnapshotView(alpha: 0.95, center: self.currentDragCell!.center, transform: CGAffineTransform.init(scaleX: 1.05, y: 1.05))
                    self.currentDragCell?.isMoving = true
                })
            }
            
        case .changed:
            currentDragAndDropSnapshot?.center = currentLocation
            if let indexPathForLocation = indexPathForLocation {
                let image: UIImage = images[currentDragAndDropIndexPath!.row]
                images.remove(at: currentDragAndDropIndexPath!.row)
                images.insert(image, at: indexPathForLocation.row)
                dragAndDropCollectionView.moveItem(at: currentDragAndDropIndexPath!, to: indexPathForLocation)
                currentDragAndDropIndexPath = indexPathForLocation
            }
            
        default:
            if let currentDragCell = currentDragCell {
                UIView.animate(withDuration: 0.25, animations: {
                    self.updateDragAndDropSnapshotView(alpha: 0.0, center: currentDragCell.center, transform: CGAffineTransform.identity)
                    currentDragCell.isMoving = false
                }, completion: { _ in
                    self.currentDragAndDropSnapshot?.removeFromSuperview()
                    self.currentDragAndDropSnapshot = nil
                })
            }
        }
    }
    
    func updateDragAndDropSnapshotView(alpha: CGFloat, center: CGPoint, transform: CGAffineTransform) {
        if let currentDragAndDropSnapshot = currentDragAndDropSnapshot {
            currentDragAndDropSnapshot.alpha = alpha
            currentDragAndDropSnapshot.center = center
            currentDragAndDropSnapshot.transform = transform
        }
    }
    
    func presentPhoto(_ photo: UIImage) {
        //        let pickPhotoIndex = images.index(of: photo) ?? 0
        //
        //        performSegue(withIdentifier: "PhotoPageSegue", sender: nil)
        
        //        let pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoPageViewController") as! PhotoPageViewController
        //
        //        pageViewController.dragDropDelegate = self
        //        pageViewController.transitioningDelegate = self
        //        pageViewController.photos = images
        //        pageViewController.currentPhoto = pickPhotoIndex
        //        pageViewController.modalPresentationStyle = .overFullScreen
        //
        //        present(pageViewController, animated: true, completion: nil)
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let photoPageView = segue.destination as? PhotoPageViewController {
    //            photoPageView.transitioningDelegate = self
    //            photoPageView.dragDropDelegate = self
    //            photoPageView.currentPhoto = 0
    //            photoPageView.photos = images
    //        }
    //    }
    
    // ------------- animte
    func animateImageView(statusImageView: UIImageView) {
        
        self.statusImageView = statusImageView
        let selectPhotoIndex = images.index(of: statusImageView.image!) ?? 0
        
        if let startFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {

            statusImageView.alpha = 0
            
            imageBackgroundView.frame = self.view.frame
            imageBackgroundView.backgroundColor = .black
            imageBackgroundView.alpha = 0
            self.view.addSubview(imageBackgroundView)
            
            zoomImageView.frame = startFrame
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFit
            zoomImageView.clipsToBounds = true
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            self.view.addSubview(zoomImageView)
            
            UIView.animate(withDuration: 0.3, animations: {
                let height = self.view.frame.height
                
                let y = self.view.frame.height / 2 - height / 2
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                
                self.imageBackgroundView.alpha = 1
            }, completion: { (_) in
                
                let pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoPageViewController") as! PhotoPageViewController
        
                pageViewController.dragDropViewController = self
                pageViewController.photos = self.images
                pageViewController.currentPhoto = selectPhotoIndex
                
                self.present(pageViewController, animated: false, completion: nil)
                
                self.zoomImageView.image = nil
            })
        }
    }
    
    @objc func zoomOut(currentImageIndex: Int) {
        
        statusImageView.alpha = 1
        
        let cell = dragAndDropCollectionView.cellForItem(at: IndexPath(row: currentImageIndex, section: 0)) as! DragCell
        statusImageView = cell.imageView
        
        statusImageView.alpha = 0
        
        if let startFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            UIView.animate(withDuration: 0.3, animations: {
                self.zoomImageView.frame = startFrame
                self.imageBackgroundView.alpha = 0
            }, completion: { (_) in
                self.zoomImageView.removeFromSuperview()
                self.imageBackgroundView.removeFromSuperview()
                self.statusImageView.alpha = 1
            })
        }
    }
}

// MARK: - Collection View Flow Layout
extension DragDorpCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}

// MARK: - Collection View Data Source
extension DragDorpCollectionVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dragCell", for: indexPath) as! DragCell
        
        cell.content(image: images[indexPath.row])
        cell.dragDropCollectionVC = self
        
        return cell
    }
}


//// MARK: UIViewControllerTransitioningDelegate
//
//extension DragDorpCollectionVC: DragDorpCollectionDelegate {
//    func updateSelectedIndex(newIndex: Int){
//        selectedIndex = newIndex
//    }
//}
//
//protocol DragDorpCollectionDelegate {
//    func updateSelectedIndex(newIndex: Int)
//}
//
//// MARK: UIViewControllerTransitioningDelegate
//
//// 1: Conforming to protocol
//extension DragDorpCollectionVC: UIViewControllerTransitioningDelegate {
//
//    // 2: presentation controller
//    func animationControllerForPresentedController(presented: UIViewController,
//                                                   presentingController presenting: UIViewController,
//                                                   sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let photoViewController = presented as! PhotoPageViewController
//        animationController.setupImageTransition( image: images[selectedIndex!],
//                                                  fromDelegate: self,
//                                                  toDelegate: photoViewController)
//        return animationController
//    }
//
//    // 3: dismissing controller
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let photoViewController = dismissed as! PhotoPageViewController
//        animationController.setupImageTransition( image: images[selectedIndex!],
//                                                  fromDelegate: photoViewController,
//                                                  toDelegate: self)
//        return animationController
//    }
//}
//
//// MARK: ImageTransitionProtocol
//
//extension DragDorpCollectionVC: ImageTransitionProtocol {
//
//    // 1: hide selected cell for tranisition snapshot
//    func tranisitionSetup(){
//        hideSelectedCell = true
//        dragAndDropCollectionView.reloadData()
//    }
//
//    // 2: unhide selected cell after tranisition snapshot is taken
//    func tranisitionCleanup(){
//        hideSelectedCell = false
//        dragAndDropCollectionView.reloadData()
//    }
//
//    // 3: return window frame of selected image
//    func imageWindowFrame() -> CGRect{
//        let indexPath = IndexPath(row: selectedIndex!, section: 0)
//        let attributes = dragAndDropCollectionView.layoutAttributesForItem(at: indexPath)
//        let cellRect = attributes!.frame
//        return dragAndDropCollectionView.convert(cellRect, to: nil)
//    }
//}

