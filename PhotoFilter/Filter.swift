//
//  Filter.swift
//  PhotoFilter
//
//  Created by Shiquan Fu on 10/14/14.
//  Copyright (c) 2014 Tina Fu. All rights reserved.
//

import Foundation
import CoreData

class Filter: NSManagedObject {
    // @NSManaged shows that these properties are coredata objects
    @NSManaged var favorited: NSNumber
    @NSManaged var name: String

}
