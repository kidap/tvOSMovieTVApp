//
//  Favorites+CoreDataProperties.swift
//  tvOSMovieTVApp
//
//  Created by Karlo Pagtakhan on 03/02/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Favorites {

    @NSManaged var imdbID: String?
    @NSManaged var date: NSDate?

}
