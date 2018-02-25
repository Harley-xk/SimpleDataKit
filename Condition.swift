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

struct Condition {
    
    init() {
    }
    init<Table: SQLiteTable, Property: DataType>(_ key: KeyPath<Table, Property>, in values: [Property]) {
        let field = Table.columns[]
        
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



