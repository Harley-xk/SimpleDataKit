//
//  SearchingViewController.swift
//  SimpleDataKit
//
//  Created by Harley.xk on 2017/4/12.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import SimpleDataKit

class SearchingViewController: UIViewController {

    @IBOutlet weak var fieldTextField: UITextField!
    @IBOutlet weak var relationSegement: UISegmentedControl!
    @IBOutlet weak var targetTextField: UITextField!
    
    var relations: [Query<Student>.Relation] = [.lessThan, .equal, .greaterThan]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
        let students: [Student] = Student.find(where: fieldTextField.text ?? "", relations[relationSegement.selectedSegmentIndex], targetTextField.text!).get()
        print(students)
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
