//
//  Utilities.swift
//  OurConcerts
//
//  Created by Dean Thomas on 9/18/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import Foundation
import UIKit

let dbDateFormat = DBDateFormat()

class DBDateFormat {
    
    private let _dateStringFormat = "yyyy/MM/dd"
    private let _dateFormatter = DateFormatter()
    
    var dateStringFormat: String {
        get {
            return _dateStringFormat
        }
    }

    init() {
        _dateFormatter.dateFormat = _dateStringFormat
    }

    // String to Date
    // returns nil if the string cannot be parsed
    func dbDateStr2Date(date: String) -> Date? {
        return _dateFormatter.date(from: date)
    }
    
    // Date to String
    func date2DBDateStr(date: Date) -> String {
        return _dateFormatter.string(from: date)
    }
}

func infoAlert(title: String?, message: String?, view: UIViewController) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,
                                            handler: {(alert: UIAlertAction!) in view.navigationController?.popViewController(animated: true)}))
    view.present(alertController, animated: true, completion: nil)
}
