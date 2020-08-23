//
//  MemeDetailViewController.swift
//  MemeMe 2.0
//
//  Created by Ghada Faisal on 16/06/2020.
//  Copyright © 2020 GhadaFaisal. All rights reserved.

import Foundation
import UIKit
class MemeDetailViewController: UIViewController {


      var memePicked: Meme!
      
      // MARK: Outlets
      
      @IBOutlet weak var imageView: UIImageView!

      
      // MARK: Life Cycle
      
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
        
          self.tabBarController?.tabBar.isHidden = true
          
          self.imageView!.image = memePicked.memedImage
      }
      
      override func viewWillDisappear(_ animated: Bool) {
          super.viewWillDisappear(animated)
          self.tabBarController?.tabBar.isHidden = false
      }
    

}



