//
//  Query.swift
//  SimpleDataKit
//
//  Created by Harley.xk on 2017/4/8.
//  Copyright (c) 2017 Harley. All rights reserved.
//

import CoreData

extension Query {
    /*
     * Current avaliable relations on query
     */
    public enum Relation: String {
        case equal = "="
        case unequal = "!="
        case greaterThan = ">"
        case greaterThanOrEqual = ">="
        case lessThan = "<"
        case lessThanOrEqual = "<="
        case like = "like"
    }
    
    enum Combination: String {
        case and = "and"
        case or = "or"
    }
}

open class Query<Model: Queryable> {
    
    
    /// Basic query with 'and'
    public func `where`(_ property: String, _ relation: Relation = .equal, to target: Any) -> Self {
        return addPredicateUnit(property, relation, target, combination: .and)
    }
    
    /// Basic query with 'or'
    public func or(_ property: String, _ relation: Relation = .equal, to target: Any) -> Self {
        return addPredicateUnit(property, relation, target, combination: .or)
    }
    
    /// Nested query with 'and'
    public func `where`(_ block: (Query<Model>) -> ()) -> Self {
        let query = Query<Model>()
        block(query)
        return addNestedPredicate(with: query, combination: .and)
    }
    
    /// Nested query with 'or'
    public func or(_ block: (Query<Model>) -> ()) -> Self {
        let query = Query<Model>()
        block(query)
        return addNestedPredicate(with: query, combination: .or)
    }
    
    /// 'in' query with 'and', search results where value of the property is in vaules specified
    public func `where`(_ property: String, in values: [Any]) -> Self {
        return add_IN_Predicate(property: property, targets: values, combination: .and)
    }
    
    public func `or`(_ property: String, in values: [Any]) -> Self {
        return add_IN_Predicate(property: property, targets: values, combination: .or)
    }
    
    /// add a setting about sort order
    public func sortBy(_ property: String, ascending: Bool = true) -> Self {
        let sort = NSSortDescriptor(key: property, ascending: ascending)
        sortDescriptors.append(sort)
        return self
    }
    
    /// Get objects by current settings
    public func get() -> [Model] {
        let request = setupFetchRequest()
        do {
            let models = try DataManager.shared.context.fetch(request)
            return models
        } catch {
            print(error)
            return []
        }
    }
    
    /// results count by current settings, speed up by avoiding to fetching objects
    public func count() -> Int {
        let request = setupFetchRequest()
        do {
            let count = try DataManager.shared.context.count(for: request)
            return count
        } catch {
            print(error)
            return 0
        }
    }
    
    /// Fetch results with pagination settings
    public func paginate(page: Int = 0, size: Int = 0) -> [Model] {
        self.pageIndex = page
        self.pageSize = size
        return self.get()
    }
    
    /// FetchRequest by current settings
    public var fetchRequest: NSFetchRequest<Model> {
        return setupFetchRequest()
    }
    
    // MARK: - Private
    fileprivate var predicateformat: String = ""
    fileprivate var predicateValues: [Any] = []
    
    fileprivate var sortDescriptors: [NSSortDescriptor] = []
    
    // paginate
    fileprivate var pageIndex: Int = 0
    fileprivate var pageSize: Int = 0

    fileprivate func setupFetchRequest() -> NSFetchRequest<Model> {
        
        let fetchRequest = NSFetchRequest<Model>(entityName: Model.entityName)
        // predicate
        if !predicateformat.isEmpty {
            fetchRequest.predicate = NSPredicate(format: predicateformat, argumentArray: predicateValues)
        }
        // order
        fetchRequest.sortDescriptors = sortDescriptors
        // paginate
        fetchRequest.fetchOffset = pageIndex * pageSize
        fetchRequest.fetchLimit = pageSize
        
        return fetchRequest
    }
}

// MARK: - Private Predicates
extension Query {
    
    fileprivate func addPredicateformat(_ format: String, combination: Combination) {
        if !predicateformat.isEmpty {
            predicateformat += " \(combination.rawValue) "
        }
        predicateformat += format
    }

    fileprivate func addPredicateUnit(_ property: String, _ relation: Relation, _ target: Any, combination: Combination) -> Self {
        addPredicateformat("\(property) \(relation.rawValue) %@", combination: combination)
        predicateValues.append(target)
        return self
    }
    
    fileprivate func addNestedPredicate(with query: Query, combination: Combination) -> Self {
        addPredicateformat("(\(query.predicateformat))", combination: combination)
        predicateValues.append(contentsOf: query.predicateValues)
        return self
    }
    
    fileprivate func add_IN_Predicate(property: String, targets: [Any], combination: Combination) -> Self {
        var formats = [String]()
        for _ in 0 ..< targets.count {
            formats.append("%@")
        }
        let format = "\(property) in {\(formats.joined(separator: ","))}"
        addPredicateformat(format, combination: combination)
        predicateValues.append(contentsOf: targets)
        return self
    }
}
