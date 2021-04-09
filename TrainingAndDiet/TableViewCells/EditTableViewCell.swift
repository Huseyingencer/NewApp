//
//  EditTableViewCell.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 5.04.2021.
//

import UIKit

class EditTableViewCell: UITableViewCell {
    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
