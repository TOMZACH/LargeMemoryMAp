//
//  ImageAnnotationView.swift
//  CustomMapAnnotationViewClusteringFix
//
//  Created by 123456 on 8/28/19.
//  Copyright © 2019 123456. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class ImageAnnotation:NSObject,MKAnnotation{
    
    var title: String?
    var locationName:String
    var coordinate: CLLocationCoordinate2D
    var photoURL:URL?
    var image:UIImage?
    
    init(title:String, locationName:String, coordinate:CLLocationCoordinate2D, photoURL:URL? = nil, image:UIImage? = nil){
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        self.photoURL = photoURL
        self.image = image
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
}
