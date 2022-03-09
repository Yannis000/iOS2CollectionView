//
//  DataManager.swift
//  iOS2CollectionView
//
//  Created by lpiem on 09/03/2022.
//

import Foundation

class DataManager{
    
    public static let sharedInstance = DataManager()
    private var landmark : [Landmark] = []
    
    private init() { }
    
    func getData(forName name: String) -> [Landmark] {
        do {
            if let bundlePath = Bundle.main.path(forResource: "landmarkData",
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                
                let decoder = JSONDecoder()
                landmark = try decoder.decode([Landmark].self, from: jsonData)
                return landmark
            }
        } catch {
            print(error)
        }
        return []
    }
    
    func getFavorite() -> [Landmark]{
        
        var favLandmark : [Landmark] = []
        
        landmark.forEach { landmark in
            if(landmark.isFavorite == true){
                favLandmark.append(landmark)
            }
        }
        return favLandmark
    }
    
    func getCategory(category : Landmark.Category) -> [Landmark]{
        
        var catLandmark : [Landmark] = []
        
        landmark.forEach { landmark in
            switch category{
            case .lakes:
                if(landmark.category == "Lakes"){
                    catLandmark.append(landmark)
                }
            case .mountains:
                if(landmark.category == "Mountains"){
                    catLandmark.append(landmark)
                }
            case .rivers:
                if(landmark.category == "Rivers"){
                    catLandmark.append(landmark)
                }
            }
        }
        return catLandmark
        
    }
}
