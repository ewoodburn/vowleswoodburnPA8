/*
 Description: This file is the ViewController for the Place Detail Screen. It provides functionality for the Place Detail UI elements and manipultes the model data as necessary.
 Course: CPSC 315
 Assignment number:  Programming Assignment #8
 Sources: N/A
 Sammy Vowles and Emma Wooburn
 November 29, 2018 - Version 1
 */
//
//  PlaceDetailViewController.swift
//  PA8
//
//  Created by Emma Woodburn on 11/25/18.
//  Copyright © 2018 Emma Woodburn. All rights reserved.
//

import UIKit
/**
 This class is the ViewController for the Place Detail Screen. It provides functionality for the Place Detail UI elements and manipultes the model data as necessary.
 */
class PlaceDetailViewController: UIViewController {
    //properties
    var place: Place? = nil
    
    var placeID = ""
    var placePhotoReference = ""
    
    var name: String = ""
    var address: String = ""
    var phoneNumber: String = ""
    var openStr: String = ""
    var review: String = ""
    
    //outlets
    @IBOutlet var nameAndOpenLabel: UILabel!
    
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var phoneNumberLabel: UILabel!
    
    @IBOutlet var reviewLabel: UILabel!
    
    @IBOutlet var image: UIImageView!
    
    

    /**
     The UI elements of the selected place are displayed using the Place Details and Place Photos API requests.
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let displayPlace = place{
            name = displayPlace.name
            placeID = displayPlace.id
            placePhotoReference = displayPlace.photoReference
            
            self.nameAndOpenLabel.text = name
            
            
            GoogleSwiftDetailsAPI.fetchDetailsPlaces(id: placeID, completion: {(placeAddress, placePhoneNumber, placeOpenStr, placeReview) in
                self.address = placeAddress
                self.phoneNumber = placePhoneNumber
                self.openStr = placeOpenStr
                self.review = placeReview
            
                //update labels
                self.phoneNumberLabel.text = placePhoneNumber
                self.locationLabel.text = placeAddress
            
                if placeOpenStr == "true"{
                    self.nameAndOpenLabel.text = "\(self.name) (Open)"
                }
                else {
                    self.nameAndOpenLabel.text = "\(self.name) (Closed)"
                }
                
                self.reviewLabel.text = placeReview
                
            })
            
            
            GooglePlacesPlacePhotosAPI.fetchPhoto(photoRef: self.placePhotoReference, completion: {(photoURL) in
                self.image.image = photoURL
            })
            
            
            
        }
    }


}
