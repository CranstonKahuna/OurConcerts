//
//  ToolsVC.swift
//  OurConcerts
//
//  Created by Dean Thomas on 8/31/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit
import MobileCoreServices

class ToolsVC: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
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
//        let path = tmpDir.stringByAppendingPathComponent(fileName)
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
                        return files[0]
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

    @IBAction func pickerBtnPressed(_ sender: UIButton) {
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypeContent)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)

    }
    
    
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let cico = url as URL
        print("The Url is : \(cico)")
        //optional, case PDF -> render
        //displayPDFweb.loadRequest(NSURLRequest(url: cico) as URLRequest)
    }
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu:     UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}
