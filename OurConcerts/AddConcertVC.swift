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
    
    func fetchBSN(sn: String) throws -> BandShortName {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BandShortName")
        fetchRequest.predicate = NSPredicate(format: "bandShortName == %@", sn)
        let rbsn:BandShortName
        do {
            let fetchedBSN = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [BandShortName]
            if fetchedBSN.count > 0 {
                rbsn = fetchedBSN[0]
                
            } else {
                let bsn = BandShortName(context: context)
                bsn.bandShortName = sn
                rbsn = bsn
                ad.saveContext()
            }
        } catch {
            throw(error)
        }
        return rbsn
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
                fatalError("Failed to fetch bandShortName: \(error)")
            }
        }
        
    }
}

