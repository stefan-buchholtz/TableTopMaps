//
//  CameraPreview.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 26.10.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreview: UIView {

    var session: AVCaptureSession {
        get {
            let previewLayer = self.layer as! AVCaptureVideoPreviewLayer
            return previewLayer.session
        }
        set {
            let previewLayer = self.layer as! AVCaptureVideoPreviewLayer
            previewLayer.session = session
        }
    }
    
    override class func layerClass() -> AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

}
