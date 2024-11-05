import Mapbox
import MapKit
import SwiftUI

class SharedState: ObservableObject {
    init(showPreciseButton: Bool) {
        self.showPreciseButton = showPreciseButton
    }
    @Published var showPreciseButton: Bool
}

struct MapView: UIViewRepresentable {
    @ObservedObject private var locationManager = LocationManager()
    let zoom: Double = 17
    @Binding var initialLocationSet: Bool // Usando binding para modificar a variável externa

    func makeUIView(context: Context) -> MGLMapView {
        // read the key from property list
        let mapTilerKey = getMapTilerkey()
        validateKey(mapTilerKey)
        
        // Build the style url
        let styleURL = URL(string: "https://api.maptiler.com/maps/streets/style.json?key=\(mapTilerKey)")
        
        // create the map view
        let mapView = MGLMapView(frame: .zero, styleURL: styleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.logoView.isHidden = true
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        
        return mapView
    }

    func updateUIView(_ uiView: MGLMapView, context: Context) {
        // Verifica se a localização inicial já foi centralizada
            if let userLocation = locationManager.userLocation, !initialLocationSet {
                DispatchQueue.main.async {
                    uiView.setCenter(userLocation, zoomLevel: self.zoom, animated: true)
                    initialLocationSet = true // Define como true após a primeira centralização
                }
            }
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapView
        
        init(_ control: MapView) {
            self.control = control
        }

        func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
            // Código a ser executado após o carregamento do mapa, se necessário
        }
    }
    
    func getMapTilerkey() -> String {
        let mapTilerKey = Bundle.main.object(forInfoDictionaryKey: "MapTilerKey") as? String
        validateKey(mapTilerKey)
        return mapTilerKey!
    }
    
    func validateKey(_ mapTilerKey: String?) {
        if mapTilerKey == nil {
            preconditionFailure("Failed to read MapTiler key from info.plist")
        }
        let result: ComparisonResult = mapTilerKey!.compare("placeholder", options: NSString.CompareOptions.caseInsensitive, range: nil, locale: nil)
        if result == .orderedSame {
            preconditionFailure("Please enter correct MapTiler key in info.plist[MapTilerKey] property")
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Erro ao obter localização: \(error)")
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
