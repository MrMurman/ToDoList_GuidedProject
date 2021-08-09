//
//  ToDoCell.swift
//  ToDoCell
//
//  Created by Андрей Бородкин on 09.08.2021.
//

import UIKit


protocol ToDoCellDelegate: AnyObject {
    func checkmarkTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {

    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: ToDoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        isCompleteButton.setImage(UIImage(systemName: "circle"), for: .normal)
        isCompleteButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    @IBAction func competeButtonTapped() {
        delegate?.checkmarkTapped(sender: self)
    }
    
}
