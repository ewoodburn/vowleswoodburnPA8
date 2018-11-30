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

class GoogleSwiftDetailsAPI{
    static let apiKey = "AIzaSyCzGQuL6O6-zw2kD19bFB79b7wKS8e9uww"
    static let baseURL = "https://maps.googleapis.com/maps/api/place/details/json?parameters"
    
    static var formattedAdress = ""
    static var openingHours = ""
    static var review = ""
    static var formattedPhoneNumber = ""
    
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
    
    
    /*
     okay here's what's going on
     this json response is set up differently than the 
 */
    
    static func placeDetails(fromData data: Data) -> [String]?{
        //return nil if we fail to parse the JSON in data
        
        //MARK: - JSON stands for javascript object notation
        //JSON is ocmmonly used to pass aroud data around the web
        //JSON is really just a dictionary
        //keys are strings
        //values are strings, nested JSON objects, arrays, numbers, bools, etc.
        //our goal is to convert the Data object into an [String: Any] - a dictionary representing our JSON object
        //swiftyJSON makes this process much simpler...
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
    
    
    static func getReviewText(fromJSON json: [String:Any]) -> String?{
        guard let reviewText = json["text"] as? String else{
            print("error parsing text")
            return nil
        }
        return reviewText

        
        
    }
 
    
    /*
     static func fetchPlace(fromUrlString: String, completion: @escaping (UIImage?) -> Void){
     let url = URL(string: fromUrlString)!
     let taskSession = URLSession.shared.dataTask(with: url) { (data, response, error) in
     if let data = data, let image = UIImage(data: data){
     DispatchQueue.main.async {
     print("we got an image")
     completion(image)
     }
     } else{
     if let error = error{
     print("error getting an image")
     }
     DispatchQueue.main.async {
     completion(nil)
     }
     }
     }
     taskSession.resume()
     
     }
     */
}
