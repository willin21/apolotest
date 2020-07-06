//
//  apoloItemTableViewCell.swift
//  ApoloTest
//
//  Created by wilnin on 4/07/20.
//  Copyright © 2020 PersonalProject. All rights reserved.
//

import UIKit

class apoloItemTableViewCell: UITableViewCell {

    @IBOutlet weak var contentViewCell: UIView!
    @IBOutlet weak var favoriteImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isFavorite: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupValues(data: DataItem) {
        titleLabel.text = data.title
        setImage(isFavourite: isFavorite)
    }

    func setImage(isFavourite: Bool) {
        if isFavourite {
            favoriteImage.image = UIImage(named: Constants.Image.favoriteOn)!.withRenderingMode(.alwaysOriginal)
        }else{
            favoriteImage.image = UIImage(named: Constants.Image.favoriteOff)!.withRenderingMode(.alwaysOriginal)
        }
    }
}
