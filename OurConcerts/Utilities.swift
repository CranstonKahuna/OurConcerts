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
