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
    
    var fileManager = FileManager()
    var tmpDir = NSTemporaryDirectory() as String
    let fileName = "sample.txt"

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

    @IBAction func createFile(_ sender: UIButton) {
        let path = NSString(string: tmpDir).appendingPathComponent(fileName)
        let contentsOfFile = "Sample Text"
        
        // Write File
        do {
            try contentsOfFile.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            print("File sample.txt created at tmp directory")
        } catch {
            print("Failed to create file")

            let error = error as NSError
            print("\(error)")
        }
    }
    
    @IBAction func listDirectory(_ sender: UIButton) {
        // List Content of Path
        let isFileInDir = enumerateDirectory() ?? "Empty"
        print("Contents of Directory =  \(isFileInDir)")
    }
    
    @IBAction func viewFileContent(_ sender: UIButton) {
        let isFileInDir = enumerateDirectory() ?? ""
        
//        let path = tmpDir.stringByAppendingPathComponent(isFileInDir)
        let path = NSString(string: tmpDir).appendingPathComponent(isFileInDir)

//        let contentsOfFile = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        do {
            let content = try String(contentsOfFile: path)
            print("Content of file = \(content)")
        } catch {
            print("No file found")
        }
    }
    
    @IBAction func deleteFile(_ sender: UIButton) {
        
        if let isFileInDir = enumerateDirectory() {
            let path = NSString(string: tmpDir).appendingPathComponent(isFileInDir)
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                print("Failed to delete file")
                let error = error as NSError
                print("\(error)")
            }
        }
    }
    
    func enumerateDirectory() -> String? {
//        let filesInDirectory =  fileManager.contentsOfDirectoryAtPath(tmpDir, error: &error) as? [String]
        do {
            let files = try fileManager.contentsOfDirectory(atPath: tmpDir)
            if files.count > 0 {
                print("eD: \(files)")
                for file in files {
                    if file == fileName {
                        print("sample.txt found")
                        return file
                    }
                }
                print("File not found")
                return nil
            } else {
                print("eD: directory empty")
            }
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        return nil
    }
    
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
    
    struct concertFromJson: Codable {
        var Date: String
        var BSName: String
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
                if let bsName = c["BSName"], let date = c["Date"] {
                    if addConcert(bsName: bsName, date: date, view: self) {
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
