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
    @Binding var initialLocationSet: Bool
    @Binding var startPoint: CLLocationCoordinate2D? // Coordenada inicial
    @Binding var endPoint: CLLocationCoordinate2D?   // Coordenada final
    @Binding var route : [CLLocationCoordinate2D]
    
    @State var numberOfPoints : Int = 0
    @State private var coordinator: Coordinator?
    
    func makeUIView(context: Context) -> MGLMapView {
        let mapTilerKey = getMapTilerkey()
        validateKey(mapTilerKey)
        
        let styleURL = URL(string: "https://api.maptiler.com/maps/streets/style.json?key=\(mapTilerKey)")
        let mapView = MGLMapView(frame: .zero, styleURL: styleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.logoView.isHidden = true
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleMapTap(_:))))
        
        return mapView
    }

    func updateUIView(_ uiView: MGLMapView, context: Context) {
        if let userLocation = locationManager.userLocation, !initialLocationSet {
            DispatchQueue.main.async {
                uiView.setCenter(userLocation, zoomLevel: self.zoom, animated: true)
                initialLocationSet = true
            }
        }
        if !route.isEmpty && numberOfPoints != route.count {
            context.coordinator.drawRoute(with: route)
            DispatchQueue.main.async{
                numberOfPoints = route.count
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self, startPoint: $startPoint, endPoint: $endPoint)
        DispatchQueue.main.async{
            self.coordinator = coordinator // Armazena a referência do coordenador
        }
        return coordinator

    }
    func removePoints(){
        coordinator?.removeStartAndEndPoints()
    }
    final class Coordinator: NSObject, MGLMapViewDelegate {
        var control: MapView
        @Binding var startPoint: CLLocationCoordinate2D?
        @Binding var endPoint: CLLocationCoordinate2D?
        var mapView: MGLMapView?
        
        init(_ control: MapView, startPoint: Binding<CLLocationCoordinate2D?>, endPoint: Binding<CLLocationCoordinate2D?>) {
            self.control = control
            self._startPoint = startPoint
            self._endPoint = endPoint
        }
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            guard let pointAnnotation = annotation as? MGLPointAnnotation else {
                return nil
            }

            let annotationView = MGLAnnotationView(reuseIdentifier: nil)
            annotationView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)

            // Adicionando a imagem como ícone
            let iconImageView = UIImageView()
            if pointAnnotation.title == "Out" {
                iconImageView.image = UIImage(named: "out.png") // Ícone de saída
            } else if pointAnnotation.title == "Finish" {
                iconImageView.image = UIImage(named: "finish.png") // Ícone de chegada
            }
            iconImageView.frame = CGRect(x: 10, y: 10, width: 30, height: 40)
            annotationView.addSubview(iconImageView)

            // Adicionando o texto acima do marcador
            let label = UILabel()
            label.text = pointAnnotation.title
            label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
            label.textColor = .black
            label.textAlignment = .center
            label.frame = CGRect(x: -20, y: -20, width: 100, height: 20)
            annotationView.addSubview(label)

            return annotationView
        }


        @objc func handleMapTap(_ gesture: UITapGestureRecognizer) {
            guard let mapView = gesture.view as? MGLMapView else { return }
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

            if startPoint == nil {
                startPoint = coordinate // Define a origem
                addMarker(at: coordinate, on: mapView, title: "Out")
            } else if endPoint == nil {
                endPoint = coordinate // Define o destino
                addMarker(at: coordinate, on: mapView, title: "Finish")
            } else {
                // Remove os pontos existentes e redefine
                removeStartAndEndPoints()
                startPoint = coordinate
                addMarker(at: coordinate, on: mapView, title: "Out")
            }
        }

        func addMarker(at coordinate: CLLocationCoordinate2D, on mapView: MGLMapView, title: String) {
            let annotation = MGLPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = title
            mapView.addAnnotation(annotation)
        }
        func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
            self.mapView = mapView
            print("Mapa carregado com sucesso.")
            
            // Se você precisar desenhar rotas imediatamente após carregar o mapa
            if let start = startPoint, let end = endPoint {
                let routePoints = [start, end] // Exemplo simples; aqui você pode adicionar a lógica da rota
                drawRoute(with: routePoints)
            }
        }
        // Função para desenhar a rota no mapa
        // Função modificada para desenhar uma rota a partir de uma matriz de pontos
        func drawRoute(with points: [CLLocationCoordinate2D],update: Bool = false) {
            guard let mapView = self.mapView else {
                print("MapView não está inicializado ou carregado.")
                return
            }

            guard mapView.style != nil else {
                print("O estilo do mapa ainda não foi carregado.")
                return
            }

            guard !points.isEmpty else {
                print("Nenhum ponto para desenhar a rota.")
                return
            }
            
            // Remove rotas antigas (se necessário)
            if let annotations = mapView.annotations {
                mapView.removeAnnotations(annotations.filter { $0 is MGLPolyline })
            }

            // Adiciona a nova rota
            let polyline = MGLPolyline(coordinates: points, count: UInt(points.count))
            mapView.addAnnotation(polyline)        }

        func removeStartAndEndPoints() {
            guard let mapView = self.mapView else {
                print("MapView não está inicializado.")
                return
            }

            // Filtra os pontos de início e fim pelo título
            let annotationsToRemove = mapView.annotations?.filter { annotation in
                guard let pointAnnotation = annotation as? MGLPointAnnotation else {
                    return false
                }
                return pointAnnotation.title == "Out" || pointAnnotation.title == "Finish"
            }
            
            // Remove as anotações filtradas
            if let annotations = annotationsToRemove {
                mapView.removeAnnotations(annotations)
            }

            // Limpa as variáveis de controle
            startPoint = nil
            endPoint = nil
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
        if mapTilerKey!.compare("placeholder", options: .caseInsensitive) == .orderedSame {
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
