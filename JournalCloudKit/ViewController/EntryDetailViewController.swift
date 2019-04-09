//
//  EntryDetailViewController.swift
//  JournalCloudKit
//
//  Created by Carson Buckley on 4/8/19.
//  Copyright © 2019 Launch. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entry: Entry?{
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews(){
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextView.text = ""
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        bodyTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
            !title.isEmpty,
            !bodyTextView.text.isEmpty else { return }
        EntryController.shared.addEntryWith(title: title, body: bodyTextView.text) { (true) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension EntryDetailViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
