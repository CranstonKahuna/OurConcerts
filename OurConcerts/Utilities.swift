//
//  Utilities.swift
//  OurConcerts
//
//  Created by Dean Thomas on 9/18/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import Foundation
import UIKit

// Displays a simple "OK" alert and pops the current view
func infoAlert(title: String?, message: String?, view: UIViewController, completion: (() -> Void)? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,
                                            handler: {(alert: UIAlertAction!) in view.navigationController?.popViewController(animated: true)}))
    view.present(alertController, animated: true, completion: nil)
}

let myColor1Hex = 0x011993 // Midnight
// Creates my gradient
func createGradientLayer(_ gradientLayer: CAGradientLayer, vc: UIViewController) {
    let r1 = CGFloat((myColor1Hex >> 16) & 0xFF) / 255.0
    let g1 = CGFloat((myColor1Hex >> 8) & 0xFF) / 255.0
    let b1 = CGFloat(myColor1Hex & 0xFF) / 255.0
    let myColor1 = UIColor(red: r1, green: g1, blue: b1, alpha: 1.0)
    gradientLayer.frame = vc.view.bounds
    gradientLayer.colors = [myColor1.cgColor, UIColor.red.cgColor]
    vc.view.layer.insertSublayer(gradientLayer, at: 0)
}
