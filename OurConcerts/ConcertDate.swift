//
//  ConcertDate.swift
//  OurConcerts
//
//  Created by Dean Thomas on 11/22/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import Foundation

private let _dateStringFormat = "yyyy/MM/dd"

struct ConcertDate {
    
    private let _dateFormatter = DateFormatter()
    
    private var _concertDateString: String
    
    init(_ date: Date) {
        _dateFormatter.dateFormat = _dateStringFormat
        _concertDateString = _dateFormatter.string(from: date)
    }
    
    init?(_ dateStr: String) {
        _dateFormatter.dateFormat = _dateStringFormat
        if let _ = _dateFormatter.date(from: dateStr) {
            _concertDateString = dateStr
        } else {
            return nil
        }
    }
    
    var concertDate: Date { get {
        return _dateFormatter.date(from: _concertDateString)!
        }}
    
    var concertDateString: String { get {
        return _concertDateString
        }}
}
