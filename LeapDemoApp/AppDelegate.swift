//
//  AppDelegate.swift
//  LeapDemoApp
//
//  Created by Ajay S on 23/02/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

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
                let rescanAction = UNNotificationAction(identifier: "rescan",
                      title: "Rescan",
                      options: UNNotificationActionOptions(rawValue: 0))
                
                let scanSuccessCategory = UNNotificationCategory(identifier: "scanSuccess", actions: [rescanAction], intentIdentifiers: [], options: [])
                
                UNUserNotificationCenter.current().setNotificationCategories([scanSuccessCategory])
            }
            else {
                print("Notifications permission denied because: \(error?.localizedDescription ?? "Unknown").")
            }
        }
    }
    
    func triggerNotification(infoDict: Dictionary<String, Any>) {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
         
        guard settings.authorizationStatus == .authorized else { return }
                    
        let content = UNMutableNotificationContent()
                    
        content.categoryIdentifier = "scanSuccess"

        if let appName = infoDict["appName"] as? String {
           content.title = appName
           content.subtitle = "connected"
        }
                    
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: nil)
                                
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
            
            if let wkWebController = rootVC?.visibleViewController as? WKWebViewController {
                
                wkWebController.pop()
            }
        default:
            break
        }
        completionHandler()
    }
}

