//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Philip Yu on 7/7/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Adjust table view settings
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        
    }
    
    // MARK: - UITableViewDataSource Section
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
        
    }
    
    // MARK: - SwipeTableViewCellDelegate Section
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (_, indexPath) in
            // Handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }
        
        // Customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeTableOptions()
        
        options.expansionStyle = .destructive
        
        return options
        
    }
    
    func updateModel(at indexPath: IndexPath) { }
    
}
