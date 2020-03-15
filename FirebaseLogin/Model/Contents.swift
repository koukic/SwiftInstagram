//
//  Contents.swift
//  FirebaseLogin
//
//  Created by 中條航紀 on 2020/03/03.
//  Copyright © 2020 中條航紀. All rights reserved.
//

import Foundation

class Contents{
    var userNameString:String = ""
    var profileImageString:String = ""
    var contentImageString:String = ""
    var commentString:String = ""
    var postDateString:String = ""
    
    init(userNameString:String,profileImageString:String,contentImageString:String,commentString:String,postDateString:String){
        
        self.userNameString = userNameString
        self.profileImageString = profileImageString
        self.contentImageString = contentImageString
        self.commentString = commentString
        self.postDateString = postDateString
        
        
    }
}

