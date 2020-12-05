//
//  ScanViewController.swift
//  Practical6
//
//  Created by Shane-Rhys Chua on 6/12/20.
//

import Foundation
import AVFoundation
import UIKit
import QRCodeReader

class ScanViewController : UIViewController, QRCodeReaderViewControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode

    lazy var reader: QRCodeReader = QRCodeReader()
        lazy var readerVC: QRCodeReaderViewController = {
          let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = true
            $0.showSwitchCameraButton = true
            $0.showCancelButton       = true
            $0.showOverlayView        = true
            $0.rectOfInterest          = CGRect(x: 0.2, y: 0.35, width: 0.6, height: 0.3)
            
            $0.reader.stopScanningWhenCodeIsFound = false
          }
          
          return QRCodeReaderViewController(builder: builder)
        }()
        
        
        
        func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
            reader.stopScanning()

            dismiss(animated: true) { [weak self] in
              let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
                preferredStyle: .alert
              )
              alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

              self?.present(alert, animated: true, completion: nil)
            }
        }
        
        private func checkScanPermissions() -> Bool {
          do {
            return try QRCodeReader.supportsMetadataObjectTypes()
          } catch let error as NSError {
            let alert: UIAlertController

            switch error.code {
            case -11852:
              alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)

              alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                DispatchQueue.main.async {
                  if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                  }
                }
              }))

              alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
              alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }

            present(alert, animated: true, completion: nil)

            return false
          }
        }
        
        @IBAction func modalAction(_ sender: Any) {
            //guard checkScanPermissions() else { return }
            readerVC.modalPresentationStyle = .formSheet
            readerVC.delegate               = self

            readerVC.completionBlock = { (result: QRCodeReaderResult?) in
              if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
              }
            }

            present(readerVC, animated: true, completion: nil)
        }
        
        func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
          print("Switching capture to: \(newCaptureDevice.device.localizedName)")
        }

        func readerDidCancel(_ reader: QRCodeReaderViewController) {
          reader.stopScanning()

          dismiss(animated: true, completion: nil)
        }
     
      

}
