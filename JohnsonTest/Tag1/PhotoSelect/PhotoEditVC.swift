//
//  PhotoEditVC.swift
//  JohnsonTest
//
//  Created by Johnson on 2018/3/21.
//  Copyright © 2018年 Johnson. All rights reserved.
//

import UIKit
import TLPhotoPicker

class PhotoEditVC: UIViewController {
    
    var delegate: EditPhotoDelegate!
    var selectedAssets: TLPHAsset!
    
    var imageView = UIImageView()
    var cropOverlay = CropOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(sendImage))
        
        self.view.backgroundColor = .black
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = selectedAssets.fullResolutionImage
        imageView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64)
        self.view.addSubview(imageView)
        
        cropOverlay.frame = CGRect(x: imageView.frame.width / 8,
                                   y: imageView.frame.height / 2 - imageView.frame.width / 4,
                                   width: imageView.frame.width * 3 / 4,
                                   height: imageView.frame.width * 2 / 4)
        cropOverlay.ratio = 1.5
        cropOverlay.isResizable = true
        cropOverlay.isMovable = true
        //        cropOverlay.isEqualRatio = true
        view.addSubview(cropOverlay)
    }
    
    @objc private func sendImage() {
        
        guard let image = imageView.image else { return }
        
        var newImage = image
        
        let cropRect = makeProportionalCropRect()
        let resizedCropRect = CGRect(x: (image.size.width) * cropRect.origin.x,
                                     y: (image.size.height) * cropRect.origin.y,
                                     width: (image.size.width * cropRect.width),
                                     height: (image.size.height * cropRect.height))
        newImage = image.crop(rect: resizedCropRect)
        print(newImage.size)
        delegate.editedPhoto(newImage)
        dismiss(animated: true, completion: nil)
    }
    
    private func makeProportionalCropRect() -> CGRect {
        var cropRect = CGRect(x: cropOverlay.frame.origin.x + cropOverlay.outterGap,
                              y: cropOverlay.frame.origin.y + cropOverlay.outterGap,
                              width: cropOverlay.frame.size.width - 2 * cropOverlay.outterGap,
                              height: cropOverlay.frame.size.height - 2 * cropOverlay.outterGap)
        
        let heightRatio = (imageView.image?.size.height)! / imageView.frame.height
        let widthRatio = (imageView.image?.size.width)! / imageView.frame.width
        var imageWidth: CGFloat = 0
        var imageHeihgt: CGFloat = 0
        
        print(imageView.frame)
        
        if heightRatio > widthRatio {
            imageWidth = (imageView.image?.size.width)! / heightRatio
            imageHeihgt = imageView.frame.height
            cropRect.origin.x += (imageView.frame.width - imageWidth) / 2
        } else {
            imageWidth = imageView.frame.width
            imageHeihgt = (imageView.image?.size.height)! / widthRatio
            cropRect.origin.y -= (imageView.frame.height - imageHeihgt) / 2 + 64
        }
        
        print(imageWidth, imageHeihgt)
        
//        let normalizedX = cropRect.origin.x / imageView.frame.width
//        let normalizedY = cropRect.origin.y / imageView.frame.height
//
//        let normalizedWidth = cropRect.width / imageView.frame.width
//        let normalizedHeight = cropRect.height / imageView.frame.height
        
        let normalizedX = cropRect.origin.x / imageView.frame.width
        let normalizedY = cropRect.origin.y / imageView.frame.height
        
        let normalizedWidth = cropRect.width / imageWidth
        let normalizedHeight = cropRect.height / imageHeihgt
        
        return CGRect(x: normalizedX, y: normalizedY, width: normalizedWidth, height: normalizedHeight)
    }
    
}

extension UIImage {
    func crop(rect: CGRect) -> UIImage {
        
        var rectTransform: CGAffineTransform
        switch imageOrientation {
        case .left:
            rectTransform = CGAffineTransform(rotationAngle: radians(90)).translatedBy(x: 0, y: -size.height)
        case .right:
            rectTransform = CGAffineTransform(rotationAngle: radians(-90)).translatedBy(x: -size.width, y: 0)
        case .down:
            rectTransform = CGAffineTransform(rotationAngle: radians(-180)).translatedBy(x: -size.width, y: -size.height)
        default:
            rectTransform = CGAffineTransform.identity
        }
        
        rectTransform = rectTransform.scaledBy(x: scale, y: scale)
        
        if let cropped = cgImage?.cropping(to: rect.applying(rectTransform)) {
            return UIImage(cgImage: cropped, scale: scale, orientation: imageOrientation).fixOrientation()
        }
        
        return self
    }
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
}

internal func radians(_ degrees: CGFloat) -> CGFloat {
    return degrees / 180 * .pi
}

