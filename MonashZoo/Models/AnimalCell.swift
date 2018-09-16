//
//  LocationCell.swift
//  MonashZoo
//
//  Created by Ren Jie on 22/8/18.
//  Copyright © 2018 JRen. All rights reserved.
//

import UIKit

class AnimalCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(for animal: Animal) {
        if animal.animalDescription.isEmpty {
            descriptionLabel.text = "(No Description)"
        } else {
            descriptionLabel.text = animal.animalDescription
        }
        
        if let placemark = animal.placemark {
            var text = ""
            if let s = placemark.subThoroughfare {
                text += s + " "
            }
            if let s = placemark.thoroughfare {
                text += s + ", "
            }
            if let s = placemark.locality {
                text += s
            }
            addressLabel.text = text
        } else {
            //addressLabel.text = String(format: "Lat: %.8f, Long: %.8f", animal.latitude, animal.longitude)
            addressLabel.text = "Caulfield, Monash Zoo"
        }
        photoImageView.image = thumbnail(for: animal)
    }

    
    func thumbnail(for animal: Animal) -> UIImage {
        if animal.hasPhoto, let image = animal.photoImage {
            return image.resized(withBounds: CGSize(width: 52, height: 52))
        } else{
            return categoryIcon(animal)
        }
    }
}

