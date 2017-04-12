//
//  ViewController.swift
//  SimpleDataKit
//
//  Created by Harley-xk on 04/07/2017.
//  Copyright (c) 2017 Harley. All rights reserved.
//

import UIKit
import SimpleDataKit

class ViewController: UIViewController, TableViewDataSourceDelegate, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    typealias Object = Student
    typealias Cell = StudentListCell
    
    var dataSource: TableViewDataSource<ViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = TableViewDataSource(tableView: tableView, cellIdentifier: "StudentListCell", delegate: self)
        tableView.dataSource = dataSource
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Actions
    func deleteStudent(at indexPath: IndexPath) {
        let student: Student = dataSource.object(at: indexPath)
        student.delete()
    }
    
    // MARK: - TableViewDataSourceDelegate
    func configure(_ cell: StudentListCell, for object: Student) {
        cell.loadData(object)
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Do somthing
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteStudent(at: indexPath)
        }
        return [deleteAction]
    }
    
}

class StudentListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    func loadData(_ object: Student) {
        nameLabel.text = object.name
        scoreLabel.text = "\(object.score)"
    }
}

