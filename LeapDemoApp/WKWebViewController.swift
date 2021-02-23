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
        
        /// javascript to adjust width according to native view.
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        
        /// preferences property for webview of type WKPreferences.
        let preferences = WKPreferences()
        
        /// configuration property for webview of type WKWebViewConfiguration.
        let configuration = WKWebViewConfiguration()
        
        let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        configuration.userContentController.addUserScript(userScript)
        
        let jsCallBack = "iosListener"
        configuration.userContentController.add(self, name: jsCallBack)
        configuration.allowsInlineMediaPlayback = true
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        configuration.dataDetectorTypes = [.all]

        
        self.wkWebView = WKWebView(frame: .zero, configuration: configuration)
        self.wkWebView?.scrollView.isScrollEnabled = false
        self.wkWebView?.navigationDelegate = self
        
        self.view.addSubview(wkWebView!)
    }
    
    func configureWebView() {
        
        wkWebView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))

        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))

        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0))

        self.view.addConstraint(NSLayoutConstraint(item: wkWebView!, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0))
    }
    
    func loadContent(htmlUrl: String, appLocale: String, contentFileUriMap: Dictionary<String, String>?) {
        
        // Loading the html source file from the main project bundle
        guard let _ = URL(string: htmlUrl) else {
            
            let bundle = Bundle(for: type(of: self))
            
            if let url = bundle.url(forResource: appLocale, withExtension: "html") {
                wkWebView?.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            }
            
            return
        }
        
        let url = URL(string: webUrl!)!
        let request = URLRequest(url: url)
        wkWebView?.load(request)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WKWebViewController: WKScriptMessageHandler, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
