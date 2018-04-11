//
//  PhotoPageViewController.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/3/15.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit

class PhotoPageViewController: UIPageViewController {
    
//    var dragDropDelegate: DragDorpCollectionDelegate?
    var dragDropViewController: DragDorpCollectionVC!
    var scrollView: UIScrollView!
    var photos: [UIImage]!
    var subViewControllers = [PhotoShowVC]()
    var currentPhoto = 0
    fileprivate var pageControl = UIPageControl()
    fileprivate var closeBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.alwaysBounceVertical = false
        
        self.view.backgroundColor = .black
        self.delegate = self
        self.dataSource = self
        
        closeBtn = UIButton(frame: CGRect(x: 12, y: 12, width: 24, height: 24))
        closeBtn.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closePhoto(_:)), for: .touchUpInside)
        self.view.addSubview(closeBtn)
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = photos.count
        pageControl.currentPage = currentPhoto
        pageControl.tintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        self.view.addSubview(pageControl)
        
        for photo in photos {
            let photoShowVC = PhotoShowVC()
            photoShowVC.imageView.image = photo
            subViewControllers.append(photoShowVC)
        }
        
        setViewControllers([subViewControllers[currentPhoto]], direction: .forward, animated: true, completion: nil)
        
//        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(onDrage(_:))))
    }
    
    @objc func closePhoto(_ sender: UIButton) {
        dragDropViewController.zoomImageView.image = dragDropViewController.images[currentPhoto]
        dismiss(animated: false) {
            self.dragDropViewController.zoomOut(currentImageIndex: self.currentPhoto)
        }
    }
    
//    @objc func onDrage(_ sender: UIPanGestureRecognizer) {
//        let percentThreshold:CGFloat = 0.3
//        let translation = sender.translation(in: view)
//
//        let newY = ensureRange(value: view.frame.minY + translation.y, minimum: 0, maximum: view.frame.maxY)
//        let progress = progressAlongAxis(newY, view.bounds.width)
//
//        view.frame.origin.y = newY //Move view to new position
//
//        if sender.state == .ended {
//            let velocity = sender.velocity(in: view)
//            if velocity.y >= 300 || progress > percentThreshold {
//                self.dismiss(animated: true) //Perform dismiss
//            } else {
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.view.frame.origin.y = 0 // Revert animation
//                })
//            }
//        }
//
//        sender.setTranslation(.zero, in: view)
//    }
    
//    func progressAlongAxis(_ pointOnAxis: CGFloat, _ axisLength: CGFloat) -> CGFloat {
//        let movementOnAxis = pointOnAxis / axisLength
//        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
//        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
//        return CGFloat(positiveMovementOnAxisPercent)
//    }
//
//    func ensureRange<T>(value: T, minimum: T, maximum: T) -> T where T : Comparable {
//        return min(max(value, minimum), maximum)
//    }
}

extension PhotoPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0] as! PhotoShowVC
        currentPhoto = subViewControllers.index(of: pageContentViewController)!
        self.pageControl.currentPage = currentPhoto
        
    }
}

extension PhotoPageViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = subViewControllers.index(of: viewController as! PhotoShowVC) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = subViewControllers.index(of: viewController as! PhotoShowVC) ?? 0
        if currentIndex >= (subViewControllers.count - 1) {
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
}


//// MARK: ImageTransitionProtocol
//
//extension PhotoPageViewController: ImageTransitionProtocol {
//
//    // 1: hide scroll view containing images
//    func tranisitionSetup(){
//        scrollView.isHidden = true
//    }
//
//    // 2; unhide images and set correct image to be showing
//    func tranisitionCleanup(){
//        scrollView.isHidden = false
//        let xOffset = CGFloat(currentPhoto) * scrollView.frame.size.width
//        scrollView.contentOffset = CGPoint(x: xOffset, y: 0)
//    }
//
//    // 3: return the imageView window frame
//    func imageWindowFrame() -> CGRect{
//
//        let photo = photos[currentPhoto]
//        let scrollWindowFrame = scrollView.superview!.convert(scrollView.frame, to: nil)
//
//        let scrollViewRatio = scrollView.frame.size.width / scrollView.frame.size.height
//        let imageRatio = photo.size.width / photo.size.height
//        let touchesSides = (imageRatio > scrollViewRatio)
//
//        if touchesSides {
//            let height = scrollWindowFrame.size.width / imageRatio
//            let yPoint = scrollWindowFrame.origin.y + (scrollWindowFrame.size.height - height) / 2
//            return CGRect(x: scrollWindowFrame.origin.x, y: yPoint, width: scrollWindowFrame.size.width, height: height)
//        } else {
//            let width = scrollWindowFrame.size.height * imageRatio
//            let xPoint = scrollWindowFrame.origin.x + (scrollWindowFrame.size.width - width) / 2
//            return CGRect(x: xPoint, y: scrollWindowFrame.origin.y, width: width, height: scrollWindowFrame.size.height)
//        }
//    }
//}

