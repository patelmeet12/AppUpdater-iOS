//
//  WhatsNewTableViewCell.swift
//  AppUpdater
//
//  Created by Apple iQlance on 15/09/2022.
//

import UIKit

class WhatsNewTableViewCell: UITableViewCell {

    //MARK:-  Outlets and Variable Declarations
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(img: UIImage, title: String, subTitle: String) {
        
        self.imgIcon.image = img
        self.lblTitle.text = title
        self.lblSubTitle.text = subTitle
    }
}
