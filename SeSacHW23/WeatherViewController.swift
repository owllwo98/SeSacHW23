//
//  WeatherViewController.swift
//  SeSACSevenWeek
//
//  Created by Jack on 2/3/25.
//

import UIKit
import Alamofire
import SnapKit
import MapKit

protocol WeatherViewControllerDelegate {
    func photoRecieved(value: UIImage)
}


class WeatherViewController: UIViewController {
     
    private let locationManager = CLLocationManager()
    private let defaultLocation = CLLocation(latitude: 37.6545399298261, longitude: 127.049926290286)
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    private let weatherInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "날씨 정보를 불러오는 중..."
        return label
    }()
    
    let uiView: UIView = UIView()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().toDateDayString()
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    private let tempMinLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    private let tempMaxLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    
    private let windLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    let photoImageView: UIImageView = UIImageView()
    
    private let photoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        
        return button
    }()
    
    private let currentLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 4
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        setupUI()
        setupConstraints()
        setupActions()
        checkDeviceLocationAuthorization()
        
        uiView.isHidden = true
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        checkDeviceLocationAuthorization()
//    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        [mapView, weatherInfoLabel, uiView, photoImageView, currentLocationButton, refreshButton, photoButton].forEach {
            view.addSubview($0)
        }
        
        [dateLabel, tempLabel, tempMinLabel, tempMaxLabel, windLabel, humidityLabel].forEach {
            uiView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }
        
        weatherInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        uiView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        tempLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        tempMinLabel.snp.makeConstraints { make in
            make.top.equalTo(tempLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        tempMaxLabel.snp.makeConstraints { make in
            make.top.equalTo(tempMinLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        windLabel.snp.makeConstraints { make in
            make.top.equalTo(tempMaxLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        humidityLabel.snp.makeConstraints { make in
            make.top.equalTo(windLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(UIScreen.main.bounds.width / 3.5)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
        
        photoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.size.equalTo(50)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.width.height.equalTo(50)
        }
    }
    
    private func setupActions() {
        currentLocationButton.addTarget(self, action: #selector(currentLocationButtonTapped), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        photoButton.addTarget(self, action: #selector(goToPhotoView), for: .touchUpInside)
    }
    
    private func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            }
        }
    }
    
    private func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            showLocationSettingAlert()
            setRegionAndAnnotation(center: defaultLocation.coordinate)
            getWeather(lat: 37.6545399298261, lon: 127.049926290286) { response in
                switch response {
                case .success(let success):
                    print(success)
                    self.tempLabel.text = "현재온도: \(success.main.temp)℃"
                    self.tempMinLabel.text = "최저온도: \(success.main.temp_min)℃"
                    self.tempMaxLabel.text = "최고온도: \(success.main.temp_max)℃"
                    self.windLabel.text = "풍속: \(success.wind.speed)m/s"
                    self.humidityLabel.text = "습도: \(success.main.humidity)%"
                    self.weatherInfoLabel.isHidden = true
                    self.uiView.isHidden = false
                    self.photoImageView.isHidden = true
                case.failure(let failure):
                    print(failure)
                    
                }
            }
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("error")
        }
    }
    
    private func showLocationSettingAlert() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.", preferredStyle: .alert)
        
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let setting = URL(string:  UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(goSetting)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    
    private func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        let annotation: MKPointAnnotation = MKPointAnnotation()
        
        annotation.coordinate = center
        
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    private func getWeather(lat: Double, lon: Double, completionHandler: @escaping (Result<Weather , AFError>) -> Void) {
        AF.request("https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(APIKey.openweathermapKey)&lang=kr&units=metric")
            .responseDecodable(of: Weather.self) { response in
                switch response.result {
                case.success(let value):
                    completionHandler(.success(value))
                case.failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
    
    // MARK: - Actions
    @objc private func currentLocationButtonTapped() {
        // 현재 위치 가져오기 구현
        checkDeviceLocationAuthorization()
        print(mapView.centerCoordinate)
    }
    
    @objc private func refreshButtonTapped() {
        // 날씨 새로고침 구현
        
        print(mapView.centerCoordinate)
        getWeather(lat: mapView.centerCoordinate.latitude, lon: mapView.centerCoordinate.longitude) { response in
            switch response {
            case .success(let success):
                print(success)
                self.tempLabel.text = "현재온도: \(success.main.temp.formatted())℃"
                self.tempMinLabel.text = "최저온도: \(success.main.temp_min)℃"
                self.tempMaxLabel.text = "최고온도: \(success.main.temp_max)℃"
                self.windLabel.text = "풍속: \(success.wind.speed.formatted())m/s"
                self.humidityLabel.text = "습도: \(success.main.humidity.formatted())%"
                self.weatherInfoLabel.isHidden = true
                self.uiView.isHidden = false
                self.photoImageView.isHidden = true
            case.failure(let failure):
                print(failure)
            }
        }
//        fetchData()
    }
    
    @objc
    private func goToPhotoView() {
        let vc = PhotoViewController()
        vc.contents = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        if let coordinate = locations.last?.coordinate {
            setRegionAndAnnotation(center: coordinate)
            getWeather(lat: coordinate.latitude, lon: coordinate.longitude) { response in
                switch response {
                case .success(let success):
                    print(success)
                    self.tempLabel.text = "현재온도: \(success.main.temp.formatted())℃"
                    self.tempMinLabel.text = "최저온도: \(success.main.temp_min)℃"
                    self.tempMaxLabel.text = "최고온도: \(success.main.temp_max)℃"
                    self.windLabel.text = "풍속: \(success.wind.speed.formatted())m/s"
                    self.humidityLabel.text = "습도: \(success.main.humidity.formatted())%"
                    self.weatherInfoLabel.isHidden = true
                    self.uiView.isHidden = false
                    self.photoImageView.isHidden = true
                case.failure(let failure):
                    print(failure)
                }
            }
//            fetchData()
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
    }
}

extension WeatherViewController {
    func fetchData() {
        getWeather(lat: mapView.centerCoordinate.latitude, lon: mapView.centerCoordinate.longitude) { response in
            switch response {
            case .success(let success):
                print(success)
                self.tempLabel.text = "현재온도: \(success.main.temp)℃"
                self.tempMinLabel.text = "최저온도: \(success.main.temp_min)℃"
                self.tempMaxLabel.text = "최고온도: \(success.main.temp_max)℃"
                self.windLabel.text = "풍속: \(success.wind.speed)m/s"
                self.humidityLabel.text = "습도: \(success.main.humidity)%"
                self.weatherInfoLabel.isHidden = true
                self.uiView.isHidden = false
            case.failure(let failure):
                print(failure)
            }
        }
    }
}

extension WeatherViewController: WeatherViewControllerDelegate {
    func photoRecieved(value: UIImage) {
        photoImageView.image = value
        uiView.isHidden = true
        self.photoImageView.isHidden = false
    }
}
