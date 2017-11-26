//
//  EditConcertVC.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/11/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit

class EditConcertVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bandShortNameLbl: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var concert: Concerts?

    override func viewDidLoad() {
        super.viewDidLoad()
        bandShortNameLbl.delegate = self
        bandShortNameLbl.autocapitalizationType = .none
        bandShortNameLbl.autocorrectionType = .no
        bandShortNameLbl.spellCheckingType = .no
        datePicker.setValue(UIColor.white, forKey: "textColor")

        if concert != nil  {
            var cDate = ConcertDate(concert!.date!)
            if cDate == nil {
                cDate = ConcertDate(Date())
            }
            datePicker.date = cDate!.concertDate
            let shortName = concert?.toBandShortName?.bandShortName
            if shortName == nil {
                bandShortNameLbl.text = "Unknown"
            } else {
                bandShortNameLbl.text = concert?.toBandShortName?.bandShortName
            }
            if let rating = concert?.rating {
                ratingControl.rating = rating
            }
        }

        // Do any additional setup after loading the view.
//        if let topItem = self.navigationController?.navigationBar.topItem {
//            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popViewController(animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button Actions

    @IBAction func saveBtnPressed(_ sender: Any) {
        let newCDate = ConcertDate(datePicker.date)
//        let newDate = dbDateFormat.date2DBDateStr(date: datePicker.date)
        let newSN = stringToBSNWithAlerts(bandShortNameLbl.text, view: self)
        if newSN == nil {
            return
        }
        // Has the user changed the band or the date?
        var bsn: BandShortName? = nil
        if newSN!.lowercased() != concert!.toBandShortName?.bandShortName?.lowercased()
           || newCDate.concertDateString != concert!.date {
            // check if this is now a duplicate of an existing entry
            do {
                bsn = try bsnExists(newSN!)
                if bsn != nil {
                    let oldConcert = try fetchThisConcert(cDate: newCDate, bsn: bsn!)
                    if oldConcert != nil {
                        let alertC = UIAlertController(title: "Duplicate Concert", message: "You already entered this concert", preferredStyle: UIAlertControllerStyle.alert)
                        alertC.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                        alertC.addAction(UIAlertAction(title: "Replace Existing", style: UIAlertActionStyle.default) { alertC in
                            oldConcert!.rating = self.ratingControl.rating
                            if self.concert != nil {
                                context.delete(self.concert!)
                            }
                            ad.saveContext()
                            self.navigationController?.popViewController(animated: true)
                        })
                        alertC.addAction(UIAlertAction(title: "Add Duplicate", style: UIAlertActionStyle.default) { alertC in
                            self.concert!.date = newCDate.concertDateString
                            self.concert!.toBandShortName = bsn
                            self.concert!.rating = self.ratingControl.rating
                            ad.saveContext()
                            self.navigationController?.popViewController(animated: true)

                        })
                        self.present(alertC, animated: true, completion: nil)
                        return
                    }
                }
            } catch {
                infoAlert(title: "Edit error", message: "\(error)", view: self)
            }
        }
        
        if bsn == nil {
            bsn = fetchBSNWithAlerts(newSN, view: self)
        }
        // if bsn is still nil, something terrible has happened.
        if bsn == nil {
            return
        }
        concert!.date = newCDate.concertDateString
        concert!.toBandShortName = bsn
        concert!.rating = ratingControl.rating
        ad.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        if concert != nil {
            context.delete(concert!)
            ad.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
