//
//  LandmarkCategoryItemCell.swift
//  iOS2CollectionView
//
//  Created by lpiem on 09/03/2022.
//

import UIKit

class LandmarkCategoryItemCell: UICollectionViewCell{
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    func configure(landmark: Landmark){
        title.text = landmark.name
        photo.image = landmark.image
        photo.layer.cornerRadius = 8
    }
    
}
