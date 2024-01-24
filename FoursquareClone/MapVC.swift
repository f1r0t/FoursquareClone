//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Fırat AKBULUT on 21.10.2023.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var placeModel = PlaceModel.sharedInstance
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let locationRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectLocation(gestureRecognizer:)))
        locationRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(locationRecognizer)
    }
    
    @objc func selectLocation(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            let touches = gestureRecognizer.location(in: mapView)
            let coordinates = mapView.convert(touches, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            mapView.addAnnotation(annotation)
            
            placeModel.placeLatitude = String(coordinates.latitude)
            placeModel.placeLongitude = String(coordinates.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpeg", data: imageData)
        }
        
        object.saveInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "fromMaptoPlaces", sender: self)
            } else {
                if let e = error {
                    self.makeAlert(title: "Error", message: e.localizedDescription)
                }
            }
        }

    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

