//
//  ViewController.swift
//  Map
//
//  Created by bglee on
//

import UIKit
import MapKit
import Progress
import Alamofire


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var myMap: MKMapView!
    @IBOutlet var lblLocationInfo1: UILabel!
    @IBOutlet var lblLocationInfo2: UILabel!
    
    let locationManager = CLLocationManager()
    
    let baseURLString = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "7247c52b8fb0ddc1cf2fa94d0730f098"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblLocationInfo1.text = ""
        lblLocationInfo2.text = ""
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        myMap.showsUserLocation = true
        
        myMap.delegate = self

    
    }

    func goLocation(latitudeValue: CLLocationDegrees, longitudeValue : CLLocationDegrees, delta span :Double)-> CLLocationCoordinate2D {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        let spanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: spanValue)
        myMap.setRegion(pRegion, animated: true)
        return pLocation
    }
    

    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue : CLLocationDegrees, delta span :Double, title strTitle: String, subtitle strSubtitle:String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate =  goLocation(latitudeValue: latitudeValue, longitudeValue: longitudeValue, delta: span)
        annotation.title = strTitle
        annotation.subtitle = strSubtitle
        myMap.addAnnotation(annotation)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let pLocation = locations.last
        _ = goLocation(latitudeValue: (pLocation?.coordinate.latitude)!, longitudeValue: (pLocation?.coordinate.longitude)!, delta: 0.01)
        CLGeocoder().reverseGeocodeLocation(pLocation!, completionHandler: {
            (placemarks, error) -> Void in
            let pm = placemarks!.first
            let country = pm!.country
            var address:String = country!
            if pm!.locality != nil {
                address += " "
                address += pm!.locality!
            }
            if pm!.thoroughfare != nil {
                address += " "
                address += pm!.thoroughfare!
            }
            
            self.lblLocationInfo1.text = "현재 위치"
            self.lblLocationInfo2.text = address
            })
        
        locationManager.stopUpdatingLocation()
    }
    
    
    @IBAction func sgChangeLocation(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.lblLocationInfo1.text = ""
            self.lblLocationInfo2.text = ""
            locationManager.startUpdatingLocation()
        } else if sender.selectedSegmentIndex == 1 {
            setAnnotation(latitudeValue: 37.63698, longitudeValue: 126.91778, delta: 1, title: "서울 은평 롯데몰 풋살장", subtitle: "서울시 은평구 진광동 61")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "은평 롯데몰 풋살장"
        } else if sender.selectedSegmentIndex == 2 {
            setAnnotation(latitudeValue: 37.52607, longitudeValue: 126.89155, delta: 0.1, title: "서울 영등포 더에프 필드A구장", subtitle: "서울시 영등포구 선유로 138")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "서울 영등포 더에프 필드A구장 "
        }  else if sender.selectedSegmentIndex == 3 {
            setAnnotation(latitudeValue: 37.53027, longitudeValue: 126.87331, delta: 1, title: "서울 피치푸마목동(홈플러스 목동점)", subtitle: "서울 양천구 목동서로 170 ")
            self.lblLocationInfo1.text = "보고 계신 위치"
            self.lblLocationInfo2.text = "서울 피치푸마목동(홈플러스 목동점) "
        }

    }
    
}

extension MapViewController {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            getWeatherData(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        }
    }
    
    func getWeatherData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let url = "\(baseURLString)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        AF.request(url).responseDecodable(of: WeatherData.self) { response in
            switch response.result {
            case .success(let weatherData):
                DispatchQueue.main.async {
                    self.lblLocationInfo2.text = "Temperature at \(weatherData.name): \(weatherData.main.temp)°C"
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}



