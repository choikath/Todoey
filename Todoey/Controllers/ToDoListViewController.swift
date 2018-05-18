//
//  ViewController.swift
//  Todoey
//
//  Created by Katherine Choi on 4/26/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift


class ToDoListViewController: UITableViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    var todoItems: Results<Item>?
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//    let defaults = UserDefaults.standard
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    } // optional, starts as nil until set by categoryVC
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext  // grabs shared singleton delegate instance aka appdelegate.
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
//            itemArray = items
        
    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggs"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
        
        //retrieve local data model array of Items, stored in defaults
        //loadItems()
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//    }
//
        
        }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK - Tableview Datasource Methods


    // cell for row at index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = todoItems?[indexPath.row].title
        
        // Ternery operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    // number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK - TableView Delegate Methods
   
    //did select row at index path
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(todoItems![indexPath.row])
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        

        
        //deleting item from coredata
        //context.delete(itemArray[indexPath.row]) //deletes from permanent persistent database in coredata.  impt this comes before:
        //itemArray.remove(at: indexPath.row) //the temporary local item array.  then call context.save()

//        saveItems()
        
//        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK - Add New Items
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert.

            
            //how to implement using CoreData
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem) // text fields are never nil, at worst are empty strings. so can force unwrap
//
//            self.saveItems()
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
           
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField // extending the scope of this text field to local add button pressed
            print(alertTextField.text)
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//    func saveItems() {
//
//        do {
//           try context.save() // save from staging area to save to database
//        } catch {
//            print("error saving context \(error)")
//        }
//
//
////        let encoder = PropertyListEncoder()
////        do {
////            let data = try encoder.encode(itemArray)
////            try data.write(to: dataFilePath!)
////        }
////        catch {
////            print("Error encoding item array. \(error)")
////        }
//    }
//    //    func loadItems() {
//    //        if let data = try? Data(contentsOf: dataFilePath!) {
//    //            let decoder = PropertyListDecoder()
//    //            do {
//    //                itemArray = try decoder.decode([Item].self, from: data)
//    //            }
//    //            catch {
//    //                print("Error decoding item array. \(error)")
//    //            }
//    //        }
//    //
//    //    }

    
    
    func loadItems() {
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { // if there is a specified request passed in as parameter, use that, otherwise default to Item.fetchRequest()
        // set predicate value (passed in from searchbar call) as default nil for when it loads on load.
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()  //broadly fetching everything from item entity, and returns as an array of Items
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        // filter only items for this parent category:
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name)
//
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
////
////        request.predicate = compoundPredicate
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//
//        do {
//            itemArray = try context.fetch(request)
//        }
//        catch {
//            print("error fetching data from context \(error)")
//        }
//
    }
    
    
}

//MARK: - Search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
        
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)  // contains that is case and dicritic insensitive [cd]
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {  // run in separate thread in foreground 'main'
                searchBar.resignFirstResponder() //nolonger be selected

            }
            
            
        }
    }
    
    
}

