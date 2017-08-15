//
//  CDUtilityFunctions.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/14/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import Foundation
import CoreData

// Fetch the Band Short Name core data object for the short name passed
// If the short name passed does not exist, create it

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
