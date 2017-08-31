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
    
    var concert: Concerts?

    override func viewDidLoad() {
        super.viewDidLoad()
        bandShortNameLbl.delegate = self
        datePicker.setValue(UIColor.white, forKey: "textColor")


        if concert != nil  {
            datePicker.date = concert!.date! as Date
            let shortName = concert?.toBandShortName?.bandShortName
            if shortName == nil {
                bandShortNameLbl.text = "Unknown"
            } else {
                bandShortNameLbl.text = concert?.toBandShortName?.bandShortName
            }
        }
        

        // Do any additional setup after loading the view.
        
//        if let topItem = self.navigationController?.navigationBar.topItem {
//            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
//        }
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

    @IBAction func saveBtnPressed(_ sender: Any) {
        if let bandShortName = bandShortNameLbl.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            do {
                let bsn = try fetchBSN(sn: bandShortName)
                concert!.date = datePicker.date as NSDate
                concert!.toBandShortName = bsn
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
