//
//  AddStudentViewController.swift
//  SimpleDataKit
//
//  Created by Harley.xk on 2017/4/6.
//  Copyright © 2017年 Harley-xk. All rights reserved.
//

import UIKit
import Comet

class AddStudentViewController: UITableViewController {

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var dateAssistBar: UIToolbar!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    var birthday: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        birthdayTextField.inputView = datePicker
        birthdayTextField.inputAccessoryView = dateAssistBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DatePicker
    @IBAction func datePickerDidCancel(_ sender: Any) {
        birthdayTextField.resignFirstResponder()
    }

    @IBAction func datePickerDidFinish(_ sender: Any) {
        let date = datePicker.date
        birthdayLabel.text = date.string(format: "yyyy-MM-dd")
        birthdayTextField.resignFirstResponder()
        birthday = date
    }
    
    private func saveAction() {
        guard let name = nameTextField.text, name.characters.count > 0 else {
            let alert = UIAlertController(title: "Error", message: "Name can't be nil", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        let student = Student.create(name: name, email: emailTextField.text, birthday: birthday)
        student.save()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath)
            let textField = cell?.contentView.viewWithTag(99)
            textField?.becomeFirstResponder()
        } else if (indexPath.section == 1) {
            saveAction()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
