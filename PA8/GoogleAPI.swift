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

class GoogleAPI{
    static let apiKey = "AIzaSyCzGQuL6O6-zw2kD19bFB79b7wKS8e9uww"
    static let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?parameters"
    
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
    
    
    static func place(fromData data: Data) -> [Place]?{
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
