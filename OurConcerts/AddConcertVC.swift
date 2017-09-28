//
//  ViewController.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/9/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit
import CoreData

class AddConcertVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bandShortNameLbl: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bandShortNameLbl.delegate = self
        datePicker.setValue(UIColor.white, forKey: "textColor")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveBtnPressed(_ sender: Any) {
        if let bandShortName = bandShortNameLbl.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            do {
                let bsn = try fetchBSN(sn: bandShortName)
                let concert = Concerts(context: context)
                concert.date = dbDateFormat.date2DBDateStr(date: datePicker.date)
                concert.toBandShortName = bsn
                ad.saveContext()
            } catch {
                let error = error as NSError
                infoAlert(title: "Failed to fetch bandShortName from add: \(error)", message: "\(error)", view: self)
            }
        }
        
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

