//
//  ViewController.swift
//  GoogleSDk_ demo
//
//  Created by Rajat Bhatt on 12/07/17.
//  Copyright © 2017 Rajat Bhatt. All rights reserved.
//

import UIKit
import GooglePlaces

class ViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var placesClient: GMSPlacesClient!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        placesClient = GMSPlacesClient.shared()
    }
    
    @IBAction func searchLocation(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func getCurrentLocation(_ sender: UIButton) {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        print("Latitude: \(place.coordinate.latitude), Longitude: \(place.coordinate.longitude)")
        print("PlaceID: \(place.placeID)")
        
        //Place description from place ID
        placesClient.lookUpPlaceID(place.placeID, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details")
                return
            }
            print("-----------------------------------")
            print("Place name \(String(describing: place.name))")
            print("Place address \(String(describing: place.formattedAddress))")
            print("Place placeID \(String(describing: place.placeID))")
            print("Place attributions \(String(describing: place.attributions))")
        })
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
