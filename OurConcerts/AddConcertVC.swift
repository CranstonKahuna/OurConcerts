//
//  ViewController.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/9/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit
import CoreData

// The duration, in microseconds, that the alert will show after hitting "Add"
let _addAlertTime:useconds_t = 1000000

class AddConcertVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var bandShortNameLbl: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var couchTourBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        bandShortNameLbl.delegate = self
        bandShortNameLbl.autocapitalizationType = .none
        bandShortNameLbl.autocorrectionType = .no
        bandShortNameLbl.spellCheckingType = .no
        datePicker.setValue(UIColor.white, forKey: "textColor")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveBtnPressed(_ sender: Any) {
        let bsn = bandShortNameLbl!.text
        let cDate = ConcertDate(datePicker.date)
        if addConcertWithAlerts(bsName: bsn, cDate: cDate, rating: ratingControl.rating, view:self) {
            let dF = DateFormatter()
            dF.dateStyle = .long
            dF.timeStyle = .none
            let dispDate = dF.string(from: cDate.concertDate)
            let alertController = UIAlertController(title: "Added \(bsn!)\n\(dispDate)", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            self.present(alertController, animated: true)  { () in
                usleep(_addAlertTime)
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func couchTourBtnPressed(_ sender: UIButton) {
        if couchTourBtn.isSelected {
            couchTourBtn.isSelected = false
        } else {
            couchTourBtn.isSelected = true
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

