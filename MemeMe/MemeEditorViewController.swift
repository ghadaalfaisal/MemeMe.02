//
//  ViewController.swift
//  MemeMe
//
//  Created by Ghada Faisal on 31/05/2020.
//  Copyright © 2020 GhadaFaisal. All rights reserved.
// Adding NSCameraUsageDescription & NSPhotoLibraryUsageDescription in info.plist is mandotry for this app
// ✅


import UIKit

class MemeEditorViewController : UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var imagePickerView: UIImageView! // clipsToBounds = false & ImageView.contentMode = .scaleAspectFill
    @IBOutlet weak var cameraButton: UIBarButtonItem!
   
    @IBOutlet weak var topTextFields: UITextField!
    
    @IBOutlet weak var bottomTextFields: UITextField!

    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    

    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
    .strokeColor: UIColor.black,
    .foregroundColor: UIColor.white,
    .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
   .strokeWidth: -1 ]

          
      func setupTextField(_ textField: UITextField, defaultText: String){
      textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.text = defaultText
        textField.textAlignment = .center
      }
    
    
    override func viewDidLoad() {
        setupTextField(topTextFields , defaultText: "TOP")
        setupTextField(bottomTextFields , defaultText: "BOTTOM")
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
    cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // check if the device being used doesn't have a camera?
     //  navigationController?.setNavigationBarHidden(true, animated: animated)

    subscribeToKeyboardNotifications()
        
 }

    
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
          // navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
   
    func subscribeToKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
      NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil) }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func keyboardWillShow(_ notification:Notification) {

        view.frame.origin.y -= getKeyboardHeight(notification)
    }

    @objc func keyboardWillHide(_ notification:Notification) {

          view.frame.origin.y = 0
      }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
      pickAnImage(sourceType: .photoLibrary) }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
     
          pickAnImage(sourceType:  .camera)
       }

  func imagePickerController(_ picker: UIImagePickerController,
  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    imagePickerView.isHidden = false
 //   let image = info[.originalImage] as? UIImage
 //  imagePickerView.image = image or >> both are work

    if let image = info[ .originalImage] as? UIImage {
    imagePickerView.image = image
        shareButton.isEnabled = true   }
    dismiss(animated: true, completion: nil)

}

    
   // textFieldDidBeginEditing
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        shareButton.isEnabled = true  }
       
    
    // textFieldShouldReturn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
        }
    
    func save() {
                    // Create the meme
    
       let  meme = Meme(topText: topTextFields.text!, bottomText: bottomTextFields.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage() )
        
    //    let object = UIApplication.shared.delegate
     //   let appDelegate = object as! AppDelegate
       // appDelegate.memes.append(meme)
        
         (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        
    }
    
    
    func generateMemedImage() -> UIImage {

        // TODO: Hide toolbar and navbar
   
             self.toolBar.isHidden = true
             self.navigationController?.isNavigationBarHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        // TODO: Show toolbar and navbar
        self.toolBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = false
        return memedImage
    }
  
    
   @IBAction  func share() {
        if shareButton.isEnabled{
        let image = self.generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                         
            
            activityViewController.completionWithItemsHandler = { ( activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                if completed  {
            self.save()
            self.dismiss(animated: true, completion: nil)
          }
                else {
                    print("The opreation cancelled")
                }
          
            }
            self.present(activityViewController , animated: true , completion: nil)
    }
 
  //  self.dismiss(animated: true, completion: nil)

    
    }
 // When the user presses the “Cancel” button, the Meme Editor View returns to its launch state, displaying no image and default text.

    @IBAction func Cancel(_ sender: Any) {
      topTextFields.text = "TOP"
        bottomTextFields.text = "BOTTOM"
        //imagePickerView.isHidden = true
        shareButton.isEnabled = false
        
        self.dismiss(animated: true, completion: nil)
 
    }
   

    
}
