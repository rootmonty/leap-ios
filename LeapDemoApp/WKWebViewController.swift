//
//  WKWebViewController.swift
//  LeapDemoApp
//
//  Created by Ajay S on 23/02/21.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    
    var wkWebView: WKWebView?
    
    var webUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// configuration property for webview of type WKWebViewConfiguration.
        let configuration = WKWebViewConfiguration()
        self.wkWebView = WKWebView(frame: .zero, configuration: configuration)
        self.view.addSubview(wkWebView!)
        configureWebView()
        wkWebView?.load(URLRequest(url: URL(string: webUrl!)!))
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
}
