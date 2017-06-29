//
//  CentralManagerLogCell.swift
//  ios_playground
//
//  Created by Shintaro Nosaka on 2017/06/28.
//  Copyright © 2017年 Shintaro Nosaka. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    static let cellIdentifier: String = "logCell"
    
    static let height: CGFloat = 58

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
