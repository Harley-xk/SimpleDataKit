//
//  DataBase.swift
//  Comet
//
//  Created by Harley.xk on 2018/1/7.
//

import Foundation
import FMDB

class DataBase {
    
    init(path: URL, reserved: URL? = nil) {
        FMDatabase(url: path)
    }
    
    
    
}
