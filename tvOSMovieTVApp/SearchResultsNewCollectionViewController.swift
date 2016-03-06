//
//  SearchResultsNewCollectionViewController.swift
//  tvOSMovieTVApp
//
//  Created by Karlo Pagtakhan on 02/27/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class SearchResultsNewCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  //MARK: Variables
  var collections : [(name:String,result:[Movie])] = []
  var searchString = ""
  
  //MARK: Outlets
  @IBOutlet var collectionView: UICollectionView!
  
  //Methods/Messages
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  // MARK: - Navigation
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collections.count
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("searchResultsCell", forIndexPath: indexPath) as? SearchResultCollectionViewCell
    
    cell?.videoCollection = collections[indexPath.row].result
    cell?.headerText.text = collections[indexPath.row].name
    
    return cell!
  }
  
  //Defer focus to the nested collection view
  func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if segue.identifier == "goToMovieDetailView"{
      let targetViewController = segue.destinationViewController as? ViewController
      
      if let focusedCell = UIScreen.mainScreen().focusedView as? MovieCollectionViewCell{
        //Pass the variables to the next view
        targetViewController!.imdbID = focusedCell.imdbID
        
      }
      
    }
  }
}
