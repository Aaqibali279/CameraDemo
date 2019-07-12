//
//  ViewController.swift
//  AV Foundation
//
//  Created by Pranjal Satija on 5/22/17.
//  Copyright © 2017 Pranjal Satija. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet fileprivate var captureButton: UIButton!
    @IBOutlet weak var iv:UIImageView!
    @IBOutlet fileprivate var capturePreviewView: UIView!
    
    var cameraController = CameraController()
    
    override var prefersStatusBarHidden: Bool { return true }
    
    
}

extension ViewController {
    override func viewDidLoad() {
        
        func styleCaptureButton() {
            captureButton.layer.borderColor = UIColor.black.cgColor
            captureButton.layer.borderWidth = 2
            
            captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
        }
        
        styleCaptureButton()
        configureCameraController()
        
    }
    
    func configureCameraController() {
        
        cameraController.prepare {(error) in
            if let error = error {
                print(error)
            }
            
            try? self.cameraController.displayPreview(on: self.capturePreviewView)
        }
    }
}

extension ViewController {
   
    @IBAction func captureImage(_ sender: UIButton) {
        cameraController.captureImage { [weak self](image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            
            try? PHPhotoLibrary.shared().performChangesAndWait {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
            self?.iv.isHidden = false
            self?.iv.image = image
            
            self?.configureCameraController()
        }
    }
    
    @IBAction func flashAction(_ sender: UIButton) {
        let isOn = cameraController.setFlash()
        sender.setImage(isOn ? #imageLiteral(resourceName: "Flash On Icon") : #imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
    }
    
}

