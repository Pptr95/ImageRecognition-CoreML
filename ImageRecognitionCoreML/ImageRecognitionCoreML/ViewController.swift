//
//  ViewController.swift
//  ImageRecognitionCoreML
//
//  Created by Valerio Potrimba on 29/07/2018.
//  Copyright © 2018 Petru Potrimba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recognizeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func next(_ sender: UIButton) {
        let img = UIImage(named: self.images[self.current])
        self.imageView.image = img
        self.current = (self.current + 1) % self.images.count
        let resizedImage = img?.resizeTo(size: CGSize(width: 224, height: 224))
        let bufferedImage = resizedImage?.toBuffer()
        let prediction = try! self.model.prediction(input: InceptionV1Input(input__0: bufferedImage!))
        
        self.recognizeLabel.text = prediction.classLabel
    }
    
    let images = ["dog.jpg", "cat.jpg", "rat.jpg", "banana.jpg"]
    var current: Int = 0
    private var model: InceptionV1 = InceptionV1()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
        
    }
    
    func toBuffer() -> CVPixelBuffer? {
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }

}
