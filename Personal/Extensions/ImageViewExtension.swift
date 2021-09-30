//
//  ImageViewExtension.swift
//  Personal
//
//  Created by 으정이 on 2021/09/29.
//

import UIKit
import AlamofireImage
import Foundation

@IBDesignable
public class RoundedBorderView: UIView {
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
}

private struct ImageSupport {
    static let backingBundle = Bundle(for: RoundedBorderView.self)
    static let noImage: UIImage = UIImage(named: "unknown", in: backingBundle, compatibleWith: nil)!
}

extension UIImageView {
    func loadImageWithURL(_ url: URL?,
                          cacheKey: String? = nil,
                          filter: ImageFilter? = nil) {
        guard let _url = url else {
            self.image = UIImage.getPlaceholder(size: self.bounds.size)
            return
        }
//        self.af.setImage(withURL: _url, cacheKey: cacheKey, placeholderImage: UIImage.getPlaceholder(size: self.bounds.size), serializer: nil, filter: filter, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: nil)
        
        self.af.setImage(withURL: _url, cacheKey: cacheKey, placeholderImage: UIImage.getPlaceholder(size: self.bounds.size), serializer: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false) { image in
            Logger.d("이미지 다 받아짐")
            
        }
    }
    
    func loadImageWithURLString(_ urlString: String, cacheKey: String? = nil, filter: ImageFilter? = nil) {
        
        guard let url = URL(string: urlString) else {
            self.image = UIImage.getPlaceholder(size: self.bounds.size)
            return
        }
        
        self.loadImageWithURL(url, cacheKey: cacheKey, filter: filter)
        
    }
}

extension UIImage {
    static func getPlaceholder(size: CGSize) -> UIImage {
        //사이즈별로 다른 place holder를 분기할 수 있다.
        return ImageSupport.noImage
    }
    func resizeImageByKeepingAspectRatio(_ source: UIImage, toWidth: CGFloat) -> UIImage? {
        let oldWidth = source.size.width;
        let scaleFactor = toWidth / oldWidth;
        let newHeight = source.size.height * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
