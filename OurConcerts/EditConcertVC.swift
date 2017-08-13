//
//  EditConcertVC.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/11/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit

class EditConcertVC: UIViewController {
    

    @IBOutlet weak var nameLbl: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var concert: Concerts? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        if concert != nil  {
            print("EditConcert \(concert!)")
            datePicker.date = concert!.date! as Date
        }

        // Do any additional setup after loading the view.
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

}
