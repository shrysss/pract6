//
//  QRViewController.swift
//  Practical6
//
//  Created by Shane-Rhys Chua on 3/12/20.
//

import Foundation
import UIKit
import QRCode


class QRViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtFld: UITextField!
    @IBOutlet weak var QRImg: UIImageView!
    var link = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFld.delegate = self
        
        link = txtFld.text!
        
        QRImg.image = {
            var qr = QRCode(link)
            qr?.size = self.QRImg.bounds.size
            qr?.errorCorrection = .High
            return qr?.image
        }()
    }
    
    @IBAction func loadQR(_ sender: Any) {
       
        link = txtFld.text!
        QRImg.image = {
            var qr = QRCode(link)
            qr?.color = CIColor(rgba: "87004")
            qr?.size = self.QRImg.bounds.size
            qr?.errorCorrection = .High
            return qr?.image
        }()
    }
//    func txtReturn(_ textField: UITextField)->Bool {
//        txtFld.resignFirstResponder()
//        link = txtFld.text!
//        QRImg.image = {
//            var qr = QRCode(link)
//            qr?.color = CIColor(rgba: "87004")
//            qr?.size = self.QRImg.bounds.size
//            qr?.errorCorrection = .High
//            return qr?.image
//        }()
//        return true
//    }
//
    
}
