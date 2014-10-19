//
//  ViewController.swift
//  PhotoFilter
//
//  Created by Shiquan Fu on 10/13/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import UIKit
import CoreImage
import CoreData //give access to all coredata claases
import OpenGLES
import Photos
import Social



class ViewController: UIViewController,UICollectionViewDelegate, GalleryDelegate, PhotoFrameworkDelegate, AVFoundationCameraDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {
    
    
    //properties
    @IBOutlet weak var imageView: UIImageView!
    
    //add constraint outlet from storyboard so later in enterFilterMode we can modify the constraint to show the filter collection view
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var savePhotoButton: UIButton!
    
    @IBOutlet weak var postToTwitterButton: UIButton!
    var context : CIContext?
    var originalThumbnail : UIImage?
    var filter : CIFilter?
    
    var originalImageView : UIImage?
    var seeder : CoreDataSeeder?
    //core data array
    var filters = [Filter]()
    //array of thumbnail wrapper objects
    var filterThumbnails = [FilterThumbnail]()
    
    //create a queue for a background thread
    let imageQueue = NSOperationQueue()
    var managedObjectContext : NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //use GPU
        //creat a dictionary, setting up our core image context
        self.generateThumbnail()
        var options = [kCIContextWorkingColorSpace : NSNull()]
        var myEAGLContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        self.context = CIContext(EAGLContext: myEAGLContext, options: options)
        
        // we want to use the core data context from the AppDelegate
        // Need context to manage the data. it's the main layer in the coredata stack
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext
        
        seeder = CoreDataSeeder(context: appDelegate.managedObjectContext!)
        //seeder.seedCoreData()
        
        self.fetchFilters()
        self.resetFilterThumbnails()
        
