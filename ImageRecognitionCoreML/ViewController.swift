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
    }
    
    let images = ["dog.jpg", "cat.jpg", "rat.jpg", "banana.jpg"]
    var current: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

