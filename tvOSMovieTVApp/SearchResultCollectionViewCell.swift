//
//  SearchResultsCollectionViewCell.swift
//  tvOSMovieTVApp
//
//  Created by Karlo Pagtakhan on 02/27/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate{
  //MARK: Variables
  var videoCollection = [Movie]()
  var defaultTypeColor : UIColor?

  //MARK:Outlets
  @IBOutlet var headerText: UILabel!
  @IBOutlet var collectionView: UICollectionView!
  
  //MARK: Methods/Messages
  override var preferredFocusedView: UIView? {
    return collectionView
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return videoCollection.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("movieCell", forIndexPath: indexPath) as! MovieCollectionViewCell
    
    //Get Movie details
    cell.title.text = videoCollection[indexPath.row].title
    cell.type.text = videoCollection[indexPath.row].type
    
    if cell.type.text == "series"{
      cell.type.text = "tv"
    }
    
    cell.imdbID = videoCollection[indexPath.row].imdbID
    cell.imageLink = videoCollection[indexPath.row].posterURL
    
    
    //Get default color 
    if defaultTypeColor == nil{
      defaultTypeColor = cell.type.backgroundColor
    }
    
    //Set the color on the top of the poster
    if cell.type.text == "movie"{
      cell.type.backgroundColor = defaultTypeColor
    } else {
      cell.type.backgroundColor = UIColor.blackColor()
    }
    
    //Get Movie Poster
    let urlRequest = NSURLRequest(URL: NSURL(string: cell.imageLink )!)
    let urlSession = NSURLSession.sharedSession()
    cell.dataTask = urlSession.dataTaskWithRequest(urlRequest) { (data , response, error) -> Void in
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        if error == nil {
          if let imageData = data {
            cell.imageURL.image = UIImage(data: imageData)
          }
        }
        if cell.imageURL.image == nil {
          //Default Image
          cell.imageURL.image = UIImage(named: "noImage")
        }
      })
    }
    
    cell.dataTask!.resume()
    
    return cell
  }
}