//
//  ViewController.swift
//  Udacity MemeMe
//
//  Created by Diego Malone on 01/06/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //MARK: Properties
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0
    ]
    
    var activeTextField: UITextField?
    
    //MARK: Lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Helper methods
    
    private func configureTextField(textField: UITextField, defaultText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.text = defaultText
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func hideUiElements() {
        navigationBar.isHidden = true
        toolbar.isHidden = true
    }
    
    func showUiElements() {
        navigationBar.isHidden = false
        toolbar.isHidden = false
    }
    
    func generateMemedImage() -> UIImage {
        
        hideUiElements()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        showUiElements()
        
        return memedImage
    }
    
    func save(memeImage: UIImage) {
        let _ = Meme(topText: self.topTextField.text!,
                     bottomText: self.bottomTextField.text!,
                     originalImage: self.imagePickerView.image!,
                     memeImage: memeImage)
    }
    
    //MARK: Button actions
    
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            showImagePicker(sourceType: .savedPhotosAlbum)
        } else {
            showImagePicker(sourceType: .camera)
        }
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memeImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        
        present(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = { _, completed, _, _ in
            if completed {
                self.save(memeImage: memeImage)
            }
        }
    }
    
    @IBAction func resetState() {
        configureTextField(textField: topTextField, defaultText: "TOP TEXT")
        configureTextField(textField: bottomTextField, defaultText: "BOTTOM TEXT")
        shareButton.isEnabled = false
        imagePickerView.image = nil
    }
    
    //MARK: TextField delegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = "YOUR TEXT HERE"
        }
    }
    
    //MARK: ImagePicker delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Keyboard management
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (activeTextField?.frame.origin.y ?? 0) > getKeyboardYCoordinate(notification) && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardYCoordinate(_ notification: Notification) -> CGFloat {
        return getKeyboardRectFrom(notification: notification).origin.y
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        return getKeyboardRectFrom(notification: notification).size.height
    }
    
    func getKeyboardRectFrom(notification: Notification) -> CGRect {
        let userInfo = notification.userInfo
        let keyboard = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboard.cgRectValue
    }
}

