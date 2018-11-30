/*
 Description: This file is the allows use of the Place Details Google API. Values are retreived from the API using JSON. To use the values, the JSON is parsed. The values on the JSON are returned from the fetchPlaces method.
 Course: CPSC 315
 Assignment number:  Programming Assignment #8
 Sources: N/A
 Sammy Vowles and Emma Wooburn
 November 29, 2018 - Version 1
 
 */
//
//  GoogleSwiftDetailsAPI.swift
//  PA8
//
//  Created by Emma Woodburn on 11/28/18.
//  Copyright © 2018 Emma Woodburn. All rights reserved.
//

import Foundation


import Foundation
import CoreLocation
import UIKit

/**
 This class allows use of the Place Details Google API. Values are retreived from the API using JSON. To use the values, the JSON is parsed. The values on the JSON are returned from the fetchPlaces method.
 */
class GoogleSwiftDetailsAPI{
    //property initialization
    static let apiKey = "AIzaSyCzGQuL6O6-zw2kD19bFB79b7wKS8e9uww"
    static let baseURL = "https://maps.googleapis.com/maps/api/place/details/json?parameters"
    
    static var formattedAdress = ""
    static var openingHours = ""
    static var review = ""
    static var formattedPhoneNumber = ""
    
    /**
     This method is used to execute a request to the Place Details Google API using the provided parameters. The JSON result is provided in a given URL.
     - Parameter placeId: a String of the placeID of the current Place
     - Returns: the url of the JSON returned by the API
     */
    static func placeDetailsSearchURL(placeId: String) -> URL{
        let params = [
            //"output": "json",
            "placeid": "\(placeId)",
            //"fields" : "formatted_address,opening_hours,review,formatted_phone_number",
            "fields" : "formatted_phone_number,formatted_address,opening_hours,reviews",
            "key": GoogleSwiftDetailsAPI.apiKey
        ]
        
        var queryItems = [URLQueryItem]()
        for (key, value) in params{
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        var components = URLComponents(string: GoogleSwiftDetailsAPI.baseURL)!
        components.queryItems = queryItems
        let url = components.url!

        return url
    }
    
    /**
     This method is used to parse through the JSON included in the url of the Place Details Google API. A new Place object is created and returned.
     - Parameter id: a String of the placeID of the current Place
     - Parameter completion: a closure used to pass the String values retreived from the API back to the View Controller
     */
    static func fetchDetailsPlaces(id: String, completion: @escaping (String, String, String, String) -> Void){
        let url = GoogleSwiftDetailsAPI.placeDetailsSearchURL(placeId: id)
        print("url: \(url)")
        //now we want to get Data back from a request using this url

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //closure executes when this task gets a response back from the server
            if let data = data, let dataString = String(data: data, encoding: .utf8){
                print(dataString)
                if let retrievedDetails = placeDetails(fromData: data){

                    DispatchQueue.main.async {
                        completion(self.formattedAdress, self.formattedPhoneNumber, self.openingHours, self.review)
                        
                        
                    }
                    //should also call completion(nil) on failure
                }
                
            } else{
                if let error = error{
                    print("error getting JSON response \(error)")
                }
                DispatchQueue.main.async {
                    completion("", "", "", "")
                    
                }
            }
        }
        task.resume()
    }
    
    
    /**
     Used to parse the JSON text from the API request into usable values. A new place object is returned.
     - Parameter data: a Data object with the JSON data
     - returns: an optional String array object storing the data of the API request. If null, an error occurred
     */
    static func placeDetails(fromData data: Data) -> [String]?{
        //return nil if we fail to parse the JSON in data
    
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            //now convert this object to a dictionary
            guard let jsonDictionary = jsonObject as? [String: Any] else {
                print("error parsing JSON - jsonDictionary")
                return nil
            }
            
            print("jsonDcitionary: \(jsonDictionary.description)")
            
            guard let resultDictionaryJSON = jsonDictionary["result"] as? [String: Any] else{
                print("error parsing JSON - resultArrayJSON")
                return nil
            }
            print("resultDictionaryJSON: \(resultDictionaryJSON)")

            
            guard let formattedPhoneNumberArrayJSON = resultDictionaryJSON["formatted_phone_number"] as? String else{
                print("error parsing JSON - formattedPhoneNumber")
                return nil
            }
            
            print("formattedPhoneNumberArrayJSON: \(formattedPhoneNumberArrayJSON)")
            self.formattedPhoneNumber = formattedPhoneNumberArrayJSON
            
            guard let formattedAddressJSON = resultDictionaryJSON["formatted_address"] as? String else {
                print("error parsing JSON - formattedAddress")
                return nil
            }
            print("formattedAddress: \(formattedAddressJSON)")
            self.formattedAdress = formattedAddressJSON
            
            guard let openingHoursDict = resultDictionaryJSON["opening_hours"] as? [String:Any], let openNowValue = openingHoursDict["open_now"] as? Bool else {
                print("error parsing JSON - opening hours")
                return nil
            }
            print("opening hours: \(openNowValue)")
            self.openingHours = String(openNowValue)
            
            guard let reviewArray = resultDictionaryJSON["reviews"] as? [[String:Any]] else {
                print("error parsing JSON - review array")
                return nil
            }
            print("reveiw Array: \(reviewArray)")
            
            guard let firstReview = getReviewText(fromJSON: reviewArray[0]) as? String else {
                print ("error parsing JSON - review text")
                return nil
            }
            
            print("reveiw text: \(firstReview)")
            self.review = firstReview
            
            var placeDetailsArray = [String]()
            
            placeDetailsArray.append(formattedPhoneNumberArrayJSON)
            placeDetailsArray.append(formattedAddressJSON)
            placeDetailsArray.append(String(openNowValue))
            placeDetailsArray.append(firstReview)
            return placeDetailsArray
            //array of json objects
            //print("count: \(placeDetailsArrayJSON.count)")
            /*
            for placeDetailsJSON in jsonDictionary{
                //goal is to try and get an InterestingPhoto for each photoJSON
                //task: call interestingPhoto(fromJSON:)
                //if the return value is not nil, put it in array [InterestingPhoto]
                
                
                if let details = details(fromJSON: placeDetailsJSON){
                    print("got a place back!")
                    //append
                    placeDetailsArray = details
                }

                
            }
            if !placeDetailsArray.isEmpty{
                return placeDetailsArray
                
            }
 */
 
            
        }catch{
            print("error getting a JSON object \(error)")
        }
        
        return nil
    }
    
    /**
     Used to retreive the value of the  "text" form the json dictionary.
     - Parameter json: the String : Any dictionary fromt eh JSON text
     - returns: A string if the text value is present, otherwise nil
     
     */
    static func getReviewText(fromJSON json: [String:Any]) -> String?{
        guard let reviewText = json["text"] as? String else{
            print("error parsing text")
            return nil
        }
        return reviewText

        
        
    }
 
}
