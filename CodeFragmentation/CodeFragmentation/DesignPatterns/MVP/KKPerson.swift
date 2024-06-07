//
//  KKPerson.swift
//  CodeFragmentation
//
//  Created by Kaaaaai on 2020/8/28.
//  Copyright © 2020 Kaaaaai. All rights reserved.
//

import UIKit

struct KKPerson {
    var name: String
    var sex: String
    var grade: String
    
    init(){
        self.name = ""
        self.sex = ""
        self.grade = ""
    }
    
    init(name: String, sex: String, grade: String) {
        self.name = name
        self.sex = sex
        self.grade = grade
    }
}

extension KKPerson{
    func buildWith(_ dict: [String: AnyObject]) -> KKPerson{
        var person = KKPerson.init()
        person.loadFromDictionary(dict)
        return person
    }
    
    mutating func loadFromDictionary(_ dict: [String: Any]) {
        if let data = dict["name"] as? String {
            name = data
        }
        if let data = dict["sex"] as? String {
            sex = data
        }
        if let data = dict["grade"] as? String {
            grade = data
        }
    }
}
