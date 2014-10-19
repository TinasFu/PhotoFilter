//
//  GalleryViewController.swift
//  PhotoFilter
//
//  Created by Shiquan Fu on 10/13/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import UIKit

protocol GalleryDelegate : class {
    func didTapOnPicture(image : UIImage)
}


class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    // define a flowlayout object for Gallery View
    var flowlayout : UICollectionViewFlowLayout!
    
    var originalItemWidth : CGFloat?
    var originalItemHeight : CGFloat?
    
    //delegate property should always be weak
    weak var delegate: GalleryDelegate?
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the current collectionview layout to flowlayout
        self.flowlayout = self.collectionView.collectionViewLayout as UICollectionViewFlowLayout
        //define a guesture recognizer "pinch" when this guesture happens, trigger the function "pinchAction"
        // the ":" in "pinchAction:" will trigger the function "pinchAction"
        self.originalItemWidth = flowlayout.itemSize.width
        self.originalItemHeight = flowlayout.itemSize.height
        //var pinch = UIPinchGestureRecognizer(target:self, action: "pinchAction:")
        var pinch = UIPinchGestureRecognizer(target: self, action: "pinchAction:")
        self.collectionView.addGestureRecognizer(pinch)
        
        
        var image1 = UIImage(named: "photo2.jpg")
        var image2 = UIImage(named: "photo3.jpg")
        var image3 = UIImage(named: "photo4.jpg")
        var image4 = UIImage(named: "photo5.jpg")
        
        self.images.append(image1)
        self.images.append(image2)
        self.images.append(image3)
        self.images.append(image4)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        

        // Do any additional setup after loading the view.
    }
    
    // Action after Pinch
    func pinchAction(pinch : UIPinchGestureRecognizer) {
        println("hello")
        if pinch.state == UIGestureRecognizerState.Ended {
            println("ended")
            println(pinch.velocity)
            self.collectionView.performBatchUpdates({ () -> Void in
                if pinch.velocity > 0 && self.flowlayout.itemSize.width < self.originalItemWidth! * 4 {
                    self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 2, height: self.flowlayout.itemSize.height * 2)
                } else if pinch.velocity < 0 && self.flowlayout.itemSize.width > self.originalItemWidth! * 0.25 {
                    self.flowlayout.itemSize = CGSize(width: self.flowlayout.itemSize.width * 0.5, height: self.flowlayout.itemSize.height * 0.5)
                }
                }, completion: nil )
        }
        
    }

    
    
    //implementation of the protocol to assign image to Gallery Cell
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GALLERY_CELL", forIndexPath: indexPath) as GalleryCell
        cell.imageView.image = self.images[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.didTapOnPicture(self.images[indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView!
        if(kind == UICollectionElementKindSectionHeader){
            let headerView : HeaderCell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as HeaderCell
            let title = "Choose a Photo From Gallery"
            headerView.headerLabelView.text = title
            reusableView = headerView
            
        } else{
            let footerView : FooterCell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterView", forIndexPath: indexPath) as FooterCell
            let title = "Gallery"
            footerView.footerLabelView.text = title
            reusableView = footerView
            
        }
        return reusableView
    }
    
    
}
