//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Fırat AKBULUT on 21.10.2023.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeAtmosphereLabel: UILabel!
    @IBOutlet weak var mapKitView: MKMapView!
    
    var selectedPlaceId = ""
    var selectedLatitude = Double()
    var selectedLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapKitView.delegate = self
        getDataFromParse()
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: selectedPlaceId)
        query.findObjectsInBackground { (objects, error) in
            if let e = error {
                self.makeAlert(title: "Error", message: e.localizedDescription)
            } else if let objects = objects {
                let selectedObject = objects[0]
                if let placeName = selectedObject.object(forKey: "name") as? String{
                    self.placeNameLabel.text = placeName
                }
                if let placeType = selectedObject.object(forKey: "type") as? String{
                    self.placeTypeLabel.text = placeType
                }
                if let placeatmosphere = selectedObject.object(forKey: "atmosphere") as? String{
                    self.placeAtmosphereLabel.text = placeatmosphere
                }
                if let placelatitude = selectedObject.object(forKey: "latitude") as? String {
                    if let placelatitudeDouble = Double(placelatitude){
                        self.selectedLatitude = placelatitudeDouble
                    }
                }
                if let placelongitude = selectedObject.object(forKey: "longitude") as? String {
                    if let placelongitudeDouble = Double(placelongitude){
                        self.selectedLongitude = placelongitudeDouble
                    }
                }
                if let imageData = selectedObject.object(forKey: "image") as? PFFileObject{
                    imageData.getDataInBackground { data, error in
                        if let e = error{
                            self.makeAlert(title: "Error", message: e.localizedDescription)
                        } else if let data = data {
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                }
                let location = CLLocationCoordinate2D(latitude: self.selectedLatitude, longitude: self.selectedLongitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                let region = MKCoordinateRegion(center: location, span: span)
                self.mapKitView.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = self.placeNameLabel.text
                annotation.subtitle = self.placeTypeLabel.text
                self.mapKitView.addAnnotation(annotation)
                
            }
        }
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .infoDark)
            pinView?.rightCalloutAccessoryView = button
        } else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if selectedLatitude != 0.0 && selectedLongitude != 0.0{
            let request = CLLocation(latitude: selectedLatitude, longitude: selectedLongitude)
            CLGeocoder().reverseGeocodeLocation(request) {(placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0{
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.placeNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
}
