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
        datePicker.setValue(UIColor.white, forKey: "textColor")

        if concert != nil  {
            var dbDate = dbDateFormat.dbDateStr2Date(date: concert!.date!)
            if dbDate == nil {
                dbDate = Date()
            }
            datePicker.date = dbDate!
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
    
/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 */
    
    // MARK: Button Actions

    @IBAction func saveBtnPressed(_ sender: Any) {
        if let bandShortName = bandShortNameLbl.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if bandShortName == "" {
                infoAlert(title: "Blank band name", message: "Cannot add the concert", view: self)
                return
            }
            do {
                let bsn = try fetchBSN(sn: bandShortName)
                concert!.date = dbDateFormat.date2DBDateStr(date: datePicker.date)
                concert!.toBandShortName = bsn
                concert!.rating = ratingControl.rating
                ad.saveContext()
            } catch {
                let error = error as NSError
                fatalError("Failed to fetch bandShortName from edit: \(error)")
            }
        navigationController?.popViewController(animated: true)
        }
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
