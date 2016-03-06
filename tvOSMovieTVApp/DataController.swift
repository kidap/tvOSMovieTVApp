//
//  DataController.swift
//  tvOSMovieTVApp
//
//  Created by Karlo Pagtakhan on 02/29/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import Foundation
import CoreData


class DataController{
  let managedObjectContext: NSManagedObjectContext
  var reloadData = true
  
  init(moc:NSManagedObjectContext){
      self.managedObjectContext = moc
  }
  
  
  convenience init?(){
    
    guard let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd") else{
      return nil
    }
    
    guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else{
      return nil
    }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
    let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    moc.persistentStoreCoordinator = psc
    
    let url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    let persistentStoreFileURL = url[0].URLByAppendingPathComponent("Bookmarks.sqlite")
    
    do{
      try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: persistentStoreFileURL, options: nil)
    } catch{
      fatalError("Error adding store")
    }
    
    self.init(moc:moc)
    
  }
  
  func saveMovieInRecent(imdbID:String){
    var savedMovie: Recent
    
    //Create entity and populate properties
    savedMovie = NSEntityDescription.insertNewObjectForEntityForName("Recent", inManagedObjectContext: self.managedObjectContext) as! Recent
    savedMovie.imdbID = imdbID
    
    //Save changes
    do{
      try self.managedObjectContext.save()
    } catch{
    }
  
  }
  
  func getRecentMovies()->[Recent]{
    //Initialize
    var recent:[Recent] = []
    let moc = self.managedObjectContext
    
    //Get Recent Entity
    let request = NSFetchRequest(entityName: "Recent")
    
    //Execute Fetch Request
    do{
      recent =  try moc.executeFetchRequest(request) as! [Recent]
    } catch{
    }
    
    return recent
  }
  
  func saveMovieInFavorites(imdbID:String){
    let favorite = NSEntityDescription.insertNewObjectForEntityForName("Favorites", inManagedObjectContext: self.managedObjectContext) as! Favorites
    
    //Set properties
    favorite.imdbID = imdbID
    favorite.date = NSDate()
    
    //Save changes
    do{
      try managedObjectContext.save()
      
      reloadData = true
    } catch{
    }
  }
  
  func deleteMovieInFavorites(imdbID:String){
    //Initialize variable
    var retrievedFavorites:[Favorites] = []
    
    //For Predicate
    //let attributeName  = "imdbID";
    let attributeValue = imdbID;
    
    //Build predicate and request
    let predicate = NSPredicate(format: "imdbID = %@", attributeValue)
    let request = NSFetchRequest(entityName: "Favorites")
    request.predicate = predicate
    
    //Get the data from Core Date
    do{
      //Get objects
      retrievedFavorites = try managedObjectContext.executeFetchRequest(request) as! [Favorites]
      
      // Delete all objects that match
      for favorite in retrievedFavorites{
        managedObjectContext.deleteObject(favorite)
      }
      
      //Save changes
      try managedObjectContext.save()
      
      reloadData = true

    } catch{
      
    }
    
  }
  
  func isMovieInFavorites(imdbID:String)->Bool{
    //Initialize variable
    var retrievedFavorites:[Favorites] = []
    
    //For Predicate
    //let attributeName  = "imdbID";
    let attributeValue = imdbID;
    
    //Build predicate and request
    let predicate = NSPredicate(format: "imdbID = %@", attributeValue)
    let request = NSFetchRequest(entityName: "Favorites")
    request.predicate = predicate
    
    //Get the data from Core Date
    do{
      //Get objects
      retrievedFavorites = try managedObjectContext.executeFetchRequest(request) as! [Favorites]
      
      // Delete all objects that match
      if retrievedFavorites.count  > 0{
        return true
      } else{
        return false
      }
      
    } catch{
      return false
    }
    
  }
  
  func getFavoriteMovies()->[Favorites]{
    //Initialize
    var retrievedFavorites:[Favorites] = []
    
    //Get Favorites Entity
    let request = NSFetchRequest(entityName: "Favorites")
    
    //Get data from Core Data
    do{
      retrievedFavorites = try managedObjectContext.executeFetchRequest(request) as! [Favorites]
      
    } catch {
    }
    
    return retrievedFavorites
    
  }
  
  
  
}