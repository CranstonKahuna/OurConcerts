//
//  ExportVC.swift
//  OurConcerts
//
//  Created by Dean Thomas on 9/13/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit
import CoreData

class ExportVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var fileNameLbl: UITextField!
    @IBOutlet weak var locationBtn: UIButton!
    
    var fileManager = FileManager()
    var tmpDir = NSTemporaryDirectory() as String
    var tpath: String = ""
    let jheader: String = "{ concerts [ "
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileNameLbl.delegate = self
        locationBtn.isEnabled = false
//        locationBtn.layer.cornerRadius = 10.0
        locationBtn.clipsToBounds = true
        locationBtn.layer.borderWidth = 3
        locationBtn.layer.borderColor = UIColor.darkGray.cgColor

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
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if fileNameLbl.text != nil && fileNameLbl.text != "" {
            let fn = fileNameLbl.text!
            fileNameLbl.resignFirstResponder()
            locationBtn.isEnabled = true
            locationBtn.layer.borderColor = UIColor.black.cgColor
            tpath = NSString(string: tmpDir).appendingPathComponent(fn)
            let concerts = fetchConcerts()
            if concerts.count > 0 {
                writeJsonConcerts(concerts: concerts, toFile: tpath)
            }
        }
        return true
    }
    
    func writeJsonConcerts(concerts: [Concerts], toFile: String) {
        do {
            try jheader.write(toFile: toFile, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            return
        }
    }

    @IBAction func locationBtnPressed(_ sender: UIButton) {
        print("Location pressed")
    }
}
