//
//  ExportVC.swift
//  OurConcerts
//
//  Created by Dean Thomas on 9/13/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit
import CoreData

class ExportVC: UIViewController, UITextFieldDelegate, UIDocumentPickerDelegate {

    @IBOutlet weak var fileNameLbl: UITextField!
    
    var fileManager = FileManager()
    var tmpDir = NSTemporaryDirectory() as String
    var fname: String = ""
    var tpath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileNameLbl.delegate = self
        fileNameLbl.autocapitalizationType = .none
        fileNameLbl.autocorrectionType = .no
        fileNameLbl.spellCheckingType = .no

        self.fileNameLbl.becomeFirstResponder()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        fileNameLbl.resignFirstResponder()
//        self.navigationController?.popViewController(animated: true)
//    }

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
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if fileNameLbl.text != nil && fileNameLbl.text != "" {
            fname = fileNameLbl.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if fname == "" {
                // No file name: Display alert
                infoAlert(title: "We need a file name!", message: nil, view: self)
                return true
            }

            tpath = NSString(string: tmpDir).appendingPathComponent(fname)
            let concerts: [Concerts]
            do {
                concerts = try fetchConcerts()
            } catch {
                let error = error as NSError
                infoAlert(title: "Failed to fetch concerts", message: "\(error)", view: self)
                return true
            }
            if concerts.count == 0 {
                // No concerts fetched: Display alert
                infoAlert(title: "No concerts to export", message: nil, view: self)
                return true
            }
            writeJsonConcerts(concerts: concerts, toFile: tpath)
            
            let urlToPath: URL = URL(fileURLWithPath: tpath)
            let exportPicker = UIDocumentPickerViewController(url: urlToPath, in: .exportToService)
            exportPicker.delegate = self
            
//            exportPicker.addOption(withTitle: "iPhone", image: nil, order: .first) {
//                // ToDo Add local option for saving
//                print("In addOption")
//            }
            
            fileNameLbl.resignFirstResponder()
            self.present(exportPicker, animated: true, completion: nil)
        }
        return true
    }
    
    var numberExported: Int = 0
    func writeJsonConcerts(concerts: [Concerts], toFile: String) {
        numberExported = 0
        let jheader: String = "{ \"concerts\": [ "
        let jtail: String = "\n]\n}"
        do {
            var exportString = jheader
            var first = true
            for concert in concerts {
                let shortName = concert.toBandShortName?.bandShortName! ?? "None"
                if !first {
                    exportString.append(",\n")
                } else {
                    first = false
                }
                let dStr = "\"Date\": \"\(concert.date!)\""
                let bsnStr = "\"BSName\": \"\(shortName)\""
                let rateStr = "\"rating\": \"\(concert.rating)\""
                let couchStr = "\"couchTour\": \"\(concert.couchTour)\""
                exportString.append("{ " + dStr + ", " + bsnStr + ", " + rateStr + ", " + couchStr + " }")
                numberExported += 1
            }
            exportString.append(jtail)
            try exportString.write(toFile: toFile, atomically: true, encoding: .utf8)
        } catch {
            return
        }
    }
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let filename = url.lastPathComponent
//        self.navigationController?.popViewController(animated: true)
        infoAlert(title: "\(numberExported) Concerts Exported to \(filename)", message: nil, view: self) {
            do {
                try self.deleteTmpFile()
            } catch {
                let error = error as NSError
                infoAlert(title: "Failed to delete temporary file", message: "\(error)", view: self)
            }
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        do {
            try deleteTmpFile()
        } catch {
            let error = error as NSError
            infoAlert(title: "Failed to delete temporary file", message: "\(error)", view: self)
        }
        dismiss(animated: true, completion: nil)
        self.fileNameLbl.becomeFirstResponder()
    }
    
    func deleteTmpFile() throws {
        try fileManager.removeItem(atPath: tpath as String)
    }

}
