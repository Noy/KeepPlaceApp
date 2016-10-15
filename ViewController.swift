//
//  ViewController.swift
//  Memorable Places
//
//  Created by Noy Hillel on 15/04/2016.
//  Copyright © 2016 Inscriptio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/*
    This class represents the map, unlike the PlacesViewController.swift which is our list of places
*/

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    // Creating our map Outlet
    @IBOutlet var map: MKMapView!
    
    // Getting our CLLocationManager variable
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Getting the gesture of Long Pressing, parsing this class and the method we created below
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longpress(gesureRecognizer:)))
        
        // Setting the amount of seconds minumum for when the user presses
        uilpgr.minimumPressDuration = 2
        // Add the gesture
        map.addGestureRecognizer(uilpgr)
        
        // If user presses the '+' button
        if activePlace == -1 {
            // Utils for allowing location services and getting the best accuracy
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        } else {
            // If someone presses anything else
            if places.count > activePlace {
                // If the name is equal to the activePlace name, which we set from the annotation below
                if let name = places[activePlace]["name"] {
                    // Same for latitude
                    if let lat = places[activePlace]["lat"] {
                        // Same for longitude
                        if let lon = places[activePlace]["lon"] {
                            // Here we set the lat to a Double, because it's by default a string
                            if let latitude = Double(lat) {
                                // Same for longitude
                                if let longitude = Double(lon) {
                                    // Get the span, which is how much the screen would be zoomed
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    // Get the coordinates based on our latitude and longitude
                                    let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    // Get our region based on the coordinates and span
                                    let region = MKCoordinateRegion(center: coordinates, span: span)
                                    // Set the region, and the animation to true, because why not, looks smoother :P
                                    self.map.setRegion(region, animated: true)
                                    // Get our annotation (Pin)
                                    let annotation = MKPointAnnotation()
                                    // Set the annotation coordinates the the coordinates which we created above
                                    annotation.coordinate = coordinates
                                    // Set the title of the pin to the name of out location
                                    annotation.title = name
                                    // Add the pin to the map
                                    self.map.addAnnotation(annotation)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Our method for long pressing the screen
    internal func longpress(gesureRecognizer: UIGestureRecognizer) {
        // If the state is began pressing, we check this so as we hold it down, it doesn't keep making more. For example, if I were to drag my finger along, it would keep creating more pins, which is not what we want.
        if gesureRecognizer.state == UIGestureRecognizerState.began {
            // Get the point which we touched
            let touchPoint = gesureRecognizer.location(in: self.map)
            // Create a new coordinate, which is where we touched
            let newCoordinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
            // Get that location, which we touched
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            // Creating our title, which initially is empty
            var title = ""
            
            // Reverse the Geo Location, which essentially means get the location based on the coordinates. We parse a placemark and the error
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                // If there's an error, print it
                if error != nil {
                    print(error)
                } else {
                    // If the placemark is the first placemark
                    if let placemark = placemarks?[0] {
                        // Checking if our thoroughfare exist, the part address we want to get, which you can think of this as just the name of the road
                        if placemark.thoroughfare != nil {
                            // Set the title to that
                            title += placemark.thoroughfare! + ", "
                        }
                        // If the country is the US
                        if placemark.country == "United States" {
                            // Name the state too, why not, right?
                            title += placemark.administrativeArea! + ", "
                        }
                        // If the country actually exists, which in most cases it will...
                        if placemark.country != nil {
                            // Name that country
                            title += placemark.country!
                        }
                        
                    }
                }
                // If there's no title, for example if they press the middle of the desert
                if title == "" {
                    // Set the title to just "added the location with the date" pretty much
                    title = "Added \(NSDate())"
                }
                // Getting the pin
                let annotation = MKPointAnnotation()
                
                // Setting the pin's coordinates to our newCoordinates variable
                annotation.coordinate = newCoordinate
                // Setting the title too
                annotation.title = title
                
                // Adding it to our map
                self.map.addAnnotation(annotation)
                // Add that name to the list
                places.append(["name":title,"lat":String(newCoordinate.latitude),"lon":String(newCoordinate.longitude)])
                // Save it
                UserDefaults.standard.set(places, forKey: "places")
            })
        }
    }
    
    // Locations manager method, pretty much to get the user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get the location based on the latitude and longitude
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        // Get the span based on the zoom rate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        // Get the region based on the location and span
        let region = MKCoordinateRegion(center: location, span: span)
        // Set the region to the region, and of course animate it!
        self.map.setRegion(region, animated: true)
    }
    
    // Util method
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

