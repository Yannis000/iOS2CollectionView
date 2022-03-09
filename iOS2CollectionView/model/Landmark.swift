//
//  Landmark.swift
//  iOS2CollectionView
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

struct Landmark: Decodable, Hashable{
    
    enum Category: String, CaseIterable, Decodable{
        case lakes = "Lakes"
        case mountains = "Mountains"
        case rivers = "Rivers"
    }
    
    var id: Int
    var name: String
    var category: String
    var city: String
    var state: String
    var isFeatured: Bool
    var isFavorite: Bool
    var park: String
    var coordinates: Coordinate
    var description: String
    private let imageName: String
    
    var image: UIImage{
        return UIImage(named: imageName)!
    }
}

struct Coordinate: Decodable, Hashable{
    var longitude: Double
    var latitude: Double
}
