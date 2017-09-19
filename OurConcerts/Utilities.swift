//
//  Utilities.swift
//  OurConcerts
//
//  Created by Dean Thomas on 9/18/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import Foundation

let dbDateFormat = DBDateFormat()

class DBDateFormat {
    
    private let _dateStringFormat = "yyyy/MM/dd"
    private let _dateFormatter = DateFormatter()
    
    var dateStringFormat: String {
        get {
            return _dateStringFormat
        }
    }

    init() {
        _dateFormatter.dateFormat = _dateStringFormat
    }

    // String to Date
    // returns nil if the string cannot be parsed
    func dbDateStr2Date(date: String) -> Date? {
        return _dateFormatter.date(from: date)
    }
    
    // Date to String
    func date2DBDateStr(date: Date) -> String {
        return _dateFormatter.string(from: date)
    }
}
