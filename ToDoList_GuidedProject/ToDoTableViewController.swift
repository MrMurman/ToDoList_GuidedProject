//
//  ToDoTableViewController.swift
//  ToDoTableViewController
//
//  Created by Андрей Бородкин on 06.08.2021.
//

import UIKit

class ToDoTableViewController: UITableViewController {

    var todos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ToDo List"
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            todos = ToDo.loadSampleToDos()
        }
        
        
        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier", for: indexPath)
        
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        return cell
    }
   

    // MARK: - Table View delegates
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
