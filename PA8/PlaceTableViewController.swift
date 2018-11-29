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

class PlaceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {
    
    var placesArray = [Place]()
    @IBOutlet var tableView: UITableView!
    var isFiltered = false
    var filteredPlaces = [Place]()
    let locationManager = CLLocationManager()
    var latitude = CLLocationDegrees()
    var longitude = CLLocationDegrees()
    
    var keyword = ""


    /**
    Checks to see if location services have been enabled and does any other setup that needs to happen when the view loads on the screen.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //check to make sure the user has location enabled
        if CLLocationManager.locationServicesEnabled(){
            print("location services enabled")
            setupLocationServices()
            
        } else{
            print("location services disabled")
        }

    }
    
    /**
     Computes the number of rows that should be displayed in the tableview
     
     - Parameter tableView: the table view that holds the results from the search
     - Parameter numberOfRowsInSection: the number of rows in each section of the tableview
     - Returns: The number of rows in section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return placesArray.count
        }
        return 0
    }
    
    /**
     Computes the number of rows that should be displayed in the tableview
     
     - Parameter tableView: the table view that holds the results from the search
     - Parameter indexPath: 
     - Returns: A UITableViewCell in the table view
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceTableViewCell
        let place = placesArray[indexPath.row]
        cell.update(with: place)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let identifier = segue.identifier{
            if identifier == "DetailSegue"{
                var cellIndex = tableView.indexPathForSelectedRow
                if let index = cellIndex{
                    let selectedPlace = placesArray[index.row]
                    print("og id: \(selectedPlace.id)")
                    if let detailVC = segue.destination as? PlaceDetailViewController{
                        detailVC.place = selectedPlace
                    }
                }
            }
        }
    }
    
    
    func setupLocationServices(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitude = locations[0].coordinate.latitude
        self.longitude = locations[0].coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        //0 location unknown
        //1 deny
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        keyword = searchBar.text!
        if keyword == ""{
            placesArray = []
            tableView.reloadData()
        } else{
            GoogleAPI.fetchPlaces(keyword: keyword, latitude: latitude, longitude: longitude, completion: {(placesOptional) in
                if let placesArr = placesOptional{
                    self.placesArray = placesArr
                    self.tableView.reloadData()
                }
            })
        }
        
        
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        placesArray = []
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            placesArray = []
            tableView.reloadData()
        }
    }
}


