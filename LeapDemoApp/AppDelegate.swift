//
//  AppDelegate.swift
//  LeapDemoApp
//
//  Created by Ajay S on 23/02/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Request user's permission to send notifications.
        
        if let _ =
            launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? NSDictionary {
            
            let appState: UIApplication.State = UIApplication.shared.applicationState

            if appState == .active || appState == .inactive {
                
                registerLocalNotification()
            }
            
        } else {
            
            registerLocalNotification()
        }
        
        UNUserNotificationCenter.current().delegate = self
                
        return true
    }
    
    func registerLocalNotification() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notifications permission granted.")
            }
            else {
                print("Notifications permission denied because: \(error?.localizedDescription).")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        switch response.actionIdentifier {
        case "rescan":
            let rootVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
            
            if let vc = rootVC?.visibleViewController as? WKWebViewController {
                
                vc.pop()
            }
        default:
            break
        }
        completionHandler()
    }
}

