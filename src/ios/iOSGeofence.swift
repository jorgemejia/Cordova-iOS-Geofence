import UIKit
import CoreLocation

struct PreferencesKeys {
    static let savedItems = "savedItems"
}

struct GeoKey {
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let radius = "radius"
    static let identifier = "identifier"
    static let note = "note"
    static let eventType = "eventTYpe"
}

enum EventType: String {
    case onEntry = "On Entry"
    case onExit = "On Exit"
}

class Geotification: NSObject, NSCoding {
    
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    var note: String
    var eventType: EventType
    
    var title: String? {
        if note.isEmpty {
            return "No Note"
        }
        return note
    }
    
    var subtitle: String? {
        let eventTypeString = eventType.rawValue
        return "Radius: \(radius)m - \(eventTypeString)"
    }
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String, eventType: EventType) {
        self.coordinate = coordinate
        self.radius = radius
        self.identifier = identifier
        self.note = note
        self.eventType = eventType
    }
    
    // MARK: NSCoding
    required init?(coder decoder: NSCoder) {
        let latitude = decoder.decodeDouble(forKey: GeoKey.latitude)
        let longitude = decoder.decodeDouble(forKey: GeoKey.longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        radius = decoder.decodeDouble(forKey: GeoKey.radius)
        identifier = decoder.decodeObject(forKey: GeoKey.identifier) as! String
        note = decoder.decodeObject(forKey: GeoKey.note) as! String
        eventType = EventType(rawValue: decoder.decodeObject(forKey: GeoKey.eventType) as! String)!
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(coordinate.latitude, forKey: GeoKey.latitude)
        coder.encode(coordinate.longitude, forKey: GeoKey.longitude)
        coder.encode(radius, forKey: GeoKey.radius)
        coder.encode(identifier, forKey: GeoKey.identifier)
        coder.encode(note, forKey: GeoKey.note)
        coder.encode(eventType.rawValue, forKey: GeoKey.eventType)
    }
    
}


var geotifications: [Geotification] = []
var locationManager = CLLocationManager()

@objc(iOSGeofence) class iOSGeofence : CDVPlugin {
  @objc(echo:)
    

  func echo(command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(
      status: CDVCommandStatus_ERROR
    )

    let msg = command.arguments[0] as? String ?? ""

    if msg.characters.count > 0 {
      let toastController: UIAlertController =
        UIAlertController(
          title: "",
          message: msg,
          preferredStyle: .alert
        )
      
      self.viewController?.present(
        toastController,
        animated: true,
        completion: nil
      )

      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        toastController.dismiss(
          animated: true,
          completion: nil
        )
      }
        
      pluginResult = CDVPluginResult(
        status: CDVCommandStatus_OK,
        messageAs: msg
      )
    }

    self.commandDelegate!.send(
      pluginResult,
      callbackId: command.callbackId
    )
  }
    
    func requestPermission(command: CDVInvokedUrlCommand) {
        // 1
        //locationManager.delegate = self
        // 2
        locationManager.requestAlwaysAuthorization()
        // 3
        loadAllGeotifications()
    }
    
    func addGeotificationViewController(command: CDVInvokedUrlCommand) {
        //controller.dismiss(animated: true, completion: nil)
        // 1
        //let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
        //let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType)
        //add(geotification: geotification)
        // 2
        //startMonitoring(geotification: geotification)
        //saveAllGeotifications()
    }
    
    // MARK: Loading and saving functions
    func loadAllGeotifications() {
        geotifications = []
        guard let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) else { return }
        for savedItem in savedItems {
            guard let geotification = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? Geotification else { continue }
            add(geotification: geotification)
        }
    }
    // MARK: Functions that update the model/associated views with geotification changes
    func add(geotification: Geotification) {
        geotifications.append(geotification)
        //mapView.addAnnotation(geotification)
        //addRadiusOverlay(forGeotification: geotification)
        //updateGeotificationsCount()
    }
    
}
