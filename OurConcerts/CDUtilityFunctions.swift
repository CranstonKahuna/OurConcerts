//
//  CDUtilityFunctions.swift
//  OurConcerts
//  Core Data Utility Functions
//
//  Created by Dean Thomas on 8/14/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import Foundation
import CoreData
import UIKit

func addConcert (bsName: String?, date: String, view: UIViewController) -> Bool {
    if bsName == nil {
        infoAlert(title: "No band name", message: "Cannot add the concert", view: view)
        return false
    }
    let bandShortName = bsName!.trimmingCharacters(in: .whitespacesAndNewlines)
    if bandShortName == "" {
        infoAlert(title: "Empty band name", message: "Cannot add the concert", view: view)
        return false
    }
    if dbDateFormat.dbDateStr2Date(date: date) == nil {
        infoAlert(title: "Unrecognized Date: \(date)", message: "Cannot add the concert", view: view)
        return false
    }
    do {
        let bsn = try fetchBSN(sn: bandShortName)
        let concert = Concerts(context: context)
        concert.date = date
        concert.toBandShortName = bsn
        ad.saveContext()
    } catch {
        let error = error as NSError
        infoAlert(title: "Error looking up band name \(bandShortName)", message: "\(error)", view: view)
        return false
    }
    return true
}

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
            rbsn = BandShortName(context: context)
            rbsn.bandShortName = sn
            ad.saveContext()
        }
    } catch {
        throw(error)
    }
    return rbsn
}

// Fetch all the concerts

func fetchConcerts() -> [Concerts] {
    let fetchRequest: NSFetchRequest<Concerts> = Concerts.fetchRequest()
    do {
        let results = try context.fetch(fetchRequest)
        return results
    } catch {
        print("Failed to fetch concerts")
        let error = error as NSError
        print("\(error)")
        return []
    }
}
