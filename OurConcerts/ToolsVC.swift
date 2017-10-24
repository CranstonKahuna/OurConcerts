//
//  ToolsVC.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/31/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit
import MobileCoreServices

class ToolsVC: UIViewController, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    var tmpDir = NSTemporaryDirectory() as String

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
        do {
            json = try JSONSerialization.jsonObject(with: jsonData, options: [])
        } catch {
            let jsonString = String(data: jsonData, encoding: .utf8)
            infoAlert(title: "Cannot parse file \(fn) as json", message: "\(String(describing: jsonString))", view: self)
            return
        }
        guard let dictionary = json as? [String: Any] else {
            infoAlert(title: "Outermost json of \(fn) not a dictionary", message: "\(jsonData)", view: self)
            return
        }
        guard let concerts = dictionary["concerts"] as? [Any] else {
            infoAlert(title: "No concerts element in json of \(fn)", message: "\(jsonData)", view: self)
            return
        }
        var conCount = 0
        for concert in concerts {
            if let c = concert as? [String: String] {
                var rating: Int16 = 0
                if let bsName = c["BSName"], let date = c["Date"] {
                    if let r1 = c["rating"], let r = Int16(r1) {
                         if r >= 0 && r < 6 {
                            rating = r
                        }
                    }
                    if addConcert(bsName: bsName, date: date, rating: rating, view: self) {
                        conCount += 1
                    }
                } else {
                    infoAlert(title: "No BSName or Date in \(c): Skipping", message: nil, view: self)
                }
            }
        }
        infoAlert(title: "\(conCount) concerts added", message: nil, view: self)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
