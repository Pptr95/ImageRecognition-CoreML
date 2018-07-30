//
//  ViewController.swift
//  ComputerVision
//
//  Created by Valerio Potrimba on 29/07/2018.
//  Copyright © 2018 Petru Potrimba. All rights reserved.
//
import CoreML
import Vision
import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var picture: UIImageView!
    @IBAction func selectPhoto(_ sender: UIButton) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    private let imagePicker = UIImagePickerController()
    private let model = GoogLeNetPlaces()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let pickedImage =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        self.picture.image = pickedImage
        self.processImage(image: pickedImage )
    }

     func processImage(image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to convert UIImage tu CIImage.")
        }
        guard let visionModel = try? VNCoreMLModel(for: self.model.model) else {fatalError("Unable to create VisionModel")}
        let visionRequest = VNCoreMLRequest(model: visionModel) {request, error
            in
            //TODO
        }
        let visionRequestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .up, options: [:])
        DispatchQueue.global(qos: .userInteractive).async {
            try! visionRequestHandler.perform([visionRequest])
        }
    }
}

