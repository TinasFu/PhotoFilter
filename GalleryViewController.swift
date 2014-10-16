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
    
    //delegate property should always be week
    
    weak var delegate: GalleryDelegate?
    
    var images = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
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
