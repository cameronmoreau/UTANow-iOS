//
//  CommentTableViewCell.swift
//  UTANow
//
//  Created by Cameron Moreau on 2/26/16.
//  Copyright © 2016 Mobi. All rights reserved.
//

import UIKit
import Kingfisher

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelComment: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(comment: Comment) {
        let image = comment.user!.profileImageUrl!
        let url = NSURL(string: image)!
        print(url)
        
        labelComment.text = comment.text
        labelName.text = comment.user?.name
        profileImage.kf_setImageWithURL(url)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
