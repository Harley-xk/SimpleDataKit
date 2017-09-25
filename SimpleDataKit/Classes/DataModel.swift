//
//  DataModel.swift
//  SimpleDataKit
//
//  Created by Harley.xk on 2017/4/8.
//  Copyright (c) 2017 Harley. All rights reserved.
//

import CoreData

public protocol Managed {
    static var entityName: String { get }
}

open class DataModel: NSManagedObject, Managed {
    public static var entityName: String {
        if #available(iOS 10.0, *) {
            return entity().name!
        } else {
            return classNameWithoutModule
        }
    }
    
    public var identifier: String {
        return objectID.uriRepresentation().absoluteString
    }
    
    open static func create() -> Self {
        return DataManager.shared.context.insertObject()
    }
    
    @discardableResult open func save() -> Bool {
        return DataManager.shared.save()
    }
    
    open func delete() {
        DataManager.shared.context.delete(self)
    }
}

extension NSManagedObjectContext {
    func insertObject<Object: DataModel>() -> Object {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: Object.entityName, into: self) as? Object else {
            fatalError("Wrong object type")
        }
        return obj
    }
}

extension NSObject {
    /// 获取去除了模块名称的类名
    fileprivate class var classNameWithoutModule: String {
        let name = self.classForCoder().description()
        let compments = name.components(separatedBy: ".")
        return compments.last!
    }
}
