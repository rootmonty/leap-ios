//
//  WKWebViewController.swift
//  LeapDemoApp
//
//  Created by Ajay S on 23/02/21.
//

import UIKit
import WebKit
import LeapAUISDK
import LeapCoreSDK

class WKWebViewController: UIViewController {
    
    var wkWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// configuration property for webview of type WKWebViewConfiguration.
        let configuration = WKWebViewConfiguration()
        self.wkWebView = WKWebView(frame: .zero, configuration: configuration)
        self.view.addSubview(wkWebView!)
        configureWebView()
        if let infoDict = (UserDefaults.standard.object(forKey: "infoDict") as? Dictionary<String,Any>), let url = infoDict["webUrl"] as? String {
           wkWebView?.load(URLRequest(url: URL(string: url)!))
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(pop), name: .init("rescan"), object: nil)
    }
    
    func configureWebView() {
        
        wkWebView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))

        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))

        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0))

        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0))
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func pop() {
        
        self.navigationController?.viewControllers.first?.view.isHidden = false
        if let homeViewController = self.navigationController?.viewControllers.first as? HomeViewController {
              homeViewController.reload = true
            }
        LeapAUI.shared.disable()
        
        self.navigationController?.popViewController(animated: true)
    }
}
