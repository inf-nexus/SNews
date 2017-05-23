//
//  ArticleTableViewCell.swift
//  SNews
//
//  Created by Jacob Contreras on 4/25/17.
//  Copyright © 2017 Jacob Contreras. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    //@IBOutlet weak var imageView: UIImage!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var descLabel: UILabel!
    
    @IBOutlet var articleImg: UIImageView!

    
    func configure(article: ArticleData, image: UIImage){
        if (article.title == nil){
            titleLabel.text = ""
            descLabel.text = ""
        }else{
            print(article.title)
            titleLabel.text = article.title!
            descLabel.text = article.description!
            articleImg.image = image
        
        }

        //articleImg.image = article
        //colorView.backgroundColor = color.color
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
