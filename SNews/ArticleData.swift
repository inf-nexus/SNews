//
//  ArticleData.swift
//  SNews
//
//  Created by Jacob Contreras on 4/24/17.
//  Copyright © 2017 Jacob Contreras. All rights reserved.
//

import UIKit

struct ArticleData{
    
    let title: String!
    let description: String!
    let url: String!
    var imgUrl: String!
    let src: String!
    var img: UIImage?
    
    init?(_title: String?, _desc: String?, _url: String?, _imgUrl: String?, _src: String?, _img: UIImage?){
        guard let title = _title else{
            return nil
        
        }
        self.title = title
        
        guard let desc = _desc else{
            return nil
            
        }
        self.description = desc
        
        guard let url = _url else{
            return nil
            
        }
        self.url = url
        
        guard let imgUrl = _imgUrl else{
            return nil
            
        }
        self.imgUrl = imgUrl
        
        guard let src = _src else{
            return nil
            
        }
        self.src = src
        
        
        guard let img = _img else{
            return nil
            
        }
        self.img = img
    
    }
    
    init?(json: Dictionary<String, Any>, src: String?, img: UIImage?){
    
        guard let title = json["title"] as? String else{
            print("title failed")
            return nil
        }
        self.title = title
        
        guard let description = json["description"] as? String else{
            print("description failed")

            return nil
        }
        self.description = description
        
        guard let url = json["url"] as? String else{
            print("url failed")
            return nil
        }
        self.url = url
        
        guard let imgUrl = json["urlToImage"] as? String else{
            print("img failed")
            return nil
        }
        self.imgUrl = imgUrl
        
        guard let innerSrc = src else{
            return nil
        }
        self.src = innerSrc
        
        if img != nil{
            self.img = img
        }else{
            self.img = nil
        
        }

        
    }
    
    
    


}
