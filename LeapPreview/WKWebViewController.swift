//
//  WKWebViewController.swift
//  LeapPreview
//
//  Created by Ajay S on 23/02/21.
//

import UIKit
import WebKit
import LeapSDK
import LeapCoreSDK
import LeapCreatorSDK

class WKWebViewController: UIViewController {
    
    var wkWebView: WKWebView?
    
    var leapCameraViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        /// configuration property for webview of type WKWebViewConfiguration.
        let configuration = WKWebViewConfiguration()
        self.wkWebView = WKWebView(frame: .zero, configuration: configuration)
        self.view.addSubview(wkWebView!)
        configureWebView()
        
        let connectedAppInfo = UserDefaults.standard.object(forKey: constant_sampleAppInfoDict) as? Dictionary<String, Any>
        
        openCameraViewController(isRescan: connectedAppInfo == nil ? true : false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(push), name: .init(constant_rescan), object: nil)
    }
    
    func configureWebView() {
        
        wkWebView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))

        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))

        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0))

        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0))
    }
    
    func openCameraViewController(isRescan: Bool) {
        
        UserDefaults.standard.setValue(isRescan, forKey: constant_sampleAppRescan)
        leapCameraViewController = LeapCreator.shared.openSampleApp(delegate: self)
        guard leapCameraViewController != nil else { return }
        leapCameraViewController?.modalPresentationStyle = .fullScreen
        if isRescan {
            DispatchQueue.main.async {
                self.present(self.leapCameraViewController!, animated: true, completion: nil)
            }
        }
    }
    
    func found(infoDict: Dictionary<String, Any?>) {
        
        if let platformType = infoDict[constant_platformType] as? String, platformType == constant_IOS, let owner = infoDict[constant_owner] as? String, owner == constant_LEAP, let apiKey = infoDict[constant_apiKey] as? String {
            
            leapCameraViewController?.dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.setValue(infoDict, forKey: constant_sampleAppInfoDict)
            
            Leap.shared.start(apiKey)
            LeapCreator.shared.start(apiKey)
            
            if let infoDict = (UserDefaults.standard.object(forKey: constant_sampleAppInfoDict) as? Dictionary<String,Any>), let url = infoDict[constant_webUrl] as? String {
                wkWebView?.load(URLRequest(url: URL(string: url)!))
            }
            
        } else {
            
            let wrongQRAlert = UIAlertController(title: constant_QRErrorTitle, message: constant_QRErrorMessage, preferredStyle: .alert)
            wrongQRAlert.addAction(UIAlertAction(title: constant_OK, style: .default))
            present(wrongQRAlert, animated: true)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func push() {
        
        openCameraViewController(isRescan: true)
            
        Leap.shared.disable()
    }
}

extension WKWebViewController: SampleAppDelegate {
    func sendInfo(infoDict: Dictionary<String, Any>) {
        DispatchQueue.main.async {
            self.found(infoDict: infoDict)
        }
    }
}
