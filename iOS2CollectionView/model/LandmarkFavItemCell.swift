//
//  LandmarkCellItem.swift
//  iOS2CollectionView
//
//  Created by lpiem on 09/03/2022.
//

import Foundation
import UIKit

class LandmarkFavItemCell: UICollectionViewCell{
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func configure(landmark: Landmark){
        photo.image = landmark.image
        title.text = landmark.name
    }
}
