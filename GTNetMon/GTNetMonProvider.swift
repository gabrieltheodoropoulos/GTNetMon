//
//  GTNetMonProvider.swift
//  GTNetMon
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Gabriel Theodoropoulos. All rights reserved.
//

import Foundation

/**
 A protocol that specifies the available properties and methods that client apps can
 use so they get network status information, as well as to start and stop monitoring
 connection changes.
 */
protocol GTNetMonProvider {
    
    /// The connection type (wifi, cellular, other, etc) as a `GTNetMon`.`ConnectionType` value.
    var connectionType: GTNetMon.ConnectionType { get }
    
    /// A collection of the available connection types at any given moment to the device.
    var availableConnectionTypes: [GTNetMon.ConnectionType] { get }
    
    /// It indicates whether the device is connected to Internet.
    var isConnected: Bool { get }
    
    /// It becomes true when the device uses cellular connection or acts as a hotspot to other devices
    /// to provide Internet access through cellular connection.
    ///
    /// In iOS version prior to 12.0, it becomes true only when usign cellular connection.
    var isExpensive: Bool { get }
    
    /// It indicates whether network status changes are being monitored or not.
    var isMonitoring: Bool { get }
    
    /**
     It starts monitoring for network status changes.
     
     Even though you can start monitoring anywhere in your app, it is recommended
     to do so in the `applicationDidBecomeActive(_:)` delegate method in the `AppDelegate`.
     
     Observe for the `GTNetMonNetworkStatusChangeNotification` notification in any class
     you want to be notified about changes in the network status.
     */
    func startMonitoring()
    
    /**
     It stops monitoring for network status changes.
     
     It is recommended to call this method in the `applicationWillResignActive(_:)` method
     in the `AppDelegate`.
     */
    func stopMonitoring()
}
