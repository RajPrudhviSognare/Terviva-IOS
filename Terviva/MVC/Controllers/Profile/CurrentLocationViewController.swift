//
//  CurrentLocationViewController.swift
//  Smartrac-Grohe
//
//  Created by Happy on 20/06/22.
//

import UIKit
import MapKit

class CurrentLocationViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    //MARK:- Variables
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    //MARK:- ViewDidLaod MEthod
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK:- Back Button Tapped
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        self.latitudeLabel.text = "Latitude: \(lat.description)"
        self.longitudeLabel.text = "Longitude: \(long.description)"
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                
                print("placemarks",placemarks!)
                let pm = placemarks?[0]
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(_ placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            
            print("your location is:-",containsPlacemark)
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            self.placeLabel.text = "Location: \n\nCity: \(locality ?? ""), \nCountry:  \(country ?? ""), \nPincode: \(postalCode ?? "")"
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
}
