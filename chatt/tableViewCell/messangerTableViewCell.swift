//
//  messangerTableViewCell.swift
//  chatt
//
//  Created by Alperen Kavuk on 18.04.2023.
//

import UIKit

class messangerTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePerson: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
