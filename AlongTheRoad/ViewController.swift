//
//  ViewController.swift
//  AlongTheRoad
//
//  Created by Linus Aidan Meyer-Teruel on 8/29/15.
//  Copyright (c) 2015 Linus Aidan Meyer-Teruel. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var startingPoint: UITextField!
    @IBOutlet weak var destination: UITextField!
    
    var coreLocationManager = CLLocationManager()
    var locationManager:LocationManager!
    var currentLocation:CLLocationCoordinate2D!
    
    let routeData = RouteDataModel.sharedInstance
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    var placesClient: GMSPlacesClient?

    @IBAction func goToAutoComplete(sender: UITextField) {
        // specify whether the destination of origin field is clicked
        if (sender.placeholder == "Destination") {
            routeData.isDestination = true;
        } else {
            routeData.isDestination = false;
        }
        performSegueWithIdentifier("autocomplete", sender: nil)
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitRoute(sender: AnyObject) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        startingPoint.text = routeData.startingPoint
        destination.text = routeData.destination
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient()
        println(placesClient == nil)
        
        routeData.startingPoint = "San Francisco"
        routeData.destination = "San Diego"
        
        coreLocationManager.delegate = self
        
        locationManager = LocationManager.sharedInstance
        
        
        let authorizationCode = CLLocationManager.authorizationStatus()
        if authorizationCode == CLAuthorizationStatus.NotDetermined && coreLocationManager.respondsToSelector("requestAlwaysAuthorization") || coreLocationManager.respondsToSelector("requestWhenInUseAuthorization") {
            if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil {
                coreLocationManager.requestAlwaysAuthorization()
            } else {
                getLocation()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.NotDetermined || status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted {
            getLocation()
        }
    }
    
    func getLocation(){
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            self.currentLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.routeData.currentLocation = self.currentLocation
            println("\(self.currentLocation.latitude), \(self.currentLocation.longitude)")
        }
    }
    


}

