//
//  DetailViewController.swift
//  ApoloTest
//
//  Created by wilnin on 4/07/20.
//  Copyright © 2020 PersonalProject. All rights reserved.
//

import UIKit
import SDWebImage

protocol FavoriteProtocol {
    func favoriteUpdate()
}

class DetailViewController: BaseViewController{
    
    @IBOutlet weak var imageItemImageView: UIImageView!
    @IBOutlet weak var titleItemLabel: UILabel!
    @IBOutlet weak var dateItemLabel: UILabel!
    @IBOutlet weak var descriptionItemTextView: UITextView!
    @IBOutlet weak var locationItemLabel: UILabel!
    
    var itemModel: Items?
    var delegate: FavoriteProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupNavigation()
    }
    
    func setupView() {
        let data = itemModel?.data![0]
        let urlString = itemModel?.links![0].href?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: urlString ?? "")
        let defaultImage = UIImage(named: Constants.Image.defaultImage)
        
        title = ""
        imageItemImageView.sd_setImage(with: url, placeholderImage: defaultImage)
        titleItemLabel.text = data?.title
        dateItemLabel.text = data?.date_created
        descriptionItemTextView.text = data?.description
        locationItemLabel.text = data?.center
    }
    
    func setupNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        let id = (itemModel?.data![0].nasa_id)!
        validateFavorite(id: id)
    }
    
    func validateFavorite(id: String) {
        if let myCurrentFavorites = getFavorites() {
            if self.doesThisFavoriteExists(array: myCurrentFavorites, id: id) {
                updateRighBarButton(isFavourite: true)
            } else {
                updateRighBarButton(isFavourite: false)
            }
        } else {
            updateRighBarButton(isFavourite: false)
        }
    }
    
    func updateRighBarButton(isFavourite : Bool) {
        var image = UIImage()
        
        if isFavourite {
            image = UIImage(named: Constants.Image.favoriteOn)!.withRenderingMode(.alwaysOriginal)
        }else{
            image = UIImage(named: Constants.Image.favoriteOff)!.withRenderingMode(.alwaysOriginal)
        }
        
        let favoriteButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(tapFavoriteButton))
        self.navigationItem.setRightBarButtonItems([favoriteButton], animated: true)
    }
    
    @objc func tapFavoriteButton(sender: UITapGestureRecognizer) {
        let id = itemModel?.data![0].nasa_id!
            
        self.savedFavorite(object: itemModel!)
        self.validateFavorite(id: id ?? "")
        
        delegate?.favoriteUpdate()
    }
}
