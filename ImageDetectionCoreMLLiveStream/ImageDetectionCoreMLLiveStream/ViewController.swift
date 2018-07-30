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
    
    private let inceptionModel = Inceptionv3()
    private let requests = [VNCoreMLModel]()
    
    let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startLiveVideo()
        createImageRequest()
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
    
    func createImageRequest() {
        guard let model = try? VNCoreMLModel(for: self.inceptionModel.model) else {
            fatalError("Unable to create a CoreML model.")
        }
        
        let request = VNCoreMLRequest(model: model) {request, error
            in
            if error != nil {
                return
            }
            
            guard let observation =  request.results as? [VNClassificationObservation] else {return}
            let classification = observation.map { modelClassification in "\(modelClassification.identifier) " + "\(modelClassification.confidence * 100.0)"}
            DispatchQueue.main.async {
                self.textView.text = classification.joined(separator: "\n")
            }
        }
        
    }


}

