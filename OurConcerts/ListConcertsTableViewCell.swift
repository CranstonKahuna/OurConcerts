//
//  ListConcertsCellTableViewCell.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/10/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit

let _dateFormatter = DateFormatter()

class ListConcertsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var bandName: UILabel!

    func configureCell(concert: Concerts)  {
        //update cell
        var cdate = dbDateFormat.dbDateStr2Date(date: concert.date!)
        if cdate == nil {
            cdate = Date()
        }
        _dateFormatter.dateStyle = .long
        _dateFormatter.timeStyle = .none
        
        dateLbl.text = _dateFormatter.string(from: cdate!)
        bandName.text = concert.toBandShortName?.bandShortName
    }
}
