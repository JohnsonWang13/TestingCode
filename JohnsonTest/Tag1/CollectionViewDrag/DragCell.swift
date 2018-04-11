//
//  DragCell.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/2/26.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit

class DragCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var dragDropCollectionVC: DragDorpCollectionVC!
    
    var isMoving: Bool = false {
        didSet {
            self.imageView.isHidden = isMoving
            self.backgroundColor = isMoving ? backgroundColor?.withAlphaComponent(0): backgroundColor?.withAlphaComponent(1)
        }
    }
    
    var snapshot: UIView {
        let snapshot: UIView = self.snapshotView(afterScreenUpdates: true)!
        let layer: CALayer = snapshot.layer
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -4, height: 0)
        
        return snapshot
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        
        addSubview(imageView)
        
    }
    
    func content(image: UIImage) {
        imageView.image = image
    }
    
    @objc private func animate() {
        dragDropCollectionVC.animateImageView(statusImageView: imageView)
//        dragDropCollectionVC.presentPhoto(imageView.image!)
        
    }
}
