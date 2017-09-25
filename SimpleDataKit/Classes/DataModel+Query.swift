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
    open static func find<Self>(where property: String, _ relation: Query<Self>.Relation = .equal, to target: Any) -> Query<Self> {
        let query = Query<Self>()
        return query.where(property, relation, to: target)
    }
    
    open static func all<Self>() -> Query<Self> {
        return Query<Self>()
    }
}