        var image = UIImage(named: "photo2.jpg")
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    //generate new thumbnail with size 100x100
    func generateThumbnail () {
        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)
        self.imageView.image?.drawInRect(CGRect(x:0, y:0, width:100, height:100))
        self.originalThumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SHOW_GALLERY" {
            let destinationVC = segue.destinationViewController as GalleryViewController
            destinationVC.delegate = self
        }
        else if segue.identifier == "SHOW_PHOTO_FRAMEWORK" {
            let destinationVC = segue.destinationViewController as PhotoFrameworkViewController
            destinationVC.delegate = self
        }
        else if segue.identifier == "SHOW_AVFOUNDATION_CAMERA" {
            let destinationVC = segue.destinationViewController as AVFoundationCameraViewController
            destinationVC.delegate = self
        }
    }
    
    // when enter filter mode, change some of the constraint for imageView and collectionView to shrink the image and show the collection view.
    func enterFilterMode(){        
        self.imageViewTrailingConstraint.constant = self.imageViewTrailingConstraint.constant * 3
        self.imageViewLeadingConstraint.constant = self.imageViewLeadingConstraint.constant * 3
        self.imageViewBottomConstraint.constant = self.imageViewBottomConstraint.constant * 3
        self.collectionViewBottomConstraint.constant = 100
        
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
        // set the "done" button
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "exitFilteringMode")
        self.navigationItem.rightBarButtonItem = doneButton
        
        self.savePhotoButton.hidden = true
        self.postToTwitterButton.hidden = true
    }
    
    func exitFilteringMode () {
        
        //reset the contraints back to normal values
        self.imageViewTrailingConstraint.constant = self.imageViewTrailingConstraint.constant / 3
        self.imageViewLeadingConstraint.constant = self.imageViewLeadingConstraint.constant / 3
        self.imageViewBottomConstraint.constant = self.imageViewBottomConstraint.constant / 3
        self.collectionViewBottomConstraint.constant = -100
        //remove the Done button
        self.navigationItem.rightBarButtonItem = nil
        self.savePhotoButton.hidden = false
        self.postToTwitterButton.hidden = false
    }
    
    
    @IBAction func savePhotoPressed(sender: AnyObject) {
        // save filtered picture to photo library
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            let item = PHAssetChangeRequest.creationRequestForAssetFromImage(self.imageView.image)
            }, completionHandler: nil)
        
    }
    
    
    
    // Post image to Twitter
    @IBAction func postToTwitterPressed(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            var tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            tweetSheet.setInitialText("Look at this nice picture!")
            tweetSheet.addImage(imageView.image)
            
            
            self.presentViewController(tweetSheet, animated: true, completion: nil)
        } else {
            
            println("error")
        }

    }
    
    //Alert Controller.
    @IBAction func photoPressed(sender: AnyObject) {
        
        let alertController = UIAlertController(title: nil, message: "Choose an option", preferredStyle: UIAlertControllerStyle.ActionSheet)
        //let a = UIAlertAction(title: String, style: UIAlertActionStyle, handler: { (UIAlertAction!) -> Void in
    //    code
    //})
        // add Gallery action button
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default) { (action) -> Void in
            //segue to our gallery
            self.performSegueWithIdentifier("SHOW_GALLERY", sender: self)
        }
        
        
        
        // add Cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            
        }
        
        let photoFrameworkAction = UIAlertAction(title: "Photo Framework", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier("SHOW_PHOTO_FRAMEWORK", sender: self)
        }
        
        let avFoundationCameraAction = UIAlertAction(title: "AVFoundation Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.performSegueWithIdentifier("SHOW_AVFOUNDATION_CAMERA", sender: self)
        }
        
        // add Camera action button
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            } else {
                imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            }
            
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        //add Filter action button
        let filterAction = UIAlertAction(title: "Filters", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.enterFilterMode()
        }
        
        // add action to alert controller
        alertController.addAction(galleryAction)
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoFrameworkAction)
        alertController.addAction(avFoundationCameraAction)
        alertController.addAction(filterAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        self.imageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.originalImageView = self.imageView.image
        self.generateThumbnail()
        self.resetFilterThumbnails()
        self.collectionView.reloadData()
        //didTapOnPicture(self.imageView.image!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func didTapOnPicture(image: UIImage) {
        print("Did tap on picture")
        self.imageView.image = image
        //self.originalImageView = self.imageView.image
        self.originalImageView = image
        self.generateThumbnail()
        self.resetFilterThumbnails()
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }
    

    // in the filter thumbnail collection, show each filter thumbnail in the filter cell. 
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FILTER_CELL", forIndexPath: indexPath) as FilterThumbnailCell
        var filterThumbnail = self.filterThumbnails[indexPath.row]
        //lazing loading
        if filterThumbnail.filteredThumbnail != nil {
            cell.imageView.image = filterThumbnail.filteredThumbnail
        } else {
            cell.imageView.image = filterThumbnail.originalThumbnail
            filterThumbnail.generateThumbnail({ (image: UIImage) -> Void in
                
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? FilterThumbnailCell {
                    cell.imageView.image = image
                }
            })
        }
        return cell
    }
    
    
    // When select a filter, apply the filter to the image and show the effect in the imageView. Keep a local reference to the original image and every time when apply another filter, will apply the new filter to the original imageView picture instead of the filtered image. then update the imageView with the new filtered imgage.
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var filter = self.filterThumbnails[indexPath.row].filter
        filter!.setDefaults()
        var image = CIImage(image: self.originalImageView)
        filter!.setValue(image, forKey: kCIInputImageKey)
        var result = filter!.valueForKey(kCIOutputImageKey) as CIImage
        var extent = result.extent()
        var imageRef = self.context?.createCGImage(result, fromRect: extent)
        self.imageView.image = UIImage(CGImage: imageRef)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func fetchFilters() {

        var fetchRequest = NSFetchRequest(entityName: "Filter")
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        var context = appDelegate.managedObjectContext
        
        // return an array of filter objects
        var error: NSError?
        
        // the variables inside of fetchResults() are captured
        
        // ??????????Question???????????????? can't ruturn res in one line
        
        // let res = context?.executeFetchRequest(fetchRequest, error: &error) as [Filter]
        
        func fetchResults() -> [Filter]? {
            let res = context?.executeFetchRequest(fetchRequest, error: &error)
            return res as? [Filter]
        }
        
        // if the fetchREsults() has value then unwrap and assign it to filters
        // if filter is empty seed the coredata and try fo fetch filter again
        
        if let filters = fetchResults() {
            if filters.isEmpty {
                self.seeder?.seedCoreData()
                if let filters2 = fetchResults() {
                    self.filters = filters2
                }
            }else {
                self.filters = filters
            }
            println("filters: \(self.filters.count)")

        }
    }
    
    //loop through the filters and generate filtered thumbnails
    func resetFilterThumbnails() {
        var newFilters = [FilterThumbnail]()
        for var index = 0; index < self.filters.count; ++index {
            var filter = self.filters[index]
            var filterName = filter.name
            var thumbnail = FilterThumbnail(name: filterName, thumbnail: self.originalThumbnail!, queue: self.imageQueue, context: self.context!)
            newFilters.append(thumbnail)
        }
        
        self.filterThumbnails = newFilters
        
    }
    

    
    

    
    
    
}

