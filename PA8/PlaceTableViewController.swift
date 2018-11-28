//
//  ViewController.swift
//  PA8
//
//  Created by Emma Woodburn and Sammy Vowles on 11/25/18.
//  Copyright © 2018 Emma Woodburn. All rights reserved.
//

import UIKit
import CoreLocation
//

class PlaceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var placesArray = [Place]()
    @IBOutlet var tableView: UITableView!
    var isFiltered = false
    var filteredPlaces = [Place]()
    let locationManager = CLLocationManager()


    override func viewDidLoad() {
        super.viewDidLoad()
        help()

        print(placesArray)
        //check to make sure the user has location enabled
        if CLLocationManager.locationServicesEnabled(){
            print("location services enabled")
            setupLocationServices()
            
        } else{
            print("location services disabled")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return placesArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceTableViewCell
        if isFiltered == true{
            let place = filteredPlaces[indexPath.row]
            cell.update(with: place)
        }else{
            let place = placesArray[indexPath.row]
            cell.update(with: place)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let identifier = segue.identifier{
            if identifier == "DetailSegue"{
                var cellIndex = tableView.indexPathForSelectedRow
                if let index = cellIndex{
                    let selectedPlace = placesArray[index.row]
                    if let detailVC = segue.destination as? PlaceDetailViewController{
                        detailVC.place = selectedPlace
                    }
                }
            }
        }
    }
    
    func help(){
        var testerPlace = Place(id: "1", name: "emma", vicinity: "hi", rating: 5.0)
        placesArray.append(testerPlace)
        var testerPlace2 = Place(id: "5", name: "sammy", vicinity: "near", rating: 5.0)
        placesArray.append(testerPlace2)
    }
    
    func setupLocationServices(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geocoder = CLGeocoder()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        //0 location unknown
        //1 deny
    }
}

extension PlaceTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        //exercises.filter { $0.name == searchText }
        let filtered = placesArray.filter { $0.name == searchText }
        print(filteredPlaces)
        filteredPlaces = filtered
        if filteredPlaces.count == 0{
            isFiltered = false
        } else{
            isFiltered = true
        }
        tableView.reloadData()
    }
    
    func performSearch(searchBar: UISearchBar){
        if let text =  searchBar.text {
            let textPredicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
            
        }
    }
    


}

