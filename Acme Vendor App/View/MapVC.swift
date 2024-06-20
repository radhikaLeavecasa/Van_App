//
//  MapVC.swift
//  Acme Vendor App
//
//  Created by acme on 12/06/24.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    //MARK: - @IBOutlets
    @IBOutlet weak var mapVw: MKMapView!
    //MARK: - Variables
    var locationManager: CLLocationManager = CLLocationManager()
    var viewModel = MapVM()
    var vanNo = String()
    var timer: Timer?
    var status = CLLocationManager.authorizationStatus()
    var currentLocation: CLLocation!
    //MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
      //  locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            // present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
            
//            locationManager.requestAlwaysAuthorization()
//            locationManager.requestWhenInUseAuthorization()
        }
        
        //        locationManager.startUpdatingLocation()
//        locationManager.startUpdatingHeading()
        
        
        //mapview setup to show van's location
        mapVw.delegate = self
//        mapVw.showsUserLocation = true
        mapVw.mapType = MKMapType.standard
//        mapVw.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getLocationDetailsApi("UP87T4275") { val, msg in
            if val {
                let activities = self.viewModel.vanDetail
                // Filter activities based on matching dates (ignoring time)
                let filteredActivities = activities.filter { activity in
                    guard let createdAtString = activity.createdAt else { return false }
                    let activityDate = self.convertStringToDate(createdAtString)
                    
                    let calendar = Calendar.current
                    let currentDate = Date()
                    
                    let activityComponents = calendar.dateComponents([.year, .month, .day], from: activityDate)
                    let currentComponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
                    
                    return activityComponents.year == currentComponents.year &&
                    activityComponents.month == currentComponents.month &&
                    activityComponents.day == currentComponents.day
                }
                
                if filteredActivities.count > 0 {
                    
                    for (i,location) in filteredActivities.enumerated() {
                        if let latitudeStr = location.latitudeStr, let longitudeStr = location.longitudeStr,
                           let latitude = Double(latitudeStr), let longitude = Double(longitudeStr) {
                            let annotation = MKPointAnnotation()
                            annotation.title = "\(i+1)"
                            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            self.mapVw.addAnnotation(annotation)
                        }
                    }
                }
            } else {
                if msg == CommonError.INTERNET {
                    Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                } else {
                    Proxy.shared.showSnackBar(message: msg)
                }
            
            }
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView: CustomAnnotationView?
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotation") as? CustomAnnotationView {
            annotationView = dequeuedView
        } else {
            annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
        }
        
        // Set annotation properties
        annotationView?.annotation = annotation
        annotationView?.displayPriority = .required
        
        // Set numberLabel.text to annotation title
        annotationView?.numberLabel.text = annotation.title ?? ""
        annotationView?.numberLabel.textColor = .red
        annotationView?.numberLabel.backgroundColor = .white
        // Set image for annotation view
        if (annotation.title) != nil {
            annotationView?.image = UIImage(named: "ic_pin")
        }
        
        return annotationView
    }

    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            stopTimer()
        }
    func startTimer() {
            // Schedule timer to call the method "timerAction" every 5 seconds
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
        
        func stopTimer() {
            timer?.invalidate() // Stop the timer
            timer = nil
        }
    
    @objc func timerAction() {
        viewModel.getCurrentTrackApi { val, msg in
            if val {
                //Make Polyline
                var area = [CLLocationCoordinate2D]()
                for i in self.viewModel.vanLocation {
                    if let latitudeString = i.latitude, let longitudeString = i.longitude {
                        area.append(CLLocationCoordinate2D(latitude: latitudeString, longitude: longitudeString))
                    }
                }
                
               // self.mapVw.showsUserLocation = true
                
                // Assuming 'area' contains coordinates for the region you want to display
                let center = CLLocationCoordinate2D(latitude: Double(area.first?.latitude ?? 0.0), longitude: Double(area.first?.longitude ?? 0.0))
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                let newLocation = CLLocation(latitude: Double(area.first?.latitude ?? 0.0), longitude: Double(area.first?.longitude ?? 0.0))
                self.locationManager.delegate?.locationManager?(self.locationManager, didUpdateLocations: [newLocation])
                
//                let annotation2 = MKPointAnnotation()
//                annotation2.coordinate = CLLocationCoordinate2D(latitude: Double(area.first?.latitude ?? 0.0), longitude: Double(area.first?.longitude ?? 0.0))
//                annotation2.title = "Current loc"
//                self.mapVw.addAnnotation(annotation2)
                // Set the region on the map view
                self.mapVw.setRegion(region, animated: true)
                
            } else {
                if msg == CommonError.INTERNET {
                    Proxy.shared.showSnackBar(message: CommonMessage.NO_INTERNET_CONNECTION)
                } else {
                    Proxy.shared.showSnackBar(message: msg)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.red
            pr.lineWidth = 5
            return pr
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        popView()
    }
}

class CustomAnnotationView: MKAnnotationView {
    
    var numberLabel: UILabel!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // Customize the image property with your custom image
//        self.image = UIImage(named: "custom_annotation_image") // Replace with your image name
        self.canShowCallout = true // Optional: Show callout with title/subtitle
        
        // Add a label to display numbers or custom text
        numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        numberLabel.textAlignment = .center
        numberLabel.textColor = .white
        numberLabel.font = UIFont.boldSystemFont(ofSize: 12)
        numberLabel.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.7)
        numberLabel.clipsToBounds = true
        numberLabel.layer.cornerRadius = 10
        self.addSubview(numberLabel)
        
        // Position the label relative to the annotation view
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            numberLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
