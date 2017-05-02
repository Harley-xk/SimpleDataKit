//
//  DataModel+Query.swift
//  Pods
//
//  Created by Harley.xk on 2017/4/9.
//
//

import CoreData

public protocol Queryable: Managed, NSFetchRequestResult {
    static func find<Self>(where property: String, _ relation: Query<Self>.Relation, to target: Any) -> Query<Self>
    static func all<Self>() -> Query<Self>
}

// MARK: - Query
extension DataModel: Queryable {
    open static func create() -> Self {
        return DataManager.shared.context.insertObject()
    }
    
    @discardableResult open func save() -> Bool {
        if !self.isInserted {
            DataManager.shared.context.insert(self)
        }
        return DataManager.shared.save()
    }
    
    open func delete() {
        DataManager.shared.context.delete(self)
    }
}

extension DataModel {
    open static func find<Self>(where property: String, _ relation: Query<Self>.Relation = .equal, to target: Any) -> Query<Self> {
        let query = Query<Self>()
        return query.where(property, relation, to: target)
    }
    
    open static func all<Self>() -> Query<Self> {
        return Query<Self>()
    }
}

