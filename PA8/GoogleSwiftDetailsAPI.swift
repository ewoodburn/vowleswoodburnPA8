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
            //"fields" : "formatted_phone_number",
            "key": GoogleSwiftDetailsAPI.apiKey
        ]
        
        var queryItems = [URLQueryItem]()
        for (key, value) in params{
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        var components = URLComponents(string: GoogleSwiftDetailsAPI.baseURL)!
        components.queryItems = queryItems
        let url = components.url!
        print("URL: \(url)")

        return url
    }
    
    static func fetchDetailsPlaces(id: String, completion: @escaping (String, String, String, String) -> Void){
        
        print("fetchPlaces -")
        print("id: \(id)")
        
        let url = GoogleSwiftDetailsAPI.placeDetailsSearchURL(placeId: id)
        //now we want to get Data back from a request using this url

        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //closure executes when this task gets a response back from the server
            if let data = data, let dataString = String(data: data, encoding: .utf8){
                print(dataString)
                if let retrievedDetails = placeDetails(fromData: data){
                    print("")
                    print("Successfully got the place details")
                    print("")
                    DispatchQueue.main.async {
                        completion(self.formattedAdress, self.openingHours, self.review, self.formattedPhoneNumber)
                        
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
    
    
    
    
    
    
    
    
    //COME BACK HERE
    
    
    
    
    
    
    
    
    
    static func placeDetails(fromData data: Data) -> [Place]?{
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
            print("jsonDictionary: \(jsonDictionary)")
            guard let placeDetailsArrayJSON = jsonDictionary["results"] as? [[String: Any]] else{
                print("error parsing JSON - placeDetailsArrayJSON")
                return nil
            }
            print("placeDetailsArrayJSON: \(placeDetailsArrayJSON)")
            //we have photoarray!
            //array of json objects
            var placesArray = [Place]()
            /*
            for placesJSON in placesArrayJSON{
                //goal is to try and get an InterestingPhoto for each photoJSON
                //task: call interestingPhoto(fromJSON:)
                //if the return value is not nil, put it in array [InterestingPhoto]
                
                if let place = place(fromJSON: placesJSON){
                    print("got a place back!")
                    //append
                    placesArray.append(place)
                }
                
            }
            if !placesArray.isEmpty{
                return placesArray
                
            }
 */
            
        }catch{
            print("error getting a JSON object \(error)")
        }
        
        return nil
    }
    
    /*
    static func place(fromJSON json: [String: Any]) -> Place?{
        guard let id = json["id"] as? String, let name = json["name"] as? String, let vicinity = json["vicinity"] as? String, let rating = json["rating"] as? Double else{
            print("error parsing photo")
            return nil
        }
        print("id: \(id)")
        print("name: \(name)")
        print("vicinity: \(vicinity)")
        print("rating: \(rating)\n")
        //var newPhoto = InterestingPhoto.init(id: id, title: title, dateTaken: dateTaken, photoURL: url)
        //task: grab the title, datetaken, url
        //return an InterestingPhoto
        return Place(id: id, name: name, vicinity: vicinity, rating: rating)
        
        //return newPhoto
        
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
 */
}
