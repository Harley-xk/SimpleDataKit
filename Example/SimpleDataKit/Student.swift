//
//  Student.swift
//  SimpleDataKit
//
//  Created by Harley.xk on 2017/4/12.
//  Copyright 2017年 CocoaPods. All rights reserved.
//

import Foundation
import SimpleDataKit
import CoreData

/**
 *  Student Model
 */
final class Student : DataModel, FetchControled {
    @NSManaged fileprivate(set) var name: String
    @NSManaged fileprivate(set) var email: String?
    @NSManaged fileprivate(set) var birthday: Date?
    @NSManaged fileprivate(set) var score: Int16
    
    static public func create(name: String, email: String?, birthday: Date?) -> Student {
        let student = Student.create()
        student.name = name
        student.email = email
        student.birthday = birthday
        student.score = Int16(arc4random_uniform(100) + 1)
        return student
    }
    
    static var defaultFetchingRequest: NSFetchRequest<Student> {
        return Student.all().where("score", in: [30, 35, 36]).sortBy("score", ascending: false).fetchRequest
    }
}

