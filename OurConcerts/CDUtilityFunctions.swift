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

func addConcertWithAlerts (bsName: String?, cDate: ConcertDate, rating: Int16, couchTour: Bool, view: UIViewController) -> Bool {
    let bsn = fetchBSNWithAlerts(bsName, view: view)
    if bsn == nil {
        return false
    }
    do {
        let _ = try addConcert(bsn: bsn!, cDate: cDate, rating: rating, couchTour: couchTour)
    } catch let error as addConcertErrors {
        switch (error) {
        case .duplicateConcert:
            let alertC = UIAlertController(title: "Duplicate Concert", message: "You already entered this concert", preferredStyle: UIAlertControllerStyle.alert)
            alertC.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
            alertC.addAction(UIAlertAction(title: "Add it anyway", style: UIAlertActionStyle.default) { alertC in
                do {
                    let _ = try addConcert(bsn: bsn!, cDate: cDate, rating: rating, couchTour: couchTour, force: true)
                } catch let error as NSError {
                    infoAlert(title: "Error adding concert", message: "Error \(error)", view: view)
                }
            })
            view.present(alertC, animated: true, completion: nil)
            return false
        }
    } catch {
        infoAlert(title: "Error adding concert", message: "Error \(error)", view: view)
    }
    return true
}

func addConcert(bsName: String?, cDate: ConcertDate, rating: Int16, couchTour: Bool) throws -> Concerts {
    let sn = try stringToBSN(bsName)
    let bsn = try fetchBSN(sn!)
    let c = try addConcert(bsn: bsn, cDate: cDate, rating: rating, couchTour: couchTour)
    return c
}

enum addConcertErrors: Error {
    case duplicateConcert
}

// Overloaded function: This one takes an already fetched BandShortName
func addConcert(bsn: BandShortName, cDate: ConcertDate, rating: Int16, couchTour: Bool, force: Bool = false) throws -> Concerts {
    if !force {
        let dup = try fetchThisConcert(cDate: cDate, bsn: bsn)
        if dup != nil {
            throw addConcertErrors.duplicateConcert
        }
    }
    let concert = Concerts(context: context)
    concert.date = cDate.concertDateString
    concert.toBandShortName = bsn
    concert.rating = rating
    concert.couchTour = couchTour
    ad.saveContext()
    return concert
}

// Fetch the Band Short Name core data object for the short name passed
// If the short name passed does not exist, create it
// Show alerts on errors

enum bsnErrors: Error {
    case noBandName
    case blankBandName
}

func fetchBSNWithAlerts(_ bandSN: String?, view: UIViewController) -> BandShortName! {
    let sn = stringToBSNWithAlerts(bandSN, view: view)
    if sn != nil {
        do {
            let bsn = try fetchBSN(sn!)
            return bsn
        } catch {
            let error = error as NSError
            infoAlert(title: "Error looking up band name \(sn ?? "nil")", message: "\(error)", view: view)
            return nil
        }
    }
    return nil
}

// Fetch the Band Short Name core data object for the short name passed
// If the short name passed does not exist, create it
// The sn MUST have been processed by stringToBSN() or stringToBSNWith Alerts

private func fetchBSN(_ sn: String) throws -> BandShortName {
    var rbsn = try bsnExists(sn)
    if rbsn == nil {
        rbsn = BandShortName(context: context)
        rbsn!.bandShortName = sn
        ad.saveContext()
    }
    return rbsn!
}

// Fetch all the concerts

func fetchConcerts() throws -> [Concerts] {
    let fetchRequest: NSFetchRequest<Concerts> = Concerts.fetchRequest()
    let results = try context.fetch(fetchRequest)
    return results
}

// Fetch a particular concert (date and shortname)

func fetchThisConcert(cDate: ConcertDate, bsn: BandShortName) throws -> Concerts? {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Concerts")
    fetchRequest.predicate = NSPredicate(format: "date == %@ and toBandShortName.bandShortName == %@", cDate.concertDateString, bsn.bandShortName!)
    let fetchedConcerts = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Concerts]
    if fetchedConcerts.count > 0 {
        return fetchedConcerts[0]
    } else {
        return nil
    }
}

func stringToBSNWithAlerts(_ bandShortName: String?, view: UIViewController) -> String? {
    do {
        let sn = try stringToBSN(bandShortName)
        return sn
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
        infoAlert(title: "Error in band name \(bandShortName ?? "nil")", message: "\(error)", view: view)
        return nil
    }
}

func stringToBSN(_ bandShortName: String?) throws -> String? {
    if bandShortName == nil {
        throw bsnErrors.noBandName
    }
    let sn = bandShortName!.trimmingCharacters(in: .whitespacesAndNewlines)
    if sn == "" {
        throw bsnErrors.blankBandName
    }
    return sn
}

func bsnExists(_ sn: String) throws -> BandShortName? {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BandShortName")
    fetchRequest.predicate = NSPredicate(format: "bandShortName == [c] %@", sn)
    let fetchedBSN = try context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [BandShortName]
    if fetchedBSN.count > 0 {
        return fetchedBSN[0]
    }
    return nil
}
