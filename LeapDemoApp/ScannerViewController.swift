//
//  ScannerViewController.swift
//  LeapDemoApp
//
//  Created by Ajay S on 23/02/21.
//

import AVFoundation
import UIKit
import UserNotifications

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var openCameraButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var qrDemoIcon: UIImageView!
    
    var scannerView: UIView?
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        openCameraButton.layer.cornerRadius = openCameraButton.frame.height/2
        
        let rescanAction = UNNotificationAction(identifier: "rescan",
              title: "Rescan",
              options: UNNotificationActionOptions(rawValue: 0))
        
        let scanSuccessCategory = UNNotificationCategory(identifier: "scanSuccess", actions: [rescanAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([scanSuccessCategory])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    @IBAction func openCamera(_ sender: Any) {
        
        configureScannerView()
               
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height * 0.5)
        previewLayer.videoGravity = .resizeAspectFill
        scannerView?.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    func configureScannerView() {
        
        self.scannerView = UIView(frame: .zero)
        
        self.view.addSubview(scannerView!)
                
        self.scannerView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraint(NSLayoutConstraint(item: self.scannerView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.scannerView!, attribute: .top, relatedBy: .equal, toItem: self.scannerView!, attribute: .top, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.scannerView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.scannerView!, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.5, constant: 0))
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue,
                  let data = stringValue.data(using: .utf8),
                  let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String,Any>  else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            captureSession.stopRunning()
            found(infoDict: jsonObject)
        }

        dismiss(animated: true)
    }

    func found(infoDict: Dictionary<String, Any>) {
        
        if let platformType = infoDict["platformType"] as? String, platformType == "IOS" {
        
           triggerNotification(infoDict: infoDict)
        
           performSegue(withIdentifier: "webpage", sender: infoDict)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "webpage",
              let infoDict = sender as? Dictionary<String,Any>,
              let wkweb = segue.destination as? WKWebViewController else { return }
        wkweb.webUrl = infoDict["webUrl"] as? String
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}


