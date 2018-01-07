//
//  Condition.swift
//  Comet
//
//  Created by Harley.xk on 2018/1/7.
//

import Foundation

//protocol Table {
//
//}

//protocol  {
//    <#requirements#>
//}

extension AnyKeyPath {
    var string: String {
        return _kvcKeyPathString!
    }
}

struct Condition {
    
    init() {
        
    }
    init<Table: SQLiteTable, Property: DataType>(_ key: KeyPath<Table, Property>, in values: [Property]) {
        let name = key.string
        
        name
    }
    
}

func > <Table: SQLiteTable, Property: DataType>(lhs: KeyPath<Table, Property>, rhs: Property) -> Condition {
    return Condition()
}
func >= <Table: SQLiteTable, Property: DataType>(lhs: KeyPath<Table, Property>, rhs: Property) -> Condition {
    return Condition()
}
func < <Table: SQLiteTable, Property: DataType>(lhs: KeyPath<Table, Property>, rhs: Property) -> Condition {
    return Condition()
}
func <= <Table: SQLiteTable, Property: DataType>(lhs: KeyPath<Table, Property>, rhs: Property) -> Condition {
    return Condition()
}

func == <Table: SQLiteTable, Property: DataType>(lhs: KeyPath<Table, Property>, rhs: Property) -> Condition {
    return Condition()
}



