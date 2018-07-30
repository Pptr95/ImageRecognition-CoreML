//
//  ViewController.swift
//  ImageDetectionCoreMLLiveStream
//
//  Created by Valerio Potrimba on 30/07/2018.
//  Copyright © 2018 Petru Potrimba. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLiveVideo()
    }
    
    private func startLiveVideo() {
        self.session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        let deviceInput = try? AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        
        self.session.addInput(deviceInput!)
        self.session.addOutput(deviceOutput)
        
        let imageLayer = AVCaptureVideoPreviewLayer(session: self.session)
        imageLayer.frame = self.cameraView.bounds
        self.cameraView.layer.addSublayer(imageLayer)
        
        self.session.startRunning()
    }


}

