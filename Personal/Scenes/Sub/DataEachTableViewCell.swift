//
//  DataEachTableViewCell.swift
//  Personal
//
//  Created by 으정이 on 2021/10/07.
//

import UIKit

class DataEachTableViewCell: UITableViewCell {
    
    //MARK: Properties
    private let margin: CGFloat = 5
    @IBOutlet weak var facilityNameLabel: UILabel!
    @IBOutlet weak var addressLabel : UILabel!
    @IBOutlet weak var updatedAtLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
