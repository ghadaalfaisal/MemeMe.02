//
//  MemeCollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Ghada Faisal on 16/06/2020.
//  Copyright © 2020 GhadaFaisal. All rights reserved.
//
import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {

     @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
           let object = UIApplication.shared.delegate
           let appDelegate = object as! AppDelegate
           return appDelegate.memes
       }
    
  override func viewDidLoad() {
        super.viewDidLoad()

        let space:CGFloat = 4.0
       let dimension1 = (view.frame.size.width - (2 * space)) / 3.0
     let dimension2 = (view.frame.size.height - (2 * space)) / 5.0
// The default size value is (50.0, 50.0).
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension1, height: dimension2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        collectionView?.reloadData()

    }
    
    
    override func collectionView(_ collectionView: UICollectionView,
     numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMemeCell", for: indexPath) as! CustomMemeCell
   let meme = self.memes[(indexPath as NSIndexPath).row]
    
       cell.memeImageView?.image = meme.memedImage
    return cell
    }
    
 
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
         let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
                   detailController.memePicked = self.memes[(indexPath as NSIndexPath).row]
                   self.navigationController!.pushViewController(detailController, animated: true)   }


}
