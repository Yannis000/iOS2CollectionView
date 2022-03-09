//
//  DataManager.swift
//  iOS2CollectionView
//
//  Created by lpiem on 09/03/2022.
//

import Foundation

class DataManager{
    
    public static let sharedInstance = DataManager()
    
    private init() { }
    
    func getData(forName name: String) -> [Landmark] {
        do {
            if let bundlePath = Bundle.main.path(forResource: "landmarkData",
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                let decoder = JSONDecoder()
                let product = try decoder.decode([Landmark].self, from: jsonData)
                return product
            }
        } catch {
            print(error)
        }
        return []
    }
}
