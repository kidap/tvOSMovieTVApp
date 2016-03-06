//
//  MainViewController.swift
//  tvOSMovieTVApp
//
//  Created by Karlo Pagtakhan on 02/25/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit
import CoreData

func fixJsonData (data: NSData) -> NSData {
  var dataString = String(data: data, encoding: NSUTF8StringEncoding)!
  dataString = dataString.stringByReplacingOccurrencesOfString("\\'", withString: "'")
  return dataString.dataUsingEncoding(NSUTF8StringEncoding)!
  
}

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  //MARK: Variables
  var searchResultsMovie = [Movie]()
  var searchResultsSeries = [Movie]()
  var task1: NSURLSessionDataTask?
  var task2: NSURLSessionDataTask?
  var task3: NSURLSessionDataTask?
  var topCollectionOfMoviess:[Favorites]!
  
  //MARK: Outlets
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var inputSearchString: UITextField!
  @IBOutlet var errorMessage: UILabel!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  
  
  override func viewDidLoad() {
    // Do any additional setup after loading the view.
    super.viewDidLoad()
    
    topCollectionOfMoviess = []
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    topCollectionOfMoviess = appDelegate.dataController.getFavoriteMovies()
    collectionView.reloadData()
    
  }
  
  //MARK: Methods/Messages
  
  func loading(status:Bool){
    if status{
      activityIndicator.startAnimating()
      self.view.userInteractionEnabled = false
      self.view.alpha = 0.5
    } else{
      activityIndicator.stopAnimating()
      self.view.userInteractionEnabled = true
      self.view.alpha = 1
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    goToSearchCtr = 0
    loading(false)
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    if appDelegate.dataController.reloadData == true{
      topCollectionOfMoviess = appDelegate.dataController.getFavoriteMovies()
      collectionView.reloadData()
      appDelegate.dataController.reloadData = false
    }
    
  }
  
  override func didReceiveMemoryWarning() {
    // Dispose of any resources that can be recreated.
    super.didReceiveMemoryWarning()
  }
  
  
  // Clear error message text once the user tries to enter a new search
  @IBAction func inputEnded(sender: AnyObject) {
    errorMessage.text = ""
    goToSearchCtr = 0
  }
  
  var goToSearchCtr: Int = 0{
    didSet{
      if goToSearchCtr == 3 && (searchResultsMovie.count != 0 || searchResultsSeries.count != 0){
        loading(false)
        self.performSegueWithIdentifier("toNewSearchResults", sender: self)
        goToSearchCtr = 0
        task1?.cancel()
        task2?.cancel()
        task3?.cancel()
      }
    }
  }
  
  //MARK: Button pressed
  
  @IBAction func searchForMovies(sender: AnyObject) {
    task1?.cancel()
    task2?.cancel()
    task3?.cancel()
    
    loading(true)
    
    
    if inputSearchString.text != nil {
      var searchString = inputSearchString.text
      
      //Refresh results
      searchResultsMovie = [Movie]()
      searchResultsSeries = [Movie]()
      
      //Build search string
      searchString = searchString!.stringByReplacingOccurrencesOfString(" ", withString: "+")
      
      //Download JSON data -- MOVIE #page 1
      var url = "http://www.omdbapi.com/?s=" + searchString! + "&y=&plot=full&r=json&page=1&type=movie"
      var urlRequest = NSURLRequest(URL: NSURL(string: url)!)
      task1 = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: { (data , response, error ) -> Void in
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          
          if error == nil{
            if let dataReceived = data {
              do{
                let jsonData =  try NSJSONSerialization.JSONObjectWithData(dataReceived, options: NSJSONReadingOptions(rawValue: 0))
                
                if let localSearchResults = jsonData["Search"] as? [Dictionary<String, String>]{
                  for searchResult in localSearchResults{
                    //Append the movie to the Movie object
                    self.searchResultsMovie.append(Movie(title: searchResult["Title"]!, posterURL: searchResult["Poster"]!, imdbID:searchResult["imdbID"]!, type:searchResult["Type"]!))
                    
                  }
                  
                  self.task2!.resume()
                  
                } else if let error = jsonData["Error"] as? String {
                  if error == "Movie not found!"{
                    self.errorMessage.text = "Movie or TV show not found!"
                  } else {
                    self.errorMessage.text = error
                  }
                }
                
              } catch{
                
              }
            }
          } else {
            //self.errorMessage.text = error!
            self.errorMessage.text = "The Internet connection appears to be offline."
            print(error!)
          }
          
          self.goToSearchCtr += 1
          
        })
      })
      //Download JSON data -- MOVIE #page 2
      url = "http://www.omdbapi.com/?s=" + searchString! + "&y=&plot=full&r=json&page=2&type=movie"
      urlRequest = NSURLRequest(URL: NSURL(string: url)!)
      task2 = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: { (data , response, error ) -> Void in
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          
          if error == nil{
            if let dataReceived = data {
              do{
                let jsonData =  try NSJSONSerialization.JSONObjectWithData(dataReceived, options: NSJSONReadingOptions(rawValue: 0))
                
                if let localSearchResults = jsonData["Search"] as? [Dictionary<String, String>]{
                  for searchResult in localSearchResults{
                    
                    //Append the movie to the Movie object
                    self.searchResultsMovie.append(Movie(title: searchResult["Title"]!, posterURL: searchResult["Poster"]!, imdbID:searchResult["imdbID"]!, type:searchResult["Type"]!))
                  }
                }
              } catch{
              }
            }
          }
          self.goToSearchCtr += 1
        })
      })
      //Download JSON data -- SERIES  #page 1
      url = "http://www.omdbapi.com/?s=" + searchString! + "&y=&plot=full&r=json&page=2&type=series"
      urlRequest = NSURLRequest(URL: NSURL(string: url)!)
      task3 = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: { (data , response, error ) -> Void in
        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
          
          if error == nil{
            if let dataReceived = data {
              do{
                let jsonData =  try NSJSONSerialization.JSONObjectWithData(dataReceived, options: NSJSONReadingOptions(rawValue: 0))
                
                if let localSearchResults = jsonData["Search"] as? [Dictionary<String, String>]{
                  for searchResult in localSearchResults{
                    
                    //Append the movie to the Movie object
                    self.searchResultsSeries.append(Movie(title: searchResult["Title"]!, posterURL: searchResult["Poster"]!, imdbID:searchResult["imdbID"]!, type:searchResult["Type"]!))
                  }
                  
                }
                
              } catch{
                
              }
            }
          }
          self.goToSearchCtr += 1
        })
      })
      
      task1!.resume()
      task3!.resume()
    }
    
  }
  
  @IBAction func findMovie(sender: AnyObject) {
    
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    if segue.identifier == "toSearchResults"{
      let targetView = segue.destinationViewController as! SearchResultsCollectionViewController
      //Pass the variables to the next view
      
      //Movies
      targetView.movieWithPosters = self.searchResultsMovie
      
      //TV Series
      targetView.seriesWithPosters = self.searchResultsSeries
      
      //Search string
      targetView.searchString = inputSearchString.text!
      
    } else if segue.identifier == "toNewSearchResults"{
      let targetView = segue.destinationViewController as! SearchResultsNewCollectionViewController
      
      //Movies
      targetView.searchString = inputSearchString.text!
      if self.searchResultsMovie.count != 0{
        targetView.collections.append((name:"Movies", result: self.searchResultsMovie))
      }
      
      //TV Series
      if self.searchResultsSeries.count != 0{
        targetView.collections.append((name:"TV Series", result: self.searchResultsSeries))
      }
    }
    if segue.identifier == "goToMovieDetailView"{
      let targetViewController = segue.destinationViewController as? ViewController
      
      //Get the focused cell and pass the IMDB ID
      if let focusedCell = UIScreen.mainScreen().focusedView as? MovieCollectionViewCell{
        //Pass the variables to the next view
        targetViewController!.imdbID = focusedCell.imdbID
        
      }
      
    }
  }
  
  //MARK: Collection view at the top of the screen
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return topCollectionOfMoviess.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("movieCell", forIndexPath: indexPath) as! MovieCollectionViewCell
    var movieCell: Movie?
    
    //Get the details on the movie using the IMDBID
    let str = "http://www.omdbapi.com/?i=" + topCollectionOfMoviess[indexPath.row].imdbID! + "&y=&plot=full&r=json"
    let url = NSURL(string: str)
    let urlRequest = NSURLRequest(URL: url!)
    let urlSession = NSURLSession.sharedSession()
    
    //Set the cell's imdbID
    cell.imdbID = topCollectionOfMoviess[indexPath.row].imdbID!
    cell.enableLabelToggle = false
    
    let task = urlSession.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
      NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
        if error == nil{
          if let jsonData = data{
            
            let fixedJson = fixJsonData(jsonData)
            var jsonObject: Dictionary<String, String>
            
            do{
              jsonObject = try NSJSONSerialization.JSONObjectWithData(fixedJson, options: NSJSONReadingOptions(rawValue: 0)) as! Dictionary<String, String>
              
              // Check if there is a valid response
              if jsonObject["Response"] != "False"{
                movieCell = Movie(title: jsonObject["Title"]!, posterURL: jsonObject["Poster"]!, imdbID: jsonObject["imdbID"]!, type: jsonObject["Type"]!, year: jsonObject["Year"]!, actors: jsonObject["Actors"]!, plot: jsonObject["Plot"]!)
                
                cell.title.text = jsonObject["Title"]!
                cell.type.text = jsonObject["Type"]!
                
                if cell.type.text == "series"{
                  cell.type.text = "Favorite tv"
                } else {
                  cell.type.text = "Favorite movie"
                }
                
                cell.title.alpha = 1
                
                //Download image
                let imageURL = NSURL(string: jsonObject["Poster"]!)
                let urlSession2 = NSURLSession.sharedSession()
                let urlRequest = NSURLRequest(URL: imageURL!)
                
                let task2 = urlSession2.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) -> Void in
                  NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if error == nil{
                      if let imageData = data{
                        cell.imageURL.image = UIImage(data: imageData)
                      } else{ //Default image
                        cell.imageURL.image = UIImage(named: "noImage")
                      }
                      
                    } else {
                      cell.imageURL.image = UIImage(named: "noImage")
                    }
                  })
                })
                task2.resume()
              }
            } catch {
              
            }
          }
        } else {
          //If there is an error while getting the data from the internet, hide the entire collection view
          collectionView.alpha = 0
        }
      })
    }
    
    task.resume()
    
    
    return cell
  }
  
}
