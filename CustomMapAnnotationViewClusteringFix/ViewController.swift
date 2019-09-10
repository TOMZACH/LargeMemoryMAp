//
//  ViewController.swift
//  CustomMapAnnotationViewClusteringFix
//
//  Created by 123456 on 8/28/19.
//  Copyright © 2019 123456. All rights reserved.
//

import Foundation
import MapKit
import SDWebImage

class MapViewController:UIViewController{
    
    var mapView:MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    var searchThisAreaButton:UIButton = {
        let button = UIButton()
        button.setTitle("Search This Area", for: .normal)
        button.backgroundColor = UIColor.blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.reuseIdentifier)
        mapView.register(AppleCustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "Apple")
        mapView.register(AppleClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ClusterAnnotationView")
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            ])
        
        setUpMapView()
        
        mapView.addSubview(searchThisAreaButton)
        NSLayoutConstraint.activate([
            searchThisAreaButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            searchThisAreaButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            searchThisAreaButton.heightAnchor.constraint(equalToConstant: 40),
            searchThisAreaButton.widthAnchor.constraint(equalToConstant: 100)
            ])
        searchThisAreaButton.addTarget(self, action: #selector(searchThisArea), for: .touchUpInside)
    }
    
    func setUpMapView(){
        let initialLocation = CLLocation(latitude: 40.758896, longitude: -73.985130)
        let empireStateBuidlingLatLong = CLLocationCoordinate2D(latitude: 40.748817, longitude: -73.985428)
        let oneWorldTradeLatLong = CLLocationCoordinate2D(latitude: 40.712742, longitude: -74.013382)
        let grandCentralLatLong = CLLocationCoordinate2D(latitude:     40.752655, longitude: -73.977295)
        let centralParkLatLong = CLLocationCoordinate2D(latitude: 40.785091, longitude: -73.968285)
        let chryslerLatLong = CLLocationCoordinate2D(latitude: 40.751652, longitude: -73.975311)
        let timesSquareLatLong =  CLLocationCoordinate2D(latitude:     40.758896, longitude: -73.985130)
        let nycLatLong = CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242)
        let regionRadius: CLLocationDistance = 1000
        
        
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        let empireStateBuildingAnnotation = ImageAnnotation(title: "The Empire State Building", locationName: "The Empire State Building", coordinate: empireStateBuidlingLatLong,photoURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/10/Empire_State_Building_%28aerial_view%29.jpg"))
        
        let oneWorldTradeAnnotation = ImageAnnotation(title: "One World Trade Center", locationName: "One World Trade Center", coordinate: oneWorldTradeLatLong, photoURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/a/a1/One_World_Trade_Center_May_2015.jpg"))
        
        let grandCentralAnnotation = ImageAnnotation(title: "Grand Central Station", locationName: "Grand Central Station", coordinate: grandCentralLatLong,photoURL: URL(string: "https://cdn.vox-cdn.com/thumbor/zzhfRnAuMM5nGExb4anEQtmsH3Y=/0x0:3000x2000/1200x675/filters:focal(1264x69:1744x549)/cdn.vox-cdn.com/uploads/chorus_image/image/62674871/grandcentral_lede.0.jpg"))
        
        let centralParkAnnotation = ImageAnnotation(title: "Central Park", locationName: "Central Park", coordinate: centralParkLatLong,photoURL: URL(string: "https://s3.amazonaws.com/assets.centralparknyc.org/images/about/history/history-1.jpg"))
        
        let chryslerBuildingAnnotation = ImageAnnotation(title: "Chrysler Building", locationName: "Chrysler Building", coordinate: chryslerLatLong,photoURL: URL(string: "https://media.architecturaldigest.com/photos/5c87da67fd05a62d5ad099aa/1:1/w_1992,h_1992,c_limit/GettyImages-182884126.jpg"))
        
        let timesSquareAnnotation = ImageAnnotation(title: "Times Square", locationName: "Times Square", coordinate: timesSquareLatLong, photoURL: URL(string: "https://imgs.6sqft.com/wp-content/uploads/2018/02/20105946/TimesSquare_bright.jpg"))
        
        
        
        mapView.addAnnotations([empireStateBuildingAnnotation,oneWorldTradeAnnotation,grandCentralAnnotation,centralParkAnnotation,chryslerBuildingAnnotation,timesSquareAnnotation])
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
    }
    
    @objc func searchThisArea(){
        print("search this area tapped")
        let center = mapView.centerCoordinate
        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        print("mapview center: \(mapView.centerCoordinate)")
        print("user location: \(mapView.userLocation.coordinate)")
        let userDistance = mapView.userLocation.location?.distance(from: centerLocation)
        print("userDistance: \(userDistance)")
    }
    
}

extension MapViewController:MKMapViewDelegate{
    
    var placeHolder:UIImage{
        return #imageLiteral(resourceName: "DSC00042")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        if let annotation = annotation as? ImageAnnotation{
            
            guard let annotationView:CustomAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.reuseIdentifier, for: annotation) as? CustomAnnotationView else{
                fatalError("Unexpected Type of Annotation")
            }
            annotationView.annotation = annotation

            annotationView.testImageView.sd_setImage(with: annotation.photoURL, placeholderImage: placeHolder, options: SDWebImageOptions.refreshCached, completed: {(image,error,imageCacheType,storageReference) in
                if let error = error{
                    print("Uh-Oh an error has occured: \(error.localizedDescription)" )
                }
                annotation.image = image
            })
            
//            guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Apple", for: annotation) as? AppleCustomAnnotationView else{
//                fatalError("Unexpected annotation view type")
//            }
//            annotationView.annotation = annotation
            annotationView.clusteringIdentifier = MKMapViewDefaultClusterAnnotationViewReuseIdentifier
            annotationView.collisionMode = .rectangle
            return annotationView
        }else if let cluster = annotation as? MKClusterAnnotation{
            guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: "ClusterAnnotationView", for: annotation) as? AppleClusterAnnotationView else{
                fatalError("Wrong type for cluster annotationview")
            }
//            guard let view = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier, for: cluster) as? MKMarkerAnnotationView else{
//                fatalError("Unexpected type")
//            }
//            print("cluster called")
//            view.annotation = cluster
//            view.markerTintColor = UIColor.green
            view.canShowCallout = false
            return view
        }
        return nil
    }
    
}


