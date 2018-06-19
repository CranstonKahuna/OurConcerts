//
//  ToolsVC.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/31/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit
import MobileCoreServices

class ToolsVC: ourConcertsVC, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    private var tmpDir = NSTemporaryDirectory() as String

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Document Picker Functions

    @IBAction func importBtnPressed(_ sender: UIButton) {
        let importPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeItem as String], in: .import)
        importPicker.delegate = self
        importPicker.modalPresentationStyle = .formSheet
//        importPicker.addOption(withTitle: "iPhone", image: nil, order: .first) {
//            print("In addOption")
//        }
        self.present(importPicker, animated: true, completion: nil)
    }

    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let fn = url.lastPathComponent
        var jsonData: Data
        var json: Any
        do {
            jsonData = try Data(contentsOf: url)
        } catch {
            let error = error as NSError
            infoAlert(title: "Cannot read file \(fn)", message: "\(error)", view: self)
            return
        }
        if jsonData.count == 0 {
            infoAlert(title: "file \(fn) is empty", message: nil, view: self)
            return
        }
        let jsonString = String(data: jsonData, encoding: .utf8)
        do {
            json = try JSONSerialization.jsonObject(with: jsonData, options: [])
        } catch {
            infoAlert(title: "Cannot parse file \(fn) as json", message: "\(String(describing: jsonString!))", view: self)
            return
        }
        // NOTE: I could not come up with a test that would parse but fail this check
        guard let dictionary = json as? [String: Any] else {
            infoAlert(title: "Outermost json of \(fn) not a dictionary", message: "\(String(describing: jsonString!))", view: self)
            return
        }
        guard let concerts = dictionary["concerts"] as? [Any] else {
            infoAlert(title: "No \"concerts\" element in json of \(fn)", message: "\(String(describing: jsonString!))", view: self)
            return
        }
        let alertQ = AlertQueue(alertMax: 4, view: self)
        var conCount = 0
        var errCount = 0
        var dupCount = 0
        for concert in concerts {
            if let c = concert as? [String: String] {
                var rating: Int16 = 0
                var couchTour: Bool = false
                if let bsName: String = c["BSName"], let date = c["Date"] {
                    if let r1 = c["rating"], let r = Int16(r1) {
                         if r >= 0 && r < 6 {
                            rating = r
                        }
                    }
                    if let r2 = c["couchTour"], let r = Bool(r2) {
                        couchTour = r
                    }
                    let cDate = ConcertDate(date)
                    if cDate == nil {
                        errCount += 1
                        alertQ.addErrorAlert("Bad date string \(date): Expected YYYY/MM/DD")
                        continue
                    }
                    do {
                        try addConcert(bsName: bsName, cDate: cDate!, rating: rating, couchTour: couchTour)
                        conCount += 1
                    } catch let error as addConcertErrors {
                        switch error {
                        case .duplicateConcert:
                            dupCount += 1
                        }
                    } catch _ as bsnErrors {
                        errCount += 1
                        alertQ.addErrorAlert("Bad band name \(bsName)")
                     } catch {
                        errCount += 1
                    }
                } else {
                    errCount += 1
                    alertQ.addErrorAlert("No BSName or Date in \(c)")
                 }
            }
        }
        if errCount > 0 {
            alertQ.addInfoAlert("\(errCount) concerts not added due to errors")
        }
        if dupCount > 0 {
            alertQ.addInfoAlert("\(dupCount) duplicate concerts not added")
        }
        alertQ.addInfoAlert("\(conCount) concerts added")
        alertQ.displayAlerts()
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}


// Display a list of "OK" alerts sequentially
//
// "_alerts" is where the alerts are gathered
// The alerts will be displayed in the order of the _alerts array


class AlertQueue {
    
    private var _alerts = [UIAlertController]()
    private let _alertMax: Int
    private var _alertCount = 0
    private let _view: UIViewController
    
    init(alertMax: Int, view: UIViewController) {
        _alertMax = alertMax
        _view = view
    }
    
    func addErrorAlert(_ title: String) {
        _alertCount += 1
        let alertController: UIAlertController
        if _alertCount < _alertMax {
            alertController = UIAlertController(title: title, message: "Skipping", preferredStyle: UIAlertControllerStyle.alert)
            _alerts.append(alertController)
        } else if _alertCount == _alertMax {
            alertController = UIAlertController(title: title, message: "Quietly skipping remaining bad entries", preferredStyle: UIAlertControllerStyle.alert)
            _alerts.append(alertController)
        }
    }
    
    func addInfoAlert(_ title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        _alerts.append(alertController)
    }
    
    // displayAlertsHandler() is the completion handler
    private func displayAlertsHandler(alert: UIAlertAction!) {
        if self._alerts.count > 0 {
            let nextAlert = self._alerts.remove(at: 0)
            _view.present(nextAlert, animated: false, completion: nil)
        }
    }
    
    // displayAlerts() kicks of the list of alerts
    func displayAlerts() {
        for alert in _alerts {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.displayAlertsHandler))
        }
        if _alerts.count > 0 {
            let alert = _alerts.remove(at: 0)
            _view.present(alert, animated: false, completion: nil)
        }
    }

}
