//
//  TableViewCellList.swift
//  securityApp
//
//  Created by Miguel Angel Jimenez Melendez on 26/05/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit

class TableViewCellList: UITableViewCell {

    @IBOutlet weak var lbscore: UILabel!
    @IBOutlet weak var lblocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
