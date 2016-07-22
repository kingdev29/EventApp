//
//  PhoneValidation.swift
//  Pingo
//
//  Created by Jeff Potter on 11/11/14.
//  Copyright (c) 2014 Byron Mackay. All rights reserved.
//
/*


import Foundation

public class ZipCodeRule: RegexRule {

public convenience init(message : String = "Enter a valid 5 digit zipcode"){
self.init(regex: "\\d{5}", message : message)
}
}
*/

import Foundation

public class PhoneNumberRule: RegexRule {
//    let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
    let PHONE_REGEX = "^\\d{10}$"
    
    public convenience init(message : String = " Enter a valid 10 digit phone number") {
        self.init(regex: "^\\d{10}$" , message : message)
    }
}


