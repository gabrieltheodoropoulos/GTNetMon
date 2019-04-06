//
//  GTNetMonReachabilityBased.swift
//  GTNetMon
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2019 Gabriel Theodoropoulos. All rights reserved.
//

import Foundation
import SystemConfiguration

// Credits to: https://www.invasivecode.com/weblog/network-reachability-in-swift/
// Credits to: https://stackoverflow.com/questions/30743408/check-for-internet-connection-with-swift

class GTNetMonReachabilityBased: GTNetMonProvider {
    
    // MARK: - Required Properties
    
    var connectionType: GTNetMon.ConnectionType {
        if getReachabilityStatus() == .wifi {
            return .wifi
        } else if getReachabilityStatus() == .wwan {
            return .cellular
        } else {
            return .undefined
        }
    }
    
    var availableConnectionTypes: [GTNetMon.ConnectionType] {
        return []
    }
    
    var isConnected: Bool {
        if getReachabilityStatus() != .notReachable {
            return true
        } else {
            return false
        }
    }
    
    var isExpensive: Bool {
        if getReachabilityStatus() == .wwan {
            return true
        } else {
            return false
        }
    }
    
    var isMonitoring: Bool = false
    
    
    
    // MARK: - Other Properties
    
    private var reachability: SCNetworkReachability?
    
    
    // MARK: - Inner Structures
    enum ReachabilityStatus {
        case notReachable
        case wifi
        case wwan
    }
    
    
    
    // MARK: - Init & Deinit
    
    init() {
        setupReachability()

        // Observe for the following notification which is sent and received
        // internally in this class.
        NotificationCenter.default.addObserver(self, selector: #selector(handleNetworkStatusChange(notification:)), name: NSNotification.Name(rawValue: "GTNetMonNetworkStatusChanged"), object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        stopMonitoring()
    }
    
    
    // MARK: - Private Methods
    
    /**
     It creates a reachability instance which is used to determine whether Internet
     connection exists and the connection type.
     
     Reachability instance is assigned to the `reachability` property.
    */
    private func setupReachability() {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            }
        }) else {
            return
        }
        
        reachability = defaultRouteReachability
    }
    
    
    
    /**
     It gets and returns the reachability flags for the current network configuration.
     
     - Returns: A `SCNetworkReachabilityFlags` value.
    */
    private func getReachabilityFlags() -> SCNetworkReachabilityFlags {
        guard let reachability = reachability else { return SCNetworkReachabilityFlags(rawValue: 0) }
        
        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        SCNetworkReachabilityGetFlags(reachability, &flags)
        return flags
    }
    
    
    
    /**
     It returns the reachability status based on the reachability flags for the current
     network configuration.
     
     - Seealso: `getReachabilityFlags()`
     
     - Returns: A `ReachabilityStatus` value.
    */
    private func getReachabilityStatus() -> ReachabilityStatus {
        let flags = getReachabilityFlags()
        
        if !flags.contains(.reachable) {
            return .notReachable
        } else {
            // Reachable.
            if flags.contains(.isWWAN) {
                return .wwan
            } else if !flags.contains(.connectionRequired) {
                return .wifi
            } else if (flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)) && !flags.contains(.interventionRequired) {
                return .wifi
            } else {
                return .notReachable
            }
        }
    }
    
    
    
    /**
     It handles the "GTNetMonNetworkStatusChanged" notification that is sent and received
     within this class.
     
     GTNetMonNetworkStatusChanged is posted whenever a network status change occurs. That
     notification brings along the updated reachability (SCNetworkReachability) value, which
     is assigned to the `reachability` propery.
     
     Then, it posts the GTNetMonNetworkStatusChangeNotification notification to notify the client
     app that network status changes have occurred.
    */
    @objc func handleNetworkStatusChange(notification: Notification) {
        if let reachability = notification.object {
            self.reachability = (reachability as! SCNetworkReachability)
            
            // Post the following notification that will notify the client app
            // on the main thread.
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .GTNetMonNetworkStatusChangeNotification, object: nil)
            }
        }
    }
    
    
    
    
    func startMonitoring() {
        DispatchQueue.main.async { [weak self] in
            self?.setupReachability()
        }

        guard let reachability = reachability, !isMonitoring else { return }
        
        var context = SCNetworkReachabilityContext()
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        
        if SCNetworkReachabilitySetCallback(reachability, { (networkReachability: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
            
            // Notification that is sent and received within this class.
            // handleNetworkStatusChange(notification:) method will be called upon receiving the following notification
            // once it's posted, and after it updates the reachability property with the new value it will post the
            // GTNetMonNetworkStatusChangeNotification notification to notify the client app about the change on
            // network status.
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GTNetMonNetworkStatusChanged"), object: networkReachability)
            
        }, &context) {
            // Callback was set successfully, schedule monitoring of changes on reachability.
            if SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue) {
                // On success, indicate that network status changes are being monitored.
                isMonitoring = true
            }
        }
    }
    
    
    
    func stopMonitoring() {
        guard let reachability = reachability, isMonitoring, let runLoop = CFRunLoopGetCurrent(), let loopMode = CFRunLoopMode.defaultMode  else { return }
        _ = SCNetworkReachabilityUnscheduleFromRunLoop(reachability, runLoop, loopMode.rawValue)
        isMonitoring = false
    }
}
