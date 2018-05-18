//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Katherine Choi on 4/27/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        loadCategories()
    }

    //MARK: - TableView Datasource Methods
    //MARK: - Tableview Delegate Methods
    //TODO: - select row at index path  --> go to child item lists
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if there are multiple segues from this vc, could do if statements to identify which one is happening:
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
    //TODO: - number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1 //return count if not nil, otherwise, return 1.  ?? is a "nil coalescing operator"
    }
    
    
    //TODO: - cell for row at index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //DequeueReusableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) //identifier created in prototype cell attributes panel in storyboard
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
        
        
    }
    

    
    

    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
//            try context.save()
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {

        let categoryArray = realm.objects(Category.self)
        
//        let request:NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//            categoryArray = try context.fetch(request)
//        }
//        catch {
//            print("error fetching data from context \(error)")
//        }
        tableView.reloadData()
    }
    
        
        

        
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {


    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
        
        let newCategory = Category()
        //let newCategory = Category(context: self.context)
        newCategory.name = textField.text!
        
//        self.categoryArray.append(newCategory)
        self.save(category: newCategory)
        
    
    }

    alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Create new category"
        textField = alertTextField  // extending the scope of the text field to the local add button pressed method to use in action
    }

    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)


    }
    
}
