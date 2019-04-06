//
//  ViewController.swift
//  GTNetMonDemo
//
//  Created by Gabriel Theodoropoulos on 06/04/2019.
//  Copyright © 2019 Gabriel Theodoropoulos. All rights reserved.
//

import UIKit
import GTNetMon

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleStatusChange(notification:)), name: .GTNetMonNetworkStatusChangeNotification, object: nil)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showConnectionInfo()
    }
    
    
    
    @IBAction func getNetworkStatus(_ sender: Any) {
        showConnectionInfo()
    }

    
    
    @objc func handleStatusChange(notification: Notification) {
        self.showConnectionInfo()
    }
    
    
    
    func showConnectionInfo() {
        if !GTNetMon.shared.isConnected {
            textView.textColor = UIColor.red
        } else {
            textView.textColor = UIColor.green
        }
        
        
        textView.text = "Is connected: \(GTNetMon.shared.isConnected)"
        textView.text += "\nAvailable Connection Types:"
        
        for type in GTNetMon.shared.availableConnectionTypes {
            textView.text += "\n  - \(type.toString())"
        }
        
        textView.text += "\n\nCurrent Connection Type: \(GTNetMon.shared.connectionType.toString())"
        
        textView.text += "\nIs Expensive: \(GTNetMon.shared.isExpensive)"
    }
    
}

