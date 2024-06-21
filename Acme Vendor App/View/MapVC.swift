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
    @IBOutlet weak var cnstCalendarHeight: NSLayoutConstraint!
    @IBOutlet weak var cnstStackHeight: NSLayoutConstraint!
    @IBOutlet weak var vwStack: UIStackView!
    @IBOutlet var btnMapList: [UIButton]!
    @IBOutlet weak var tblVwList: UITableView!
    @IBOutlet weak var vwList: UIView!
    @IBOutlet weak var mapVw: MKMapView!
    @IBOutlet weak var btnCalendar: UIButton!
    @IBOutlet weak var vwMap: UIView!
    //MARK: - Variables
    var isLive = false
    var locationManager: CLLocationManager = CLLocationManager()
    var viewModel = MapVM()
    var vanNo = String()
    var timer: Timer?
    var isFirstTime = true
    var selectedDate = Date()
    var dateSelectedList:[LocationDetailModel]?
    var sortedEntriesForList:[(Date, LocationDetailModel)]?
    //MARK: - Lifecycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLive {
            cnstCalendarHeight.constant = 0
            cnstStackHeight.constant = 0
            vwStack.isHidden = true
            btnCalendar.isHidden = true
            startTimer()
        }
        locationManager.delegate = self
        
        mapVw.delegate = self
        mapVw.mapType = MKMapType.standard
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
                    let currentDate = self.selectedDate
                    
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
                self.dateSelectedList = filteredActivities
                
                var datesForList = [(Date, LocationDetailModel)]()
                
                for i in self.dateSelectedList ?? [] {
                    if i.vehicleNumber == "UP87T4275" {
                        datesForList.append((self.convertStringToDate(i.createdDateReadable ?? "", format: "dd MMM, yyyy, hh:mm a"), i))
                    }
                }
                
                self.sortedEntriesForList = datesForList.sorted(by: { $0.0 > $1.0 })
                
                self.tblVwList.reloadData()
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
        if annotation.title != "Current loc" {
            annotationView?.numberLabel.text = annotation.title ?? ""
            annotationView?.numberLabel.textColor = .red
            annotationView?.numberLabel.backgroundColor = .white
            // Set image for annotation view
            if (annotation.title) != nil {
                annotationView?.image = UIImage(named: "ic_pin")
            }
        } else {
            if annotation.subtitle == "Stopped" {
                annotationView?.image = UIImage(named: "ic_stop")
            } else if annotation.subtitle == "Running" {
                annotationView?.image = UIImage(named: "ic_running")
            }
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
                //var area = [CLLocationCoordinate2D]()
                var dates = [(Date, LocationDetailModel)]()
                
                for i in self.viewModel.vanLocation {
                    if i.vehicleNumber == "UP87T4275" {
                        dates.append((self.convertStringToDate(i.createdDateReadable ?? "",format: "dd MMM, yyyy, hh:mm a"), i))
                    }
                }
                
                let sortedEntries = dates.sorted(by: { $0.0 > $1.0 })
                
                if let latestEntry = sortedEntries.first?.1 { //Checking latest entry in an array
                    
                    let center = CLLocationCoordinate2D(latitude: Double(latestEntry.latitude ?? 0.0), longitude: Double(latestEntry.longitude ?? 0.0))
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    
                    let newLocation = CLLocation(latitude: Double(latestEntry.latitude ?? 0.0), longitude: Double(latestEntry.longitude ?? 0.0))
                    self.locationManager.delegate?.locationManager?(self.locationManager, didUpdateLocations: [newLocation])
                    
                    let annotation2 = MKPointAnnotation()
                    
                    annotation2.coordinate = CLLocationCoordinate2D(latitude: Double(latestEntry.latitude ?? 0.0), longitude: Double(latestEntry.longitude ?? 0.0))
                    
                    let annotationsToRemove = self.mapVw.annotations.filter { $0.title == "Current loc" }
                    self.mapVw.removeAnnotations(annotationsToRemove)
                    
                    annotation2.title = "Current loc"
                    annotation2.subtitle = latestEntry.ignition == true ? "Running" : "Stopped"
                    self.mapVw.addAnnotation(annotation2)
                    // Set the region on the map view
                    if self.isFirstTime {
                        self.mapVw.setRegion(region, animated: true)
                        self.isFirstTime = false
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
    @IBAction func actionCalendar(_ sender: Any) {
        openDateCalendar()
    }
    
    @IBAction func actionVanMeter(_ sender: UIButton) {
        for btn in btnMapList {
            if sender.tag == btn.tag {
                btnMapList[btn.tag].setTitleColor(.white, for: .normal)
                btnMapList[btn.tag].backgroundColor = .APP_BLUE_CLR
            } else {
                btnMapList[btn.tag].setTitleColor(.black, for: .normal)
                btnMapList[btn.tag].backgroundColor = .APP_GRAY_CLR
            }
        }
        vwMap.isHidden = sender.tag == 1
        vwList.isHidden = sender.tag == 0
        if sender.tag == 0 {
            mapVw.reloadInputViews()
        } else {
            tblVwList.reloadData()
        }
    }
    func openDateCalendar() {
        if let calendar = UIStoryboard.init(name: ViewControllerType.WWCalendarTimeSelector.rawValue, bundle: nil).instantiateInitialViewController() as? WWCalendarTimeSelector {
            view.endEditing(true)
            calendar.delegate = self
            calendar.optionCurrentDate = selectedDate
            calendar.optionStyles.showDateMonth(true)
            calendar.optionStyles.showMonth(false)
            calendar.optionStyles.showYear(true)
            calendar.optionStyles.showTime(false)
            calendar.optionButtonShowCancel = true
            self.present(calendar, animated: true, completion: nil)
        }
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

extension MapVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedEntriesForList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewTVC", for: indexPath) as! ListViewTVC
        cell.lblLocationTime.text = "\(sortedEntriesForList?[indexPath.row].1.location ?? "")\non\n\(sortedEntriesForList?[indexPath.row].1.createdDateReadable ?? "")"
        cell.vwLine.backgroundColor = sortedEntriesForList?[indexPath.row].1.ignition2 == "1" ? .green : .red
        
        cell.vwLine.isHidden = indexPath.row == (sortedEntriesForList?.count ?? 0)-1
        cell.lblDuration.isHidden = indexPath.row == (sortedEntriesForList?.count ?? 0)-1
        
        if indexPath.row != (sortedEntriesForList?.count ?? 0)-1 {
            
            cell.lblDuration.text = "\(sortedEntriesForList?[indexPath.row].1.ignition2 == "1" ? "Ran" : "Stopped") for \(Proxy.shared.calculateDuration(from: sortedEntriesForList?[indexPath.row+1].0 ?? Date(), to: sortedEntriesForList?[indexPath.row].0 ?? Date()))"
        }
        return cell
   }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension MapVC: WWCalendarTimeSelectorProtocol {
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        selectedDate = date
        viewWillAppear(true)
        self.tblVwList.reloadData()
    }
    
    func WWCalendarTimeSelectorShouldSelectDate(_ selector: WWCalendarTimeSelector, date: Date) -> Bool {
        let calendar = Calendar.current
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        
        // Compare selected date with one month ago date
        return date >= oneMonthAgo && date < Date()
    }
}
