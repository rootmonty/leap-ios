//
//  NotificationViewController.swift
//  Custom Notification Extension
//
//  Created by Ajay S on 24/02/21.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var appNameLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
        
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 113)
    }
    
    func didReceive(_ notification: UNNotification) {

        self.appNameLabel.text = notification.request.content.title
        self.statusLabel.text = "Connected"
    }
}
