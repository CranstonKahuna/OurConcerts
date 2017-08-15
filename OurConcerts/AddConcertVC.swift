//
//  ViewController.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/9/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit
import CoreData

class AddConcertVC: UIViewController {

    @IBOutlet weak var bandShortNameLbl: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
                concert.date = datePicker.date as NSDate
                concert.toBandShortName = bsn
                ad.saveContext()
            } catch {
                let error = error as NSError
                fatalError("Failed to fetch bandShortName from add: \(error)")
            }
        }
        
    }
}

