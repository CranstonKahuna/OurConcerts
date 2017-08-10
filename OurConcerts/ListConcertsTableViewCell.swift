//
//  ListConcertsCellTableViewCell.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/10/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit

class ListConcertsTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var bandName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
