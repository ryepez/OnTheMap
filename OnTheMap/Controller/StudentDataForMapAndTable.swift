//
//  StudentDataForMapAndTable.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/14/21.
//

import Foundation
import MapKit


class StudentDataForMapAndTable {
    
    class func studentFormatedData() -> [MKPointAnnotation] {
        
        let locations = DataModel.studentLocations
        var annotations = [MKPointAnnotation]()
        
        for dictionary in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        return annotations
    }
    
}
