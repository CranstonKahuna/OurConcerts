//
//  ListConcertsCellTableViewCell.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/10/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit

var n = 0

class ListConcertsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var bandName: UILabel!


    func configureCell(concert: Concerts)  {
        //update cell
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateLbl.text = dateFormatter.string(from: concert.date! as Date)
        bandName.text = concert.toBandShortName?.bandShortName
    }
}
