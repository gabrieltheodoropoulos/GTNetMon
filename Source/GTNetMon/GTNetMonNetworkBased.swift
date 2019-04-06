//
//  GTNetMonNetworkBased.swift
//  GTNetMon
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Gabriel Theodoropoulos. All rights reserved.
//

import Foundation
import Network

@available(iOS 12.0, *)
class GTNetMonNetworkBased: GTNetMonProvider {
    
    // MARK: - Required Properties
    
    var connectionType: GTNetMon.ConnectionType {
        return getConnectionType()
    }
    
    var availableConnectionTypes: [GTNetMon.ConnectionType] {
        return getAvailableConnectionTypes()
    }
    
    var isConnected: Bool {
        guard let monitor = monitor else { return false }
        return (monitor.currentPath.status == .satisfied)
    }
    
    var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }

    
    var isMonitoring: Bool = false
    
    
    
    // MARK: - Other Properties
    
    /// The `NWPathMonitor` object through which network information is accessed.
    private var monitor: NWPathMonitor?
    
    
    
    // MARK: - Init & Deinit
    
    init() {
        startMonitoring()
    }
    
    
    deinit {
        if isMonitoring {
            guard let monitor = monitor else { return }
            monitor.cancel()
            self.monitor = nil
        }
    }
    
    
    
    // MARK: - Private Methods
    
    /**
     It returns the current connection type (wifi, cellular, other).
     
     Default value is "other".
     
     - Returns a `GTNetMon`.`ConnectionType` value that represents the connection type.
    */
    private func getConnectionType() -> GTNetMon.ConnectionType {
        guard let monitor = monitor else { return .undefined }
        var type: GTNetMon.ConnectionType = .other
        
        for interface in monitor.currentPath.availableInterfaces {
            if monitor.currentPath.usesInterfaceType(interface.type) {
                let filtered = GTNetMon.ConnectionType.allCases.filter { $0.toString() == "\(interface.type)" }
                if filtered.count > 0 {
                    type = filtered[0]
                }
            }
        }
        
        return type
    }
    
    
    /**
     It returns a collection with the connection types available to the device.
     
     - Returns: An array of `GTNetMon`.`ConnectionType` values as they are taken
     from the `currentPath` property of the `monitor` object.
    */
    private func getAvailableConnectionTypes() -> [GTNetMon.ConnectionType] {
        guard let monitor = monitor else { return [] }
        var interfaces = [GTNetMon.ConnectionType]()
        
        for interface in monitor.currentPath.availableInterfaces {
            let filtered = GTNetMon.ConnectionType.allCases.filter { $0.toString() == "\(interface.type)" }
            if filtered.count > 0 {
                interfaces.append(filtered[0])
            } else {
                interfaces.append(.other)
            }
        }
        
        return interfaces
    }
    
    
    
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        if monitor != nil {
            monitor?.cancel()
            monitor = nil
        }
        monitor = NWPathMonitor()
        
        monitor?.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .GTNetMonNetworkStatusChangeNotification, object: nil)
            }
        }
        
        let queue = DispatchQueue(label: "GTNetMon_Monitor")
        monitor?.start(queue: queue)
        
        isMonitoring = true
    }
    
    
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else { return }
        
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
    }
}
