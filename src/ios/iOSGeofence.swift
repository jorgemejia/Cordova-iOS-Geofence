
@objc(iOSGeofence) class iOSGeofence : CDVPlugin {
  @objc(echo:)
    
    var geotifications = [Geotification]()
    let locationManager = CLLocationManager() // Add this statement
    
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
        locationManager.delegate = self
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
        addRadiusOverlay(forGeotification: geotification)
        updateGeotificationsCount()
    }
    
    func remove(geotification: Geotification) {
        if let indexInArray = geotifications.index(of: geotification) {
            geotifications.remove(at: indexInArray)
        }
        mapView.removeAnnotation(geotification)
        removeRadiusOverlay(forGeotification: geotification)
        updateGeotificationsCount()
    }
    
    func updateGeotificationsCount() {
        title = "Geotifications (\(geotifications.count))"
        navigationItem.rightBarButtonItem?.isEnabled = (geotifications.count < 20)
    }

    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    func startMonitoring(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        // 3
        let region = self.region(withGeotification: geotification)
        // 4
        locationManager.startMonitoring(for: region)
    }
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
}
