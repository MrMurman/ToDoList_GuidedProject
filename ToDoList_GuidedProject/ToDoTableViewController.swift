//
//  ToDoTableViewController.swift
//  ToDoTableViewController
//
//  Created by Андрей Бородкин on 06.08.2021.
//

import UIKit

class ToDoTableViewController: UITableViewController, SaveDelegate, ToDoCellDelegate{

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier", for: indexPath) as! ToDoCell
        cell.delegate = self
        
        let todo = todos[indexPath.row]
        cell.titleLabel?.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDetailVC(indexPath: indexPath)
    }
    
    
    
    
    // MARK: - Saves

    func saveEditedToDo(toDo: ToDo) {
        
        let newToDo = toDo
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            todos[selectedIndexPath.row] = newToDo
        } else {
            let newIndexPath = IndexPath(row: todos.count, section: 0)
            todos.append(toDo)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        tableView.reloadData()
    }
    
    @IBAction func createNewToDo(_ sender: UIBarButtonItem) {
        goToDetailVC(indexPath: nil)
    }
    
    func goToDetailVC(indexPath: IndexPath?) {
       
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailVC") as? ToDoDetailTableViewController else {return}
                 
        detailVC.saveDelegate = self
        
        if let indexPath = indexPath {
            detailVC.toDo = todos[indexPath.row]
            present(UINavigationController(rootViewController: detailVC), animated: true)
        } else {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete.toggle()
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
