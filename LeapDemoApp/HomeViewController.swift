//
//  HomeViewController.swift
//  LeapDemoApp
//
//  Created by Ajay S on 23/02/21.
//

import AVFoundation
import UIKit
import LeapCreatorSDK
import LeapCoreSDK
import LeapAUISDK

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue("dd", forKey: "aa")
        
        let leapCameraViewController = LeapCreator.shared.openSampleApp(delegate: self)

        self.navigationController?.present(leapCameraViewController, animated: true, completion: nil)
        
        view.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }

    func found(infoDict: Dictionary<String, Any>) {
        
        if let platformType = infoDict["platformType"] as? String, platformType == "IOS", let owner = infoDict["owner"] as? String, owner == "LEAP" {
            
           UserDefaults.standard.setValue(infoDict, forKey: "infoDict")
            
            LeapAUI.shared.buildWith(apiKey: Bundle.main.infoDictionary?["APP_API_KEY"] as! String)
            .addProperty("username", stringValue: "Aravind")
            .addProperty("age", intValue: 30)
            .addProperty("ts", dateValue: Date()).start()
            LeapCreator.shared.initialize(withToken: Bundle.main.infoDictionary?["APP_API_KEY"] as! String)
                    
           performSegue(withIdentifier: "webpage", sender: infoDict)
        
        } else {
            
            let wrongQRAlert = UIAlertController(title: "QR not matched", message: "Please scan a QR for an iOS App", preferredStyle: .alert)
            wrongQRAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(wrongQRAlert, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "webpage",
              let _ = sender as? Dictionary<String,Any>,
              let _ = segue.destination as? WKWebViewController else { return }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension HomeViewController: SampleAppDelegate {
    func sendInfo(infoDict: Dictionary<String, Any>) {
        found(infoDict: infoDict)
    }
}
