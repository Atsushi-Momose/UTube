//
//  Utility.swift
//  UTube
//
//  Created by 百瀬篤志 on 2022/03/23.
//

import Foundation


extension Optional where Wrapped == String {
    
    var isEmpty: Bool {
        guard let str = self else {
            return true
        }
        return str.isEmpty
    }
}
    
