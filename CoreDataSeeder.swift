//
//  CoreDataSeeder.swift
//  PhotoFilter
//
//  Created by Shiquan Fu on 10/14/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import Foundation
import CoreData

class CoreDataSeeder {
    var managedObjectContext : NSManagedObjectContext!
    
    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
    }
    
    //insert object into coredata, this will be saved in the database.
    func seedCoreData() {
        
        //making a new NSmanagedobjectcontext in this syntax
        var sepia = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        sepia.name = "CISepiaTone"
        sepia.favorited = true
        
        var gaussianBlur = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        gaussianBlur.name = "CIGaussianBlur"
        gaussianBlur.favorited = true
        
        var pixellate = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        pixellate.name = "CIPixellate"
        pixellate.favorited = true
        
        var gammaAdjust = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        gammaAdjust.name = "CIGammaAdjust"
        gammaAdjust.favorited = true
        
        var exposureAdjust = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        exposureAdjust.name = "CIExposureAdjust"
        exposureAdjust.favorited = true
        
        var photoEffectChrome = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        photoEffectChrome.name = "CIPhotoEffectChrome"
        photoEffectChrome.favorited = true
        
        var photoEffectInstant = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        photoEffectInstant.name = "CIPhotoEffectInstant"
        photoEffectInstant.favorited = true
        
        var photoEffectMono = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        photoEffectMono.name = "CIPhotoEffectMono"
        photoEffectMono.favorited = true
        
        var photoEffectNoir = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        photoEffectNoir.name = "CIPhotoEffectNoir"
        photoEffectNoir.favorited = true
        
        var photoEffectTonal = NSEntityDescription.insertNewObjectForEntityForName("Filter", inManagedObjectContext: self.managedObjectContext) as Filter
        photoEffectTonal.name = "CIPhotoEffectTonal"
        photoEffectTonal.favorited = true
        
        
        
        
        
        //save the context, if error is nill then it's saved. &error here is passing an empty error, return a Boolean
        var error: NSError?
        self.managedObjectContext?.save(&error)
        
        if error != nil {
            println(error?.localizedDescription)
        }

        
        
    }
}
