//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Fırat AKBULUT on 22.10.2023.
//

import Foundation
import UIKit

class PlaceModel{
    
    static let sharedInstance = PlaceModel()

    private init(){
    }
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
}
