//
//  PlaceTableViewCell.swift
//  PA8
//
//  Created by Emma Woodburn on 11/25/18.
//  Copyright © 2018 Emma Woodburn. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with place: Place){
        titleLabel.text = "\(place.name) (\(place.rating) stars)"
        locationLabel.text = place.vicinity
        
    }
    
    

}
