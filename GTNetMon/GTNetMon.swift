//
//  GTNetMon.swift
//  GTNetMon
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Gabriel Theodoropoulos. All rights reserved.
//

import Foundation

/**
 A class that provides information about whether a device is connected to Internet,
 the connection type (wifi, cellular, etc), and monitors for network status changes.
 
 This is a singleton class, so use the `shared` instance to access its members.
 
 Available properties are:
 
 * **`isConnected`**: Indicates whether the device is connected to Internet or not.
 * **`connectionType`**: The connection type as a `GTNetMon.ConnectionType` value (see next).
 * **`availableConnectionTypes`**: A collection of the available connection types to the device at a given moment.
 * **`isExpensive`**: An indication that the connection is expensive while the device is connected to Internet through cellular network. Note that this flag is more accurate when used in iOS versions >= 12.0.
 * **`isMonitoring`**: It indicates whether network status changes are being monitored or not.
 
 In addition to the above, there are the following two methods:
 
 * **`startMonitoring()`**: It starts monitoring for network status changes.
 * **`stopMonitoring()`**: It stops monitoring for network status changes.
 
 **Important**
 
 1. It is recommended to start and stop monitoring in the `applicationDidBecomeActive(_:)` and `applicationWillResignActive(_:)` methods of the AppDelegate class respectively.
 2. Classes that want to be notified about monitored network status changes should observe for the **`GTNetMonNetworkStatusChangeNotification`** notification. It is posted whenever a change in the connection occurs.

 **Other**
 
 In iOS versions starting from 12.0 and above, the new `Network` framework of the iOS SDK
 is used to retrieve network information. In older iOS versions, `SCNetworkReachability` API
 is used instead.
 
 */
open class GTNetMon: GTNetMonProvider {
    
    /// The `GTNetMon` shared instance.
    public static let shared = GTNetMon()
    
    
    // MARK: - Required Properties
    
    /// The connection type (wifi, cellular, other, etc) as a `GTNetMon`.`ConnectionType` value.
    public var connectionType: GTNetMon.ConnectionType {
        return netInfo?.connectionType ?? .undefined
    }
    
    /// A collection of the available connection types at any given moment to the device.
    public var availableConnectionTypes: [GTNetMon.ConnectionType] {
        return netInfo?.availableConnectionTypes ?? []
    }
    
    /// It indicates whether the device is connected to Internet.
    public var isConnected: Bool {
        return netInfo?.isConnected ?? false
    }
    
    /// It becomes true when the device uses cellular connection or acts as a hotspot to other devices
    /// to provide Internet access through cellular connection.
    ///
    /// In iOS version prior to 12.0, it becomes true only when usign cellular connection.
    public var isExpensive: Bool {
        return netInfo?.isExpensive ?? false
    }
    
    
    /// It indicates whether network status changes are being monitored or not.
    public var isMonitoring: Bool {
        return netInfo?.isMonitoring ?? false
    }
    
    
    
    // MARK: - Custom Properties
    
    private var netInfo: GTNetMonProvider?
    
    
    
    // MARK: - Init & Deinit
    
    private init() {
        if #available(iOS 12.0, *) {
            netInfo = GTNetMonNetworkBased()

        } else {
            netInfo = GTNetMonReachabilityBased()
        }
    }
    
    
    deinit {
        netInfo = nil
    }
    
    
    
    // MARK: - Required Methods
    
    
    /**
     It starts monitoring for network status changes.
     
     Even though you can start monitoring anywhere in your app, it is recommended
     to do so in the `applicationDidBecomeActive(_:)` delegate method in the `AppDelegate`.
     
     Observe for the `GTNetMonNetworkStatusChangeNotification` notification in any class
     you want to be notified about changes in the network status.
     */
    public func startMonitoring() {
        netInfo?.startMonitoring()
    }
    
    
    /**
     It stops monitoring for network status changes.
     
     It is recommended to call this method in the `applicationWillResignActive(_:)` method
     in the `AppDelegate`.
     */
    public func stopMonitoring() {
        netInfo?.stopMonitoring()
    }
    
}



extension GTNetMon {
    
    /**
     It represents the various connection types that a device might be
     using to get connected to Internet.
     
     Available connection types:
    
     * wifi
     * cellular
     * wiredEthernet
     * other
     * undefined
    */
    public enum ConnectionType: CaseIterable, GTStringRepresentable {
        case wifi
        case cellular
        case wiredEthernet
        case other
        case undefined
    }
}




/**
 Observe for the `GTNetMonNetworkStatusChangeNotification` notification so your class
 can receive updates on network status changes.
 */
extension Notification.Name {
    public static let GTNetMonNetworkStatusChangeNotification = Notification.Name(rawValue: "GTNetMonNetworkStatusChangeNotification")
}
