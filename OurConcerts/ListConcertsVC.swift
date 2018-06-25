//
//  ListConcertsVC.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/10/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit
import CoreData

class ListConcertsVC: ourConcertsVC, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Concerts>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        generateTestData()
        tableView.layer.borderWidth = 2.0
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        attemptFetch()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ConcertEdit" {
            if let destinationController = segue.destination as? EditConcertVC {
                if let concert = sender as? Concerts {
                    destinationController.concert = concert
                }
            }
        }
    }
    
    // MARK: TableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections  {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller?.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ConcertCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ListConcertsTableViewCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    var n = 0
    func configureCell(cell: ListConcertsTableViewCell, indexPath: NSIndexPath) {
        let concert = controller.object(at: indexPath as IndexPath)
        cell.configureCell(concert: concert)
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Edit Button
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler: { (action, indexPath) -> Void in
            if let objs = self.controller.fetchedObjects , objs.count > 0 {
                let concert = objs[indexPath.row]
                self.performSegue(withIdentifier: "ConcertEdit", sender: concert)
            }
        })
        return [editAction]
    }

    // MARK: Core Data Support
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest<Concerts> = Concerts.fetchRequest()
        let dateSort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.controller = controller
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch(type) {
        case.insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRow(at: indexPath) as? ListConcertsTableViewCell {
                    configureCell(cell:cell, indexPath: indexPath as NSIndexPath)
                }
            }
            break
        case.move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        }
    }

    func generateTestData() {
        let concert = Concerts(context: context)
        concert.date = ConcertDate(Date()).concertDateString
        concert.rating = 3
        let bsn = BandShortName(context: context)
        bsn.bandShortName = "sci"
        concert.toBandShortName = bsn
        var someDateTime = "2016/10/08"
        let concert2 = Concerts(context: context)
        concert2.date = someDateTime
        concert2.toBandShortName = bsn
        concert.rating = 2
        someDateTime = "2017/12/31"
        let concert3 = Concerts(context: context)
        concert3.date = someDateTime
        concert3.toBandShortName = bsn
        concert.rating = 4
        ad.saveContext()
    }

}
