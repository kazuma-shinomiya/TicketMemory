//
//  TicketTableViewCell.swift
//  TicketMemory
//
//  Created by Kazuma Shinomiya on 2021/01/31.
//

import UIKit

class TicketTableViewCell: UITableViewCell {

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!    
    @IBOutlet weak var ticketImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
