//
//  EventListTableViewCell.swift
//  UTANow
//
//  Created by Cameron Moreau on 11/7/15.
//  Copyright © 2015 Mobi. All rights reserved.
//

import UIKit
import Kingfisher

class EventListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    
    func setEvent(event: Event) {
        labelDate.text = event.time
        labelTitle.text = event.title
        labelLocation.text = event.location
        
        let bgImage = UIImageView()
        bgImage.kf_setImageWithURL(NSURL(string: event.imageUrl!)!)
        
        self.backgroundView = bgImage
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
