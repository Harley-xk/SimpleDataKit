//
//  Query.swift
//  SimpleDataKit
//
//  Created by Harley.xk on 2017/4/8.
//  Copyright (c) 2017 Harley. All rights reserved.
//

import CoreData

extension Query {
    enum Relation: String {
        case equal = "="
        case unequal = "!="
        case greaterThan = ">"
        case greaterThanOrEqual = ">="
        case lessThan = "<"
        case lessThanOrEqual = "<="
        case like = "like"
    }
}

class Query<Model: DataModel> {
    
    public func `where`(_ property: String, _ relation: Relation = .equal, _ target: Any) -> Self {
        let predicate = (property, relation.rawValue, target)
        predicates.append(predicate)
        return self
    }
    
    public func sortBy(_ property: String, ascending: Bool = true) -> Self {
        let sort = NSSortDescriptor(key: property, ascending: ascending)
        sortDescriptors.append(sort)
        return self
    }
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
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
    
    // MARK: - Private
    private typealias PredicateUnit = (property: String, relation: String, target: Any)
    private var predicates: [PredicateUnit] = []
    
    private var sortDescriptors: [NSSortDescriptor] = []
    
    private func setupFetchRequest() -> NSFetchRequest<Model> {
        
        let fetchRequest = NSFetchRequest<Model>(entityName: Model.entityName)
        // 组装谓词
        if predicates.count > 0 {
            var string = "\(predicates[0].property) \(predicates[0].relation) %@"
            var values: [Any] = [predicates[0].target]
            for i in 1 ..< predicates.count {
                string += " and " + "\(predicates[i].property) \(predicates[i].relation) %@"
                values.append(predicates[i].target)
            }
            fetchRequest.predicate = NSPredicate(format: string, argumentArray: values)
        }
        // 设置排序
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest
    }
}
