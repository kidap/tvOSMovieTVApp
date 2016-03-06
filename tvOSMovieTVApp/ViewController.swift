//
//  ViewController.swift
//  tvOSMovieTVApp
//
//  Created by Karlo Pagtakhan on 02/23/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

func fixJsonData2 (data: NSData) -> NSData {
  var dataString = String(data: data, encoding: NSUTF8StringEncoding)!
  dataString = dataString.stringByReplacingOccurrencesOfString("\\'", withString: "'")
  return dataString.dataUsingEncoding(NSUTF8StringEncoding)!
  
}

class ViewController: UIViewController {
  //MARK: Variables
  var movie : Movie?
  var imdbID: String?
  var appDelegate:AppDelegate?
  
  //MARK: Outlets
  @IBOutlet var posterImage: UIImageView!
  @IBOutlet var movieTitle: UILabel!
  @IBOutlet var movieYear: UILabel!
  @IBOutlet var movieActors: UILabel!
  @IBOutlet var moviePlot: UILabel!
  @IBOutlet var movieRating: UILabel!
  @IBOutlet var favoriteButton: UIButton!
  @IBOutlet var favoritesIcon: UIImageView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  
  //MARK: Methods/Messages
  func loading(status:Bool){
    if status{
      activityIndicator.startAnimating()
      self.view.alpha = 0.5
    } else{
      activityIndicator.stopAnimating()
      self.view.alpha = 1
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loading(true)
    
    //Hide Icon by default
    favoritesIcon.alpha = 0
    appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
    
    //Check if the movie is in the favorites, if yes, show favorite icon(star)
    if appDelegate!.dataController.isMovieInFavorites(imdbID!){
      favoriteButton.selected = true
    }
    
    favoriteButton.alpha = 0
    
    //Refresh labels
    self.movieTitle.text = ""
    self.movieYear.text = ""
    self.movieActors.text = ""
    self.moviePlot.text = ""
    self.movieRating.text = ""
    
    //Get the details on the movie using the IMDBID
    let str = "http://www.omdbapi.com/?i=" + imdbID! + "&y=&plot=full&r=json"
    let url = NSURL(string: str)
    let urlRequest = NSURLRequest(URL: url!)
    let urlSession = NSURLSession.sharedSession()
    
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
                
                //Initialize
                self.favoriteButton.alpha = 1
                self.loading(false)
                
                //Check is movie is in Favorites
                if self.appDelegate!.dataController.isMovieInFavorites(self.imdbID!){
                  self.favoritesIcon.alpha = 1
                } else {
                  self.favoritesIcon.alpha = 0
                }
                
                //Set labels
                self.movieTitle.text = jsonObject["Title"]!
                self.movieYear.text = jsonObject["Year"]!
                self.movieActors.text = "Cast: " + jsonObject["Actors"]!
                self.moviePlot.text = jsonObject["Plot"]!
                self.movieRating.text = jsonObject["imdbRating"]!
                
                //Format the rating
                if self.movieRating.text! != "N/A"{
                  let rating: Float = Float(self.movieRating.text!)!
                  
                  //Red for low rating
                  //Green for high rating
                  if  rating >= 7{
                    self.movieRating.textColor = UIColor.greenColor()
                  } else{
                    self.movieRating.textColor = UIColor.redColor()
                  }
                  //Append to /10
                  self.movieRating.text! += "/10"
                } else {
                  self.movieRating.text! = ""
                }
                
                //Download image
                let imageURL = NSURL(string: jsonObject["Poster"]!)
                let urlSession2 = NSURLSession.sharedSession()
                let urlRequest = NSURLRequest(URL: imageURL!)
                
                let task2 = urlSession2.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) -> Void in
                  NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    if error == nil{
                      if let imageData = data{
                        self.posterImage.image = UIImage(data: imageData)
                      }
                    }
                  })
                })
                task2.resume()
              }
            } catch {
              
            }
          }
        }
      })
    }
    
    task.resume()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func setToFavorite(sender: AnyObject) {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //If movie is already a favorite, delete it from the Favorites
    if appDelegate.dataController.isMovieInFavorites(self.imdbID!){
      appDelegate.dataController.deleteMovieInFavorites(self.imdbID!)
      favoritesIcon.alpha = 0
      
      //If movie is not yet favorited, save it in the Favorites
    } else {
      appDelegate.dataController.saveMovieInFavorites(self.imdbID!)
      //favoriteButton.selected = true
      favoritesIcon.alpha = 1
    }
    
  }
  
}

