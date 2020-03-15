//
//  TourokuViewController.swift
//  FirebaseLogin
//
//  Created by 中條航紀 on 2020/03/03.
//  Copyright © 2020 中條航紀. All rights reserved.
//

import UIKit
import Firebase

class TourokuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func login(_ sender: Any) {
        Auth.auth().signInAnonymously { (authResult, error) in
            let user = authResult?.user
            print(user)
            
            let inputVC = self.storyboard?.instantiateViewController(identifier: "inputVC") as! InputViewController
            
            self.navigationController?.pushViewController(inputVC, animated: true)
            
        }
        
    }
    
    

}
