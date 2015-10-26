//
//  NewMapViewController.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 20.10.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import UIKit
import AVFoundation

class NewMapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    weak var mapListViewController: MapListViewController?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var liveCameraView: UIView!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    let okButton = UIBarButtonItem(title: "Ok", style: .Plain, target: nil, action: "ok:")
    var videoCaptureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        okButton.target = self
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
        self.navigationItem.rightBarButtonItem = okButton
        
        liveCameraView.hidden = !startCameraPreview()

        validateControls()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        stopCameraPreview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func nameFieldChanged(sender: AnyObject) {
        validateControls()
    }
    
    func ok(sender: AnyObject) {
        mapListViewController?.newMap(nameField.text!)
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)        
    }
    
    func cancel(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func validateControls() {
        okButton.enabled = nameField.text != nil && nameField.text != ""
    }
    
    func startCameraPreview() -> Bool {
        videoCaptureSession = AVCaptureSession()
        videoCaptureSession!.sessionPreset = AVCaptureSessionPresetMedium
        
        let captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: videoCaptureSession)
        captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureVideoPreviewLayer.frame = liveCameraView.bounds
        liveCameraView.layer.addSublayer(captureVideoPreviewLayer)
        
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            videoCaptureSession!.addInput(input)
            videoCaptureSession!.startRunning()
            return true
        } catch {
            let nserror = error as NSError
            NSLog(nserror.description)
            return false
        }
    }
    
    func stopCameraPreview() {
        videoCaptureSession?.stopRunning()
        videoCaptureSession = nil
    }
    
    // MARK: - UICollectionView

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewImageCell", forIndexPath: indexPath)
        return cell
    }
    
}
