/*
 Description: This file is the allows use of the Place Nearby Search Google API. Values are retreived from the API using JSON. To use the values, the JSON is parsed. The values on the JSON are returned from the fetchPlaces method.
 Course: CPSC 315
 Assignment number:  Programming Assignment #8
 Sources: N/A
 Sammy Vowles and Emma Wooburn
 November 29, 2018 - Version 1
 
 */

//
//  GoogleAPI.swift
//  PA8
//
//  Created by Emma Woodburn on 11/28/18.
//  Copyright © 2018 Emma Woodburn. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

/**
 This class allows use of the Place Nearby Search Google API. Values are retreived from the API using JSON. To use the values, the JSON is parsed. The values on the JSON are returned from the fetchPlaces method.
*/
class GoogleAPI{
    //static property declaration
    static let apiKey = "AIzaSyCzGQuL6O6-zw2kD19bFB79b7wKS8e9uww"
    static let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?parameters"
    
    /**
     This method is used to execute a request to the Place Nearby Search Google API using the provided parameters. The JSON result is provided in a given URL.
     - Parameter keyword: a String of the keyword to be searched in the API data
     - Parameter latitude: the latitide coordinate of the user
     - Parameter longitude: the longitude coordinate of the user
     - Returns: the url of the JSON returned by the API
    */
    static func placeSearchURL(keyword: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> URL{
        let params = [
            //"output": "json",
            "key": GoogleAPI.apiKey,
            "location": "\(latitude),\(longitude)",
            "rankby": "distance",
            "keyword": "\(keyword)"
        ]
        
        var queryItems = [URLQueryItem]()
        for (key, value) in params{
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        var components = URLComponents(string: GoogleAPI.baseURL)!
        components.queryItems = queryItems
        let url = components.url!
        print("near places url: \(url)")
        return url
    }
    
    /**
     This method is used to parse through the JSON included in the url of the Place Nearby Search Google API. A new Place object is created and returned.
     - Parameter keyword: the keyword used by the Place Nearby Search Google API request
     - Parameter latitude: the latitide coordinate of the user
     - Parameter longitude: the longitude coordinate of the user
     - Parameter completion: a closure used to pass the new Place obejct back to the View Controller
    */
    static func fetchPlaces(keyword: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping ([Place]?) -> Void){

        
        let url = GoogleAPI.placeSearchURL(keyword: keyword, latitude: latitude, longitude: longitude)
        //now we want to get Data back from a request using this url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //closure executes when this task gets a response back from the server
            if let data = data, let dataString = String(data: data, encoding: .utf8){
                //print(dataString)
                if let retrievedPlaces = place(fromData: data){

                    DispatchQueue.main.async {
                        completion(retrievedPlaces)
                    }
                    //should also call completion(nil) on failure
                }
                
            } else{
                if let error = error{
                    print("error getting JSON response \(error)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                    
                }
            }
        }
        
        
        task.resume()
    }
    
    /**
     Used to parse the JSON text from the API request into usable values. A new place object is returned
     - Parameter data: a Data object with the JSON data
     - returns: an optional place object storing the data of the API request. If null, an error occurred
    */
    static func place(fromData data: Data) -> [Place]?{
        //return nil if we fail to parse the JSON in data
        
       
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            //now convert this object to a dictionary
            guard let jsonDictionary = jsonObject as? [String: Any] else {
                print("error parsing JSON - jsonDictionary")
                return nil
            }
            //print("jsonDictionary: \(jsonDictionary)")
            guard let placesArrayJSON = jsonDictionary["results"] as? [[String: Any]] else{
                print("error parsing JSON - placesArrayJSON")
                return nil
            }

            var placesArray = [Place]()
            for placesJSON in placesArrayJSON{
                //goal is to try and get an InterestingPhoto for each photoJSON
                //task: call interestingPhoto(fromJSON:)
                //if the return value is not nil, put it in array [InterestingPhoto]
                
                if let place = place(fromJSON: placesJSON){
                    //append
                    placesArray.append(place)
                }
            }
            if !placesArray.isEmpty{
                return placesArray
            }
            
        }catch{
            print("error getting a JSON object \(error)")
        }
        return nil
    }
    
    /**
     Used to parse for data in a String : Any dictionary. A new optional Place object may be returned with values from the dictionary.
     - Parameter json: a dictionary with values from the API request
     - returns: if an error occurs nil will be returned, otherwise a Place object
    */
    static func place(fromJSON json: [String: Any]) -> Place?{
        
        print("element JSON: \(json)")
        guard let id = json["place_id"] as? String, let name = json["name"] as? String, let vicinity = json["vicinity"] as? String, let rating = json["rating"] as? Double else{
            print("error parsing place")
            return nil
        }
        print("name: \(name)")
        
        guard let photosArray = json["photos"] as? [[String: Any]], let photo0 = photosArray[0] as? [String: Any], let photoReferenceText = photo0["photo_reference"] as? String else {
            print("error parsing photo regerence")
            return nil
        }
        
        print("photo reference text: \(photoReferenceText)")

        return Place(id: id, name: name, vicinity: vicinity, rating: rating, photoReference: photoReferenceText)
        
        
    }
    
   
 
}
