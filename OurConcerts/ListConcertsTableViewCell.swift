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
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var couchTourLbl: UILabel!
    
    func configureCell(concert: Concerts)  {
        //update cell
        var cDate = ConcertDate(concert.date!)
        if cDate == nil {
            cDate = ConcertDate(Date())
        }
        _dateFormatter.dateStyle = .long
        _dateFormatter.timeStyle = .none
        
        dateLbl.text = _dateFormatter.string(from: cDate!.concertDate)
        bandName.text = concert.toBandShortName?.bandShortName
        let rating = concert.rating
        if rating >= 0 && rating < 6 {
            ratingControl.rating = concert.rating
        } else {
            ratingControl.rating = 0
        }
        if concert.couchTour {
            couchTourLbl.text = "✓ Couch Tour"
        } else {
            couchTourLbl.text = ""
        }
    }
}
