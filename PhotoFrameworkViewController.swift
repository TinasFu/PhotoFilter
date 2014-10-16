//
//  PhotoFrameworkViewController.swift
//  PhotoFilter
//
//  Created by Shiquan Fu on 10/15/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import UIKit
import Photos

protocol PhotoFrameworkDelegate : class {
    func didTapOnPicture(image : UIImage)
}

class PhotoFrameworkViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var assetFetchResults: PHFetchResult!
    var assetCollection: PHAssetCollection!
    var imageManager: PHCachingImageManager!
    var assetCellSize: CGSize!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate : PhotoFrameworkDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //THIS IS THE START OF NEW STUFF WE LEARNED ON DAY 3
        
        // Get image image, asset fetch results
        self.imageManager = PHCachingImageManager()
        
        // Pass nil, fetch all assets
        self.assetFetchResults = PHAsset.fetchAssetsWithOptions(nil)
        
        // Determine device scale, adjust asset cell size
        var scale = UIScreen.mainScreen().scale
        var flowLayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        
        var cellSize = flowLayout.itemSize
        self.assetCellSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale)

        
        

        // Do any additional setup after loading the view.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assetFetchResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PHOTO_CELL", forIndexPath: indexPath) as PhotoFrameworkCell
        
        var currentTag = cell.tag + 1
        cell.tag = currentTag
        
        var asset = self.assetFetchResults[indexPath.row] as PHAsset
        
        self.imageManager.requestImageForAsset(asset, targetSize: self.assetCellSize, contentMode: PHImageContentMode.AspectFill, options: nil) { (image, info) -> Void in
            
            if cell.tag == currentTag {
                cell.imageView.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
       
        var newImage : UIImage?
        var asset = self.assetFetchResults[indexPath.row] as PHAsset
        
        // Here we use another api to get the raw NSData of the image we tapped on so we can make an UIImage from the NSData which doesn't shrink the size of the image. Otherwise if we use requestImageForAsset, the image size will be shrinked
        self.imageManager.requestImageDataForAsset(asset, options: nil) { (data, string, orientation, info) -> Void in
            
            newImage = UIImage(data: data)
            self.delegate?.didTapOnPicture(newImage!)
            self.dismissViewControllerAnimated(true, completion: nil)

        }
        
    }

    
    

}
