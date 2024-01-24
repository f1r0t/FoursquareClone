//
//  PlacesViewController.swift
//  FoursquareClone
//
//  Created by Fırat AKBULUT on 21.10.2023.
//

import UIKit
import Parse

class PlacesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromParse()
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { (objects, error) in
            if let e = error {
                self.makeAlert(title: "Error", message: e.localizedDescription)
            } else if let objects = objects {
                
                self.placeNameArray.removeAll(keepingCapacity: false)
                self.placeIdArray.removeAll(keepingCapacity: false)
               
                for object in objects {
                    if let placeName = object.object(forKey: "name") as? String {
                        if let placeId = object.objectId {
                            self.placeNameArray.append(placeName)
                            self.placeIdArray.append(placeId)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toAddPlace", sender: self)
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        PFUser.logOutInBackground { error in
            if let e = error {
                self.makeAlert(title: "Error!", message: e.localizedDescription)
            } else{
                self.performSegue(withIdentifier: "toSignInVC", sender: self)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesCell", for: indexPath)
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.selectedPlaceId = selectedPlaceId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: self)
    }
    
}
