
/*
 Description: This file is the ViewController for the NearMe PlaceTableViewScreen. It provides functionality for the PlaceTableView UI elements and manipultes the model data as necessary.
 Course: CPSC 315
 Assignment number:  Programming Assignment #8
 Sources: N/A
 Sammy Vowles and Emma Wooburn
 November 29, 2018 - Version 1
 */
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

/**
 This class is the View Controller of the ViewController for the NearMe PlaceTableViewScreen. It provides functionality for the PlaceTableView UI elements and manipultes the model data as necessary.
 */
class PlaceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate {
    
    //properties and outlets
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
     Populates the tableview with places in the array by filling each cell with the place
     
     - Parameter tableView: the table view that holds the results from the search
     - Parameter indexPath: the row in the table view's index
     - Returns: A UITableViewCell in the table view
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceTableViewCell
        let place = placesArray[indexPath.row]
        cell.update(with: place)
        return cell
    }
    
    /**
     The function that is called when the user segues from the main screen to the detailed view controller screen
     
     - Parameter segue: the segue from one view controller to another
     - Parameter sender: the thing that initiates the segue
     */
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
    
    /**
     Used to set up the location services using the location manager object. The set up includes setting a delegate, accuracy, request for location use and begins updating the user's location
    */
    func setupLocationServices(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    /**
     Sets the latitude and longitude values to the user's current latitude and longitude coordinataes
     - Parameter manager: the location manager of the file
     - Parameter locations: array of CLLocation objects of the user's location.
    */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitude = locations[0].coordinate.latitude
        self.longitude = locations[0].coordinate.longitude
    }
    
    /**
     Prints the error
     - Parameter manager: the location manager of the project
     - Parameter error: an Error object of the current error
    */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        //0 location unknown
        //1 deny
    }
    
    /**
     Executed when the "Search" button of the search bar keyboard is selected. Executing the request to the GoogleAPI.
     - Parameter searchBar: the search bar in the UI
    */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        locationManager.stopUpdatingLocation()
        
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
    
    /**
     Executes when the Cancel button of a search bar is selected. This clears the places array and search bar text
     - Parameter searchBar: the search bar object intereacted with by the user
    */
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        placesArray = []
        tableView.reloadData()
    }
    
    /**
     Executes when the text of the search bar changes.
     - Parameter searchBar: the search bar object receiving text
     - Parameter searchText: a String value of the text in the search bar
    */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            placesArray = []
            tableView.reloadData()
        }
    }
    
   
    /**
     Updates the user's location when the refresh button is seleced.
     - Parameter sender: the refresh bar button item
    */
    @IBAction func refreshLocationButtonClicked(sender: UIBarButtonItem){
        locationManager.startUpdatingLocation()
    }
}


