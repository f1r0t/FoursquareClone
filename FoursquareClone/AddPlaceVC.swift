//
//  AddPlaceVC.swift
//  FoursquareClone
//
//  Created by Fırat AKBULUT on 21.10.2023.
//

import UIKit
import Photos

class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var placeNameText: UITextField!
    
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeAtmosphereText: UITextField!
    @IBOutlet weak var placeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        placeImageView.addGestureRecognizer(tapGesture)

    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            placeImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            placeImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        if let name = placeNameText.text, !name.isEmpty, let type = placeTypeText.text, !type.isEmpty, let atmosphere = placeAtmosphereText.text, !atmosphere.isEmpty, let image = placeImageView.image{
            let placeModel = PlaceModel.sharedInstance
            placeModel.placeName = name
            placeModel.placeType = type
            placeModel.placeAtmosphere = atmosphere
            placeModel.placeImage = image
            performSegue(withIdentifier: "toMapVC", sender: self)
        } else {
            makeAlert(title: "Error", message: "Please enter empty text fields")
        }
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
