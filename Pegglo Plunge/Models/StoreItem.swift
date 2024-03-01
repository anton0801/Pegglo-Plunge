//
//  StoreItem.swift
//  Pegglo Plunge
//
//  Created by Anton on 28/2/24.
//

import Foundation


struct StoreItem {
    var name: String
    var src: String
    var type: StoreItemType
    var price: Int
    var id: String = UUID().uuidString
}

enum StoreItemType {
    case wallpaper
    case ball
}
