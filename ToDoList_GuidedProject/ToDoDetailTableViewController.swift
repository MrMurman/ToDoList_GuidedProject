//
//  ToDoDetailTableViewController.swift
//  ToDoDetailTableViewController
//
//  Created by Андрей Бородкин on 07.08.2021.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {

    var toDo: ToDo?
    var saveDelegate: SaveDelegate?
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toDo = toDo {
            navigationItem.title = "To-Do"
            titleTextField.text = toDo.title
            isCompleteButton.isSelected = toDo.isComplete
            dueDatePickerView.date = toDo.dueDate
            notesTextView.text = toDo.notes
        } else {
            dueDatePickerView.date = Date().addingTimeInterval(24*60*60)
            notesTextView.text = ""
        }
        
        updateSaveButtonState()
        updateDueDateLabel(date: dueDatePickerView.date)
    }

    
    
    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let title = titleTextField.text!
        let isCompete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        toDo = ToDo(title: title, isComplete: isCompete, dueDate: dueDate, notes: notes)
    }
    
    
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
    
        isCompleteButton.setImage(UIImage(systemName: "circle"), for: .normal)
        isCompleteButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        
        
        isCompleteButton.isSelected.toggle()
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: sender.date)
    }
    

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let title = titleTextField.text!
        let isCompete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
       
        toDo = ToDo(title: title, isComplete: isCompete, dueDate: dueDate, notes: notes)
        
        saveDelegate?.saveEditedToDo(toDo: toDo!)
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Table view delegate

    var isDatePickerHidden = true
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath = IndexPath(row: 0, section: 2)
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath where isDatePickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == dateLabelIndexPath {
            isDatePickerHidden.toggle()
            dueDateLabel.textColor = .black
            updateDueDateLabel(date: dueDatePickerView.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

}



protocol SaveDelegate {
    func saveEditedToDo(toDo: ToDo)
}


