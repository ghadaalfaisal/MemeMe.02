//
//  MemeTableViewController.swift
//  MemeMe 2.0
//
//  Created by Ghada Faisal on 16/06/2020.
//  Copyright © 2020 GhadaFaisal. All rights reserved.
//

import UIKit
import Foundation
class MemeTableViewController: UITableViewController {
    
    var meme: Meme!
      var memes: [Meme]! {
          let object = UIApplication.shared.delegate
          let appDelegate = object as! AppDelegate
          return appDelegate.memes
      }
    

    override func viewDidLoad() {
        super.viewDidLoad()}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

         tableView.reloadData()
    }

     

    
   // method 1 
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memes.count
    }
    
    
    //method 2
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")!
         let meme = self.memes[(indexPath as NSIndexPath).row]
         
         // Set the name and image "\(meme.top) ... \(meme.bottom)"
        cell.textLabel?.text = "\(meme.topText) ... \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
         
         // If the cell has a detail label, we will put the evil scheme in.
     if let detailTextLabel = cell.detailTextLabel {
             detailTextLabel.text = "TOP: \(meme.topText)..BOTTOM: \(meme.bottomText)"
         }
         
         return cell
     }
    
    
    // method 3

     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
           detailController.memePicked = self.memes[(indexPath as NSIndexPath).row]
           self.navigationController!.pushViewController(detailController, animated: true)
       }
     


}
