//
//  NextViewController.swift
//  FirebaseLogin
//
//  Created by 中條航紀 on 2020/03/03.
//  Copyright © 2020 中條航紀. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import Photos

class NextViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    

    @IBOutlet weak var timeLineTableView: UITableView!
    
    var selectedImage = UIImage()
    
    
    var userName = String()
    var userImageData = Data()
    var userImage = UIImage()
    var commentString = String()
    var createDate = String()
    var contentImageString = String()
    var userProfileImageString = String()
    
    var contentsArray = [Contents]()
    
    @IBOutlet weak var cameraButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch(status){
                
            case .authorized:
                print("許可されてますよ")

            case .denied:
                    print("拒否")

            case .notDetermined:
                        print("notDetermined")
                
            case .restricted:
                        print("restricted")
                
            }
            
        }
        
        
        
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        if UserDefaults.standard.object(forKey: "userName") != nil{
            
            userName = UserDefaults.standard.object(forKey: "userName") as! String
            
        }

        if UserDefaults.standard.object(forKey: "userImage") != nil{
            
            userImageData = UserDefaults.standard.object(forKey: "userImage") as! Data
            userImage = UIImage(data: userImageData)!
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        fetchContentsData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contentsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        userName = contentsArray[indexPath.row].userNameString
        
        commentString = contentsArray[indexPath.row].commentString

        createDate = contentsArray[indexPath.row].postDateString
        contentImageString = contentsArray[indexPath.row].contentImageString
        userProfileImageString = contentsArray[indexPath.row].profileImageString
        
        performSegue(withIdentifier: "detail", sender: nil)

        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailVC = segue.destination as! DetailViewController
        detailVC.userName = userName
        detailVC.comment = commentString
        detailVC.date = createDate
        detailVC.profileImage = userProfileImageString
        detailVC.contentImage = contentImageString
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //コンテンツ
        
        //アイコン
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        profileImageView.sd_setImage(with: URL(string: contentsArray[indexPath.row].profileImageString), completed: nil)
        
        profileImageView.layer.cornerRadius = 30.0
        print("デバック2")
        print(profileImageView)
        
        //ユーザー名
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = contentsArray[indexPath.row].userNameString
        
        //投稿日時
        let dateLabel = cell.viewWithTag(3) as! UILabel
        dateLabel.text = contentsArray[indexPath.row].postDateString
        
        //投稿画像
        let contentImageView = cell.viewWithTag(4) as! UIImageView
        contentImageView.sd_setImage(with: URL(string: contentsArray[indexPath.row].contentImageString), completed: nil)
        
        
        //コメントラベル
        let commentLabel = cell.viewWithTag(5) as! UILabel
        commentLabel.text = contentsArray[indexPath.row].commentString
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 621
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        
        showAlert()
    }
    
    func doCamera(){
        let sourceType:UIImagePickerController.SourceType = .camera
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
    }
    
    func doAlbum(){
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    func showAlert(){
        
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            
            self.doCamera()
            
        }
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            
            self.doAlbum()
            
        }
        
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    //画像が選択 or 撮影後に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        selectedImage = info[.originalImage] as! UIImage
        //ナビゲーションを用いて画面遷移
        
        let editPostVC = self.storyboard?.instantiateViewController(identifier: "editPost") as! EditAndPostViewController
        editPostVC.passedImage = selectedImage
        
        self.navigationController?.pushViewController(editPostVC, animated: true)
        //ピッカーを閉じる
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func fetchContentsData(){
        
        let ref = Database.database().reference().child("timeLine").queryLimited(toLast: 100).queryOrdered(byChild: "postDate").observe(.value) { (snapShot) in
            
            self.contentsArray.removeAll()
            if let snapShot = snapShot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapShot{
                    
                    if let postData = snap.value as? [String:Any]{
                        
                        let userName = postData["userName"] as? String
                        let userProfileImage = postData["userProfileImage"] as? String
                        let contents = postData["contents"] as? String
                        let comment = postData["comment"] as? String
                        var postDate:CLong?
                        
                        
                        if let postedDate = postData["postDate"] as? CLong{
                            
                                postDate = postedDate
                            
                        }
                        
                        let timeString = self.convertTimeStamp(serverTimeStamp: postDate!)
                        self.contentsArray.append(Contents(userNameString: userName!, profileImageString: userProfileImage!, contentImageString: contents!, commentString:comment!, postDateString: timeString))
                    }
                   }
                self.timeLineTableView.reloadData()
                let indexPath = IndexPath(row: self.contentsArray.count - 1, section: 0)
                if self.contentsArray.count >= 5{
                    
                    self.timeLineTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    
                }
                
            }
            
            
            
        }
        
        
    }
    
    func convertTimeStamp(serverTimeStamp:CLong)->String{
           
        let x = serverTimeStamp / 1000
        let date = Date(timeIntervalSince1970: TimeInterval(x))
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
           
        return formatter.string(from: date)
           
    }
}
