//
//  MovieLocationViewController.swift
//  MovieCatalog
//
//  Created by vlaghane on 12/3/17.
//  Copyright © 2017 Drones. All rights reserved.
//

import UIKit
import MapKit

//Location controller 
class MovieLocationViewController: UIViewController {

    public var titleLabel = "MovieTitle"
    public var locationAddress = "Address"
    var lat : Double = 0
    var long :Double = 0 
    
    @IBOutlet weak var mapV: MKMapView!
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocation()
//        Then handle the results of the query using the MKLocalSearchCompleterDelegate:
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func setLocation(){

        let location = locationAddress + Constants.city + Constants.state //+ Constants.zip
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let mark = MKPlacemark(placemark: placemark)

                if var region = self?.mapV.region {
                    region.center = location.coordinate
                    region.span.longitudeDelta /= 8.0
                    region.span.latitudeDelta /= 8.0
                    self?.mapV.setRegion(region, animated: true)
                    self?.mapV.addAnnotation(mark)
                }
            }
        }
    }
    
        /*
        func setLocation(){
            let location = locationAddress + Constants.city + Constants.state //+ Constants.zip
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString((location), completionHandler: {(placemarks, error) -> Void in
                
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    coordinates.latitude
                    coordinates.longitude
                    
                    
                    self.lat = coordinates.latitude
                    self.long = coordinates.longitude
                    print("lat \(self.lat)")
                    print("long \(self.long)")
                }
            })
        }
    */
    
//    func  setLocation(){
//        let location = locationAddress + Constants.city + Constants.state //+ Constants.zip
//        let geocoder = CLGeocoder()
//
//
//    geocoder.geocodeAddressString(location, completionHandler: {(placemarks, error) -> Void in
//    if((error) != nil){
//    print("Error", error)
//    }
//    if let placemark = placemarks?.first {
//    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
//    self.mapV.addAnnotation(MKPlacemark(placemark: placemark))
//        }
//    })
//
//    }
        
        /*
         
         // 1)
         mapV.mapType = MKMapType.standard
         
         // 2)
         let location = CLLocationCoordinate2D(latitude: 23.0225,longitude: 72.5714)
         
         // 3)
         let span = MKCoordinateSpanMake(0.05, 0.05)
         let region = MKCoordinateRegion(center: location, span: span)
         mapV.setRegion(region, animated: true)
         
         // 4)
         
         
         let annotation = MKPointAnnotation()
         annotation.coordinate = location
         annotation.title = titleLabel
         annotation.subtitle = "San Francisco"
         mapV.addAnnotation(annotation)
         
 
 */
    //}
  
}


