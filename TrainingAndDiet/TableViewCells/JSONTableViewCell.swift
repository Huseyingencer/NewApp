//
//  JSONTableViewCell.swift
//  TrainingAndDiet
//
//  Created by Hüseyin  Gencer on 1.04.2021.
//

import UIKit

class JSONTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
