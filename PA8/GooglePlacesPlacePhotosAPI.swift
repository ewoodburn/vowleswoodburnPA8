/*
Description: This file is the allows use of the Place Photos Google API. Values are retreived from the API using JSON. To use the values, the JSON is parsed. The values on the JSON are returned from the fetchPlaces method.
Course: CPSC 315
Assignment number:  Programming Assignment #8
Sources: N/A
Sammy Vowles and Emma Wooburn
November 29, 2018 - Version 1

*/
//
//  GooglePlacesPlacePhotosAPI.swift
//  PA8
//
//  Created by Emma Woodburn on 11/28/18.
//  Copyright © 2018 Emma Woodburn. All rights reserved.
//

import Foundation
import UIKit
/**
 This class allows use of the Place Photos Google API. Values are retreived from the API using JSON. To use the values, the JSON is parsed. The values on the JSON are returned from the fetchPlaces method.
 */
class GooglePlacesPlacePhotosAPI{
    //properties
    static let apiKey = "AIzaSyCzGQuL6O6-zw2kD19bFB79b7wKS8e9uww"
    static let baseURL = "https://maps.googleapis.com/maps/api/place/photo?parameters"
    
    /**
     This method is used to execute a request to the Place Photos Google API using the provided parameters. The JSON result is provided in a given URL.
     - Parameter photoreference: a String of the photoReference value of the current Place
     - Returns: the url of the image returned by the API
     */
    static func placePhotoURL(photoreference: String) -> URL{
        var maxHeight = 225
        let params = [
            "key": GooglePlacesPlacePhotosAPI.apiKey,
            "photoreference": "\(photoreference)",
            "maxheight": "\(maxHeight)"
            ]
        
        var queryItems = [URLQueryItem]()
        for (key, value) in params{
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        var components = URLComponents(string: GooglePlacesPlacePhotosAPI.baseURL)!
        components.queryItems = queryItems
        let url = components.url!
        //print(url)
        return url
    }
    
    /**
     This method is used to retreive a image stored in url from the Place Photos Google API. A new UIImage object of the image is created and returned.
     - Parameter photoRef: a String of the photoReference value of the current Place
     - Parameter completion: a closure used to pass the UIImage values retreived from the API back to the View Controller
     */
    static func fetchPhoto(photoRef: String, completion: @escaping (UIImage) -> Void) { ////, completion: @escaping ([Place]?) -> Void){
        
        print("here in photos")
        let url = GooglePlacesPlacePhotosAPI.placePhotoURL(photoreference: photoRef)
        print("photo url: \(url)")
        
        if let photoData = try? Data(contentsOf: url){
            if let photoImage = UIImage(data: photoData) {
                DispatchQueue.main.async {
                    completion(photoImage)
                    
                    
                }
            }
        }
        
}

