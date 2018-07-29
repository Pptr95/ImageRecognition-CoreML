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
        let img = UIImage(named: self.images[self.current])?.resizeTo(size: CGSize(width: 299, height: 299))
        self.imageView.image = img
        self.current = (self.current + 1) % self.images.count
    }
    
    let images = ["dog.jpg", "cat.jpg", "rat.jpg", "banana.jpg"]
    var current: Int = 0
    
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
}
