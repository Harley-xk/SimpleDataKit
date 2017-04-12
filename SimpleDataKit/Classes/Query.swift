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
}

open class Query<Model: Queryable> {
    
    /// add a setting about query params
    public func `where`(_ property: String, _ relation: Relation = .equal, _ target: Any) -> Self {
        let predicate = (property, relation.rawValue, target)
        predicates.append(predicate)
        return self
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
    private typealias PredicateUnit = (property: String, relation: String, target: Any)
    private var predicates: [PredicateUnit] = []
    
    private var sortDescriptors: [NSSortDescriptor] = []
    
    // paginate
    private var pageIndex: Int = 0
    private var pageSize: Int = 0

    private func setupFetchRequest() -> NSFetchRequest<Model> {
        
        let fetchRequest = NSFetchRequest<Model>(entityName: Model.entityName)
        // predicates
        if predicates.count > 0 {
            var string = "\(predicates[0].property) \(predicates[0].relation) %@"
            var values: [Any] = [predicates[0].target]
            for i in 1 ..< predicates.count {
                string += " and " + "\(predicates[i].property) \(predicates[i].relation) %@"
                values.append(predicates[i].target)
            }
            fetchRequest.predicate = NSPredicate(format: string, argumentArray: values)
        }
        // order
        fetchRequest.sortDescriptors = sortDescriptors
        // paginate
        fetchRequest.fetchOffset = pageIndex * pageSize
        fetchRequest.fetchLimit = pageSize
        
        return fetchRequest
    }
}
