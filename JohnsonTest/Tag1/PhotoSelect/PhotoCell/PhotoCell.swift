//
//  PhotoCell.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/3/6.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedMask: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        selectedMask.layer.borderWidth = 2
        selectedMask.layer.borderColor = UIColor.red.cgColor
    }
    
    func content(image: UIImage, isSelected: Bool) {
        
        imageView.image = image
        
        selectedMask.isHidden = !isSelected
    }
}
