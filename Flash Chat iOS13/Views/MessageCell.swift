//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Nguyen Van Son on 03/11/2023.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var viewBubble: UIView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBubble.layer.cornerRadius = viewBubble.frame.size.height / 6
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
