//
//  ListConcertsVC.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/10/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit

class ListConcertsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    // MARK: TableView functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    var n = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ConcertCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ListConcertsTableViewCell
        cell.dateLbl.text = "Date of concert \(n)"
        cell.bandName.text = "Band name"
        n = n + 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Edit Button
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler: { (action, indexPath) -> Void in
            print("Edit for row \(indexPath.row)")
            
        })
        return [editAction]

    }

}
