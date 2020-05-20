//
//  ViewController.swift
//  Todoey
//
//  Created by Philip Yu on 7/4/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    private var todoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    private let realm = try! Realm()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set search bar delegate to this class
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colorHex = selectedCategory?.color {
            title = selectedCategory?.name
            
            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
            
            if let navBarColor = UIColor(hexString: colorHex) {
                let contrastColor = ContrastColorOf(navBarColor, returnFlat: true)
                
                navBar.subviews[0].backgroundColor = navBarColor
                navBar.backgroundColor = UIColor(hexString: colorHex)
                navBar.tintColor = contrastColor
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColor]
                
                searchBar.barTintColor = navBarColor
                searchBar.searchTextField.textColor = navBarColor
                searchBar.searchTextField.backgroundColor = contrastColor
            }
        }
        
    }
    
    // MARK: - UITableViewDataSource Section
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    // MARK: - UITableViewDelegate Section
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                // Add/remove a check based on whether or not user has finished to-do task yet
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (_) in
            // What will happen when user clicks on add button
            if let currentCategory = self.selectedCategory {
                do {
                    // Create new item in selected category
                    try self.realm.write {
                        let newItem = Item()
                        
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                    
                    print("Added new \"\(currentCategory.name)\" task: \(textField.text!)")
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    
    // MARK: - Delete Data From SwipeTableView
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            print("Deleted \"\(selectedCategory!.name)\" task: \(itemForDeletion.title)")
            
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
        
    }
    
}

// MARK: - UISeachBarDelegate Section

extension TodoListViewController: UISearchBarDelegate {
    
    // MARK: - Search bar methods
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Filter search by ignoring case sensitivity and diacritic [cd] and sort by date created
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        resignKeyboard(for: searchBar)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // Reset to default search bar setting when user clicks cancel search button
        searchBar.text = ""
        loadItems()
        resignKeyboard(for: searchBar)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Load items into table view if search bar text field is empty
        if searchBar.text?.count == 0 {
            loadItems()
        }
        
    }
    
    func resignKeyboard(for searchBar: UISearchBar) {
        
        // Dismiss keyboard
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
    
}
