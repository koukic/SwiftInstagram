//
//  EditAndPostViewController.swift
//  FirebaseLogin
//
//  Created by 中條航紀 on 2020/03/03.
//  Copyright © 2020 中條航紀. All rights reserved.
//

import UIKit
import Firebase

class EditAndPostViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    var passedImage = UIImage()
    
    var userName = String()
    var userImageString = String()
    var userImageData = Data()
    var userImage = UIImage()
    
    let screenSize = UIScreen.main.bounds.size

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.delegate = self as UITextViewDelegate
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditAndPostViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditAndPostViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if UserDefaults.standard.object(forKey: "userName") != nil{
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        if UserDefaults.standard.object(forKey: "userImage") != nil{
            userImageData = UserDefaults.standard.object(forKey: "userImage") as! Data
            userImage = UIImage(data: userImageData)!
        }
        
        userProfileImage.image = userImage
        userNameLabel.text = userName
        contentImageView.image = passedImage
        
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification){
        let keyboardHeight = ((notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue?.height
        commentTextView.frame.origin.y = screenSize.height - keyboardHeight! - commentTextView.frame.height
        sendButton.frame.origin.y = screenSize.height - keyboardHeight! - sendButton.frame.height
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification){
        commentTextView.frame.origin.y = screenSize.height - commentTextView.frame.height
        sendButton.frame.origin.y = screenSize.height - sendButton.frame.height
        
        guard  let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else{return}
        
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        commentTextView.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    @IBAction func postAction(_ sender: Any) {
        let timeLineDB = Database.database().reference().child("timeLine").childByAutoId()
        
        let storage = Storage.storage().reference(forURL: "gs://fir-login-50466.appspot.com")
        
        let key = timeLineDB.child("Users").childByAutoId().key
        let key2 = timeLineDB.child("Contents").childByAutoId().key
        
        let imageRef = storage.child("Users").child("\(String(describing: key!)).jpg")
        let imageRef2 = storage.child("Contents").child("\(String(describing: key2!)).jpg")
        
        var contentImageData:Data = Data()
        var userProfileImageData:Data = Data()
        
        if userProfileImage.image != nil{
            userProfileImageData = (userProfileImage.image?.jpegData(compressionQuality: 0.01))!
        }
        
        if contentImageView.image != nil{
            contentImageData = (contentImageView.image?.jpegData(compressionQuality: 0.01))!
        }
        
        let uploadTask = imageRef.putData(userProfileImageData, metadata: nil){
            (metaData, error) in
            
            print("チェック")
            print(metaData)
            print(error)
            
            if error != nil{
                print(error)
                return
            }
            
            let uploadTask2 = imageRef2.putData(contentImageData, metadata: nil){
                (metaData, error) in
                print("チェック2")
                print(metaData)
                print(error)
                if error != nil{
                    print(error)
                    return
                }
                
                
                
                imageRef.downloadURL { (url, error) in
                    print("チェック3")
                    print(url)
                    print(error)
                    if url != nil{
                        imageRef2.downloadURL { (url2, error) in
                            print("チェック4")
                            print(url)
                            print(error)
                            if url2 != nil{
                                let timeLineInfo = ["userName": self.userName as Any, "userProfileImage": url?.absoluteString as Any,"contents": url2?.absoluteString as Any,"comment": self.commentTextView.text as Any, "postDate": ServerValue.timestamp()] as [String:Any]
                                print("チェック5")
                                print(timeLineInfo)
                                
                                
                                timeLineDB.updateChildValues(timeLineInfo)
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                        }
                    }
                }
            }
        }
        
        uploadTask.resume()
        
        self.dismiss(animated:true, completion: nil)
        
    }
    
}
