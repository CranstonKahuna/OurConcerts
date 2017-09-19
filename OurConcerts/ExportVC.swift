//
//  ExportVC.swift
//  OurConcerts
//
//  Created by Dean Thomas on 9/13/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit
import CoreData

class ExportVC: UIViewController, UITextFieldDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    @IBOutlet weak var fileNameLbl: UITextField!
    
    var fileManager = FileManager()
    var tmpDir = NSTemporaryDirectory() as String
    var fname: String = ""
    var tpath: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileNameLbl.delegate = self
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
                let alertController = UIAlertController(title: "We need a file name!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return true
            }
            fileNameLbl.resignFirstResponder()

            tpath = NSString(string: tmpDir).appendingPathComponent(fname)
            let concerts = fetchConcerts()
            if concerts.count == 0 {
                // No concerts fetched: Display alert
                let alertController = UIAlertController(title: "No concerts to export", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return true
            }
            writeJsonConcerts(concerts: concerts, toFile: tpath)
            
            let urlToPath: URL = URL(fileURLWithPath: tpath)
            let importMenu = UIDocumentMenuViewController(url: urlToPath, in: .exportToService)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            
//            importMenu.addOption(withTitle: "iPhone", image: nil, order: .first) {
//                // ToDo Add local option for saving
//                print("In addOption")
//            }
            
            self.present(importMenu, animated: true, completion: nil)
        }
        return true
    }
    
    func writeJsonConcerts(concerts: [Concerts], toFile: String) {
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
                exportString.append("{ \"Date\": \"\(concert.date!)\", \"BSName\": \"\(shortName)\" }")
            }
            exportString.append(jtail)
            try exportString.write(toFile: toFile, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            return
        }
    }
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let alertController = UIAlertController(title: "Concerts Exported to \(fname)", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,
                                                handler: {(alert: UIAlertAction!) in self.navigationController?.popViewController(animated: true)}))
        self.present(alertController, animated: true, completion: nil)
        do {
            try fileManager.removeItem(atPath: tpath as String)
        } catch {
            print("Failed to delete file")
            let error = error as NSError
            print("\(error)")
        }

    }
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentMenuWasCancelled(_ controller: UIDocumentMenuViewController) {
        dismiss(animated: true, completion: nil)
        self.fileNameLbl.becomeFirstResponder()
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
        self.fileNameLbl.becomeFirstResponder()
    }

}
