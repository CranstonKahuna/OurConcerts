//
//  ConcertsExtension.swift
//  OurConcerts
//
//  Created by Dean Thomas on 6/19/18.
//  Copyright © 2018 Dean Thomas. All rights reserved.
//

import Foundation
import CoreData

extension Concerts {
    
    override public func awakeFromInsert() {
        if self.createdAt == nil {
            setPrimitiveValue(NSDate(), forKey: "createdAt")
        }
    }
    
}
