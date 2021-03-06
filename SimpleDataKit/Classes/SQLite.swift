//
//  SQLite.swift
//  Comet
//
//  Created by Harley.xk on 2018/1/7.
//

import Foundation

public protocol DataType {
    
}

extension Int: DataType{}
extension String: DataType{}
extension Double: DataType{}
extension Bool: DataType{}
extension Date: DataType{}

public struct Field<T: DataType> {
    
    public let name: String
    public let optional: Bool
    public let `default`: T?
    public let primary: Bool
    public let unique: Bool
}



public protocol IdentifierType {
    
}

extension Int: IdentifierType {}

//public struct Field {
//
//    public enum DataType {
//        case id(type: IdentifierType)
//        case int
//        case string(length: Int?)
//        case double
//        case bool
//        case bytes
//        case date
//        case custom(type: String)
//    }
//
//    var name: String
//    var dataType: DataType
//}

protocol SQLiteTable {
    
}

class Student: SQLiteTable {
    var name = ""
    var age = 0
    
//    var tableMap: [KeyPath<SQLiteTable, DataType>: String] {
//
//        let id = Field.id
//        let builder = builder
//        try builder.field(for: \.name)
//
//        return [
//            \Student.name: "name"
//        ]
//    }
}

protocol SQLiteEncodable: Encodable {
    associatedtype SQLiteColumns where SQLiteColumns: CodingKey
}

extension SQLiteEncodable {
    func encode(to encoder: Encoder) throws {
//        let c = encoder.container(keyedBy: SQLiteColumns.self)
        
    }
}

struct User: SQLiteEncodable {
    var id = 0
    var name = ""
    var age = 0
    
    enum SQLiteColumns: String, CodingKey {
        case id
        case name
        case age
    }
}
