//
//  Movie.swift
//  tvOSMovieTVApp
//
//  Created by Karlo Pagtakhan on 02/24/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class Movie: NSObject {
  
  var title = ""
  var year = ""
  var actors = ""
  var plot = ""
  var posterURL = ""
  var imdbID = ""
  var type = ""
  var genre = ""
  
  
  init(title:String, posterURL:String, imdbID:String, type:String, year:String, actors:String, plot:String){
    self.title  = title
    self.year  = year
    self.actors  = actors
    self.plot  = plot
    self.posterURL  = posterURL
  }
  
  init(title:String, posterURL:String, imdbID:String, type:String) {
    self.title     = title
    self.posterURL = posterURL
    self.imdbID = imdbID
    self.type = type
  }
  

}
