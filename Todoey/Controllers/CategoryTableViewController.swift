//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by 小木曽佑介 on 2023/02/16.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    private var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")}
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hexString: "1D9BF6")
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navBar.scrollEdgeAppearance = appearance
        navBar.standardAppearance = appearance
        navBar.tintColor = ContrastColorOf(UIColor.white, returnFlat: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            guard let text = textField.text else { return }
            let newCategory = Category()
            newCategory.name = text
            newCategory.color = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        guard let category = categories?[indexPath.row], let categoryColor = UIColor(hexString: category.color) else { return cell }
        cell.textLabel?.text = category.name
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        return cell
    }
    
    
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? TodoListViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
        destinationVC.selectedCategory = categories?[indexPath.row]
    }
    
    
    //MARK: - Data Manipulation Methods
    private func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error feching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    private func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        guard let categoryForDelection = self.categories?[indexPath.row] else { return }
        do {
            try self.realm.write {
                self.realm.delete(categoryForDelection)
            }
        } catch {
            print("Error deleting category,\(error)")
        }
    }
}


