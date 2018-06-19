//
//  ourConcertsVC.swift
//  OurConcerts
//
//  Created by Dean Thomas on 6/19/18.
//  Copyright © 2018 Dean Thomas. All rights reserved.
//

import UIKit

class ourConcertsVC: UIViewController {
    
    let gradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createGradientLayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    let myColor1Hex = 0x011993 // Midnight
    
    // Creates my gradient
    func createGradientLayer() {
        let r1 = CGFloat((myColor1Hex >> 16) & 0xFF) / 255.0
        let g1 = CGFloat((myColor1Hex >> 8) & 0xFF) / 255.0
        let b1 = CGFloat(myColor1Hex & 0xFF) / 255.0
        let myColor1 = UIColor(red: r1, green: g1, blue: b1, alpha: 1.0)
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [myColor1.cgColor, UIColor.red.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }


}
