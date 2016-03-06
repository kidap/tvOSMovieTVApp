//
//  SearchResultsCollectionViewController.swift
//  tvOSMovieTVApp
//
//  Created by Karlo Pagtakhan on 02/25/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

private let reuseIdentifier = "movieCell"

class SearchResultsCollectionViewController: UICollectionViewController {
  var movieWithPosters  = [Movie]()
  var seriesWithPosters = [Movie]()
  var searchString = ""
  var defaultTypeColor : UIColor?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Section Header
    searchString = "results for " + searchString
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if segue.identifier == "goToMovieDetailView"{
      let targetViewController = segue.destinationViewController as? ViewController
      if let cell = sender as? MovieCollectionViewCell{
        //Pass the variables to the next view
        targetViewController!.imdbID = cell.imdbID
      }
      
    }
  }
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 2
  }
  
  
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    if section == 0 {
      return movieWithPosters.count
    } else{
      return seriesWithPosters.count
    }
  }
  
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> MovieCollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MovieCollectionViewCell
    
    if indexPath.section == 0{
      //Get Movie title
      cell.title.text = movieWithPosters[indexPath.row].title
      cell.type.text = movieWithPosters[indexPath.row].type
      cell.imdbID = movieWithPosters[indexPath.row].imdbID
      cell.imageLink = movieWithPosters[indexPath.row].posterURL
    } else {
      //Get Movie title
      cell.title.text = seriesWithPosters[indexPath.row].title
      cell.type.text = seriesWithPosters[indexPath.row].type
      cell.imdbID = seriesWithPosters[indexPath.row].imdbID
      cell.imageLink = seriesWithPosters[indexPath.row].posterURL
    }
    
    
    //Get default color
    if defaultTypeColor == nil{
      defaultTypeColor = cell.type.backgroundColor
    }
    
    
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
  
  override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> HeaderCollectionReusableView {
    var reusableview: HeaderCollectionReusableView? = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
      let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath) as? HeaderCollectionReusableView
      //Add a Section header
      if indexPath.section == 0{
        headerView?.titleText.text = "Movies";
      } else {
        headerView?.titleText.text = "TV Series";
      }
      reusableview = headerView;
    }
    
    return reusableview!;
  }
  
  //Cancel the data task after the cell has been displayed
  override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    if let movieCollectionViewCell = cell as? MovieCollectionViewCell{
      if let dataTask = movieCollectionViewCell.dataTask{
        dataTask.cancel()
      }
    }
    
  }
  
  
  // MARK: UICollectionViewDelegate
  
  
  /*
  // Uncomment this method to specify if the specified item should be highlighted during tracking
  override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
  return true
  }
  */
  
  /*
  // Uncomment this method to specify if the specified item should be selected
  override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
  return true
  }
  */
  
  /*
  // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
  override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
  return false
  }
  
  override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
  return false
  }
  
  override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
  
  }
  */
  
}
