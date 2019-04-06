# GTNetMon

![Platform](https://img.shields.io/cocoapods/p/GTNetMon.svg)
![Language](https://img.shields.io/github/languages/top/gabrieltheodoropoulos/GTNetMon.svg?color=orange)
![License](https://img.shields.io/cocoapods/l/GTNetMon.svg)
![Version](https://img.shields.io/cocoapods/v/GTNetMon.svg)

## About

GTNetMon is a lightweight Swift library that detects whether a device is connected to Internet, it identifies the connection type (wifi, cellular, and more), and monitors for changes in the network status.

## Installation

**Using CocoaPods**

In your Podfile include:

```ruby
pod 'GTNetMon'
```

In Xcode import GTNetMon in any file you want to use it.

```swift
import GTNetMon
```

**Manually *(Not Recommended)***

Download or clone the repository, and add all *swift* files from *GTNetMon* directory to your project.

## Available Properties & Methods

Use **`GTNetMon`** class to access all available properties and methods. It is a singleton class, so use the **`shared`** instance to access its members.

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

In iOS >= 12.0, the new `Network` framework of the iOS SDK is used to retrieve network information. In older iOS versions, `SCNetworkReachability` API is used instead.

### About `GTNetMon.ConnectionType`

`GTNetMon.ConnectionType` is an *enum* with the following cases:

* wifi
* cellular
* wiredEthernet
* other
* undefined

## Usage Example

See the simple example project in the *Sample* directory for how to use GTNetMon (*ViewController.swift* & *AppDelegate.swift* files).
