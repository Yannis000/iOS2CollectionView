//
//  DetailViewController.swift
//  iOS2CollectionView
//
//  Created by lpiem on 16/03/2022.
//

import UIKit

class DetailViewController: UIViewController{
        
    var landmark: Landmark? = nil
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var descriptionLandmark: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let landmark = landmark {
            photo.image = landmark.image
            photo.layer.cornerRadius = 25
            name.text = landmark.name
            latitude.text = "\(landmark.coordinates.latitude)"
            longitude.text = "\(landmark.coordinates.longitude)"
            descriptionLandmark.text = landmark.description
        }
    }
}
