/*
 Description: This file outlines a single cell of the PlaceTableView. It provides functionality for the UI elements of the Place Table View Cells.
 Course: CPSC 315
 Assignment number:  Programming Assignment #8
 Sources: N/A
 Sammy Vowles and Emma Wooburn
 November 29, 2018 - Version 1
 */
//
//  PlaceTableViewCell.swift
//  PA8
//
//  Created by Emma Woodburn on 11/25/18.
//  Copyright © 2018 Emma Woodburn. All rights reserved.
//

import UIKit

/**
 This class outlines a single cell of the PlaceTableView. It provides functionality for the UI elements of the Place Table View Cells.
 */
class PlaceTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!

    /**
     This method calls the parent class implementation of the method.  It prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /**
     Calls the uper class implemention of the method which sets the state of the selected cell.
     - Parameter selected: a boolean value of if the cell is selected.
     - Parameter animated: a boolean value of if the  cell is anilated.
    */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     Updates the UI elements of a particular cell with proper text retreived from a Place object.
     - Parameter place: a Place obejct
    */
    func update(with place: Place){
        titleLabel.text = "\(place.name) (\(place.rating)⭐️)"
        locationLabel.text = place.vicinity
        
    }
    
    

}
