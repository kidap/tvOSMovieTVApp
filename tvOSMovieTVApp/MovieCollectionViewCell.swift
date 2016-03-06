//
//  MovieCollectionViewCell.swift
//  tvOSMovieTVApp
//
//  Created by Karlo Pagtakhan on 02/25/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet var title: UILabel!
  @IBOutlet var imageURL: UIImageView!
  @IBOutlet var type: UILabel!
  
  var imdbID = ""
  var imageLink = ""
  var enableLabelToggle = true
  weak var dataTask: NSURLSessionDataTask?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    type.alpha = 1.0
    imageURL.image = nil
    
    
    if enableLabelToggle{
      title.alpha = 0.0
    } else {
      title.alpha = 1.0
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    type.alpha = 1.0
    
    if enableLabelToggle{
      title.alpha = 0.0
    } else {
      title.alpha = 1.0
    }
  }
  
  
  override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {

    coordinator.addCoordinatedAnimations({
      if self.focused {
        if self.enableLabelToggle{
          self.title.alpha = 1.0
          self.type.alpha = 0.0
          self.title.center.y += 40
        } else {
          self.title.center.y += 40
          self.title.alpha = 1.0
        }
      }
      else {
        if self.enableLabelToggle{
          self.title.alpha = 0.0
          self.type.alpha = 1.0
          self.title.center.y -= 40
        } else{
          self.title.center.y -= 40
          self.title.alpha = 1.0
        }
      }
      }, completion: nil)

  }
}
