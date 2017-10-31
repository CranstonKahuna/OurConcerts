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

func addConcertWithAlerts (bsName: String?, date: String, rating: Int16, view: UIViewController) -> Bool {
    let bsn = fetchBSNWithAlerts(sn: bsName, view: view)
    if bsn == nil {
        return false
    }
    do {
        try addConcert(bsn: bsn!, date: date, rating: rating)
    } catch let error as addConcertErrors {
        switch (error) {
        case .unrecognizedDate:
            infoAlert(title: "Unrecognized Date: \(date)", message: "Cannot add the concert", view: view)
            return false
        }
    } catch {
        infoAlert(title: "Error adding concert", message: "Error \(error)", view: view)
    }
    return true
}

func addConcert(bsName: String?, date: String, rating: Int16) throws {
    let bsn =  try fetchBSN(sn: bsName)
    try addConcert(bsn: bsn, date: date, rating: rating)
}

enum addConcertErrors: Error {
    case unrecognizedDate
}

// Overloaded function: This one takes an already validated BandShortName
func addConcert(bsn: BandShortName, date: String, rating: Int16) throws {
     if dbDateFormat.dbDateStr2Date(date: date) == nil {
        throw addConcertErrors.unrecognizedDate
    }
    let concert = Concerts(context: context)
    concert.date = date
    concert.toBandShortName = bsn
    concert.rating = rating
    ad.saveContext()
}

// Fetch the Band Short Name core data object for the short name passed
// If the short name passed does not exist, create it

enum bsnErrors: Error {
    case noBandName
    case blankBandName
}

func fetchBSNWithAlerts(sn: String?, view: UIViewController) -> BandShortName! {
    let bsn: BandShortName
    do {
        bsn = try fetchBSN(sn: sn)
        return bsn
    } catch let error as bsnErrors {
        switch error {
        case .noBandName:
            infoAlert(title: "No band name", message: "Cannot add the concert", view: view)
            return nil
        case .blankBandName:
            infoAlert(title: "Blank band name", message: "Cannot add the concert", view: view)
            return nil
        }
    } catch {
        let error = error as NSError
        infoAlert(title: "Error looking up band name \(sn ?? "nil")", message: "\(error)", view: view)
        return nil
    }
}

func fetchBSN(sn: String?) throws -> BandShortName {
    if sn == nil {
        throw bsnErrors.noBandName
    }
    let bandShortName = sn!.trimmingCharacters(in: .whitespacesAndNewlines)
    if bandShortName == "" {
        throw bsnErrors.blankBandName
    }
    
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BandShortName")
    fetchRequest.predicate = NSPredicate(format: "bandShortName == %@", bandShortName)
    let rbsn:BandShortName
    let fetchedBSN = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [BandShortName]
    if fetchedBSN.count > 0 {
        rbsn = fetchedBSN[0]
        
    } else {
        rbsn = BandShortName(context: context)
        rbsn.bandShortName = bandShortName
        ad.saveContext()
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
