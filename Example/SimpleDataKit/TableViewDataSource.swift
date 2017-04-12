//
//  TableViewDataSource.swift
//  SimpleDataKit
//
//  Created by Harley.xk on 2017/4/9.
//  Copyright (c) 2017 Harley. All rights reserved.
//

import UIKit
import CoreData
import SimpleDataKit

protocol FetchControled: Queryable {
    static var defaultFetchingRequest: NSFetchRequest<Self> { get }
}

protocol TableViewDataSourceDelegate {
    associatedtype Object: FetchControled
    associatedtype Cell: UITableViewCell
    
    func configure(_ cell: Cell, for object: Object)
}

class TableViewDataSource<Delegate: TableViewDataSourceDelegate>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    typealias Object = Delegate.Object
    typealias Cell = Delegate.Cell
    
    init(tableView: UITableView, cellIdentifier: String, delegate: Delegate) {
        
        let request: NSFetchRequest<Object> = Object.defaultFetchingRequest
        request.returnsObjectsAsFaults = false
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()

        
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
        tableView.dataSource = self;
        tableView.reloadData()
    }
    
    // MARK: - API
    public func object(at indexPath: IndexPath) -> Object {
        return fetchedResultsController.object(at: indexPath)
    }
    
    // MARK: - Private
    private var tableView: UITableView
    private var cellIdentifier: String
    private var fetchedResultsController: NSFetchedResultsController<Object>
    private var delegate: Delegate
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedSection = fetchedResultsController.sections?[section] else {
            return 0
        }
        return fetchedSection.numberOfObjects
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = fetchedResultsController.object(at: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? Cell else {
            fatalError("Unexpected cell type at \(indexPath)")
        }
        delegate.configure(cell, for: object)
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        }
    }

    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections([sectionIndex], with: .automatic)
        case .delete:
            tableView.deleteSections([sectionIndex], with: .automatic)
        default:
            break
        }
    }
}
