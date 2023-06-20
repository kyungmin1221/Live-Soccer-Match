
import UIKit
import CoreLocation

var currentLocation: CLLocation?

func getLatitude() -> CLLocationDegrees? {
    return currentLocation?.coordinate.latitude
}

func getLongitude() -> CLLocationDegrees? {
    return currentLocation?.coordinate.longitude
}

class CityViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityPickerView: UIPickerView!
    
    // 현재위치 불러오기 위한 CLLocationManager 객체 생성
    var locationManager: CLLocationManager!   //(2)
  
    //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 위치가 업데이트될때마다
        guard let location = locations.last else { return }
        currentLocation = location
        cities["현재위치"] = ["lon":getLongitude(), "lat":getLatitude()]
        locationManager.stopUpdatingLocation()
        print("\(cities["현재위치"]!)")
    }
    
    var cities: [String: [String:Double?]] = [
        "Seoul" : ["lon":126.9778,"lat":37.5683],
        "Athens" : ["lon":23.7162,"lat":37.9795],
        "Bangkok" : ["lon":100.5167,"lat":13.75],
        "Berlin" : ["lon":13.4105,"lat":52.5244],
        "Jerusalem" : ["lon":35.2163,"lat":31.769],
        "Lisbon" : ["lon":-9.1333,"lat":38.7167],
        "London" : ["lon":-0.1257,"lat":51.5085],
        "New York" : ["lon":-74.006,"lat":40.7143],
        "Paris" : ["lon":2.3488,"lat":48.8534],
        "Sydney" : ["lon":151.2073,"lat":-33.8679],
        "현재위치" : ["lon": nil, "lat": nil]   // 현재위치 초기값 nil (1)
    ]
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //권한 요청
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
 
    }
}

extension CityViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return cities.count
        }
        return 5
    }
}

extension CityViewController: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var names = Array(cities.keys)
        names.sort()
        return names[row]
    }
}

extension CityViewController{
    func getCurrentLonLat() -> (String, Double?, Double?) {
        var cityNames = Array(cities.keys)
        cityNames.sort()
        let selectedCity = cityNames[cityPickerView.selectedRow(inComponent: 0)]
        let city = cities[selectedCity]
        return (selectedCity, city?["lon"] ?? nil, city?["lat"] ?? nil)
    }
}
