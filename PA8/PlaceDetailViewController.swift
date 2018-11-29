//
//  PlaceDetailViewController.swift
//  PA8
//
//  Created by Emma Woodburn on 11/25/18.
//  Copyright © 2018 Emma Woodburn. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {
    var place: Place? = nil
    
    
    
    var placeID = ""
    
    var name: String = ""
    var address: String = ""
    var phoneNumber: String = ""
    var openStr: String = ""
    var review: String = ""
    
    @IBOutlet var nameAndOpenLabel: UILabel!
    
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var phoneNumberLabel: UILabel!
    
    @IBOutlet var reviewLabel: UILabel!
    
    @IBOutlet var image: UIImageView!
    
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let displayPlace = place{
            name = displayPlace.name
            placeID = displayPlace.id
            //phoneNumberLabel.text = placeID
            
            GoogleSwiftDetailsAPI.fetchDetailsPlaces(id: placeID, completion: {(placeAddress, placePhoneNumber, placeOpenStr, placeReview) in
                    self.address = placeAddress
                    self.phoneNumber = placePhoneNumber
                    self.openStr = placeOpenStr
                    self.review = placeReview
            })
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
