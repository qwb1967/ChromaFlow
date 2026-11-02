//
//  Item.swift
//  ChromaFlow
//
//  Created by 钱文博 on 2024/12/22.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
