//
//  Contact.swift
//  iOSEventApp
//
//  Created by sunil maharjan on 1/25/16.
//  Copyright © 2016 Swiss Magic. All rights reserved.
//

import UIKit

class Contact: NSObject {
    
    var firstName:String!
    var surName:String!
    var emailAddress:String!
    var dob:String!
    var phone:String!
    var sex:String!
    
    init?(firstName:String,surName:String,emailAddress:String,dob:String,phone:String,sex:String) {
        super.init()
        self.firstName = firstName
        self.surName = surName
        self.emailAddress = emailAddress
        self.phone = phone
        self.dob = dob
        self.sex = sex
        if firstName.isEmpty || surName.isEmpty || emailAddress.isEmpty || dob.isEmpty || phone.isEmpty || sex.isEmpty {
            return nil
        }
    }

}
