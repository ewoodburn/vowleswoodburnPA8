//
//  Place.swift
//  PA8
//
//  Created by Emma Woodburn on 11/25/18.
//  Copyright © 2018 Emma Woodburn. All rights reserved.
//

import Foundation

struct Place{
    var id: String
    var name: String
    var vicinity: String
    var rating: Double
    
    static let apiKey = "AIzaSyCzGQuL6O6-zw2kD19bFB79b7wKS8e9uww"
    static let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/output?parameters"
    
    static func placeSearchURL() -> URL{
        let params = [
            "key": Place.apiKey,
            "location": "latitude,longitude",
            "radius": "10 000 meters",
            "keyword": "type"
            
        ]
        
        var queryItems = [URLQueryItem]()
        for (key, value) in params{
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        var components = URLComponents(string: Place.baseURL)!
        components.queryItems = queryItems
        let url = components.url!
        print(url)
        return url
    }
    
    static func fetchPlaces(completion: @escaping ([Place]?) -> Void){
        let url = Place.placeSearchURL()
        //now we want to get Data back from a request using this url
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            //closure executes when this task gets a response back from the server
            if let data = data, let dataString = String(data: data, encoding: .utf8){
                print(dataString)
                if let retrievedPlaces = {
                    print("")
                    print("Successfully got the array of InterestingPhotos")
                    //goal is to get this array back to ViewController so it can update the UI
                    //PROBLEMS
                    //MARK: - Threads
                    //so far, our code in ViewController for example runs on the main UI thread
                    //the main UI thread listens for user interaction, calls callbacks in view controllers and in delegates
                    //long running tasks/code should not run on the mainUI thread
                    //we don't want the UI thread to wait for long running code cause it will become unresponsive
                    //by default, URLSession dataTasks run on a background thread
                    //this code right here is not running on the main UI thread!
                    //this closure runs asynchronously
                    //viewDidLoad() doesn't wait for this closure to return a value
                    //fetchInterestingPhotos() starts the data task and immediatly returns
                    //we can't return the [InterestingPhoto] array from fetchInterestingPhotos() becayse it will have already returned
                    //we need a completion closure to execute later... when we have a result!
                    //cal this on the main UI thread
                    //a thread in iOS is managed by a queue
                    DispatchQueue.main.async {
                        completion(interestingPhotos)
                        
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
            guard let jsonDictionary = jsonObject as? [String: Any], let placeObject = jsonDictionary["places"] as? [String: Any], let placesArray = placeObject["place"] as? [[String: Any]] else{
                print("error parsing JSON")
                return nil
            }
            //we have photoarray!
            //array of json objects
            var placesArr = [Place]()
            for placeJSON in placesArr{
                //goal is to try and get an InterestingPhoto for each photoJSON
                //task: call interestingPhoto(fromJSON:)
                //if the return value is not nil, put it in array [InterestingPhoto]
                if let place = place(fromJSON: placeJSON){
                    print("got a place back!")
                    //append
                    placesArr.append(place)
                }
            }
            if !placesArr.isEmpty{
                return placesArr
                
            }
            
        }catch{
            print("error getting a JSON object \(error)")
        }
        
        return nil
    }
    
    static func place(fromJSON json: [String: Any]) -> Place?{
        guard let id = json["id"] as? String, let title = json["title"] as? String, let dateTaken = json["datetaken"] as? String, let url = json["url_h"] as? String else{
            print("error parsing photo")
            return nil
        }
        print(id)
        print(title)
        print(dateTaken)
        print(url)
        //var newPhoto = InterestingPhoto.init(id: id, title: title, dateTaken: dateTaken, photoURL: url)
        //task: grab the title, datetaken, url
        //return an InterestingPhoto
        return InterestingPhoto(id: id, title: title, dateTaken: dateTaken, photoURL: url)
        
        //return newPhoto
        
    }
    
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

}
