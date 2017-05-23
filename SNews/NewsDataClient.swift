//
//  NewsDataClient.swift
//  SNews
//
//  Created by Jacob Contreras on 4/24/17.
//  Copyright © 2017 Jacob Contreras. All rights reserved.
//

import Foundation
import UIKit

class NewsDataClient{
    static let sharedClient = NewsDataClient()
    
    func getMultipleStories(newsSites: [String], completion: @escaping([ArticleData]) -> ()){
        
        var allArticles: [ArticleData] = []
        let group = DispatchGroup.init()
        
        for site in newsSites{
            group.enter()
            
            getStories(source: site){[weak self](newsArticles) in
            
                DispatchQueue.main.async(execute: {
                    allArticles.append(contentsOf: newsArticles)
                    group.leave()
                })
                
            }
        
        }
        
        group.notify(queue: DispatchQueue.global(), execute: {
            completion(allArticles)
        })
                
    }
    
    func getStories(source: String, completion: @escaping([ArticleData]) -> ()){
        
        get(request: clientURLRequest(newsSource: source)) { (success, object) in
            var articlesArr: [ArticleData] = []
            
            if let object = object as? [String: Any]{
                
                if let articles = object["articles"] as? [Dictionary<String, Any>]{
                    
                    for article in articles{
                       
                        if let article = ArticleData(json: article, src: source, img: #imageLiteral(resourceName: "ddogs")){
                        
                            articlesArr.append(article) 
                            
                        }
                    }
                    
                }
                    completion(articlesArr)
                
            }
        }
    }
    
    func getImage(source: String, completion: @escaping(UIImage) -> ()){
        
        get(request: clientURLRequest(newsSource: source)) { (success, object) in
            var image: UIImage!
            
            if let object = object as? UIImage{
                DispatchQueue.main.async(execute: {
                image = object
                })
                completion(image)
            }
        }
    }
    
    
    private func get(request: NSMutableURLRequest, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        dataTask(request: request, method: "GET", completion: completion)
    }
    
    private func clientURLRequest(newsSource: String, params: Dictionary<String, AnyObject>? = nil) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "https://newsapi.org/v1/articles?source="+newsSource+"&apiKey=e0b402efc2984534a2472ecf41b55c6a")! as URL)
        
        return request
    }
    
    private func dataTask(request: NSMutableURLRequest, method: String, completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()) {
        request.httpMethod = method
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                    completion(true, json as AnyObject)
                } else {
                    completion(false, json as AnyObject)
                }
            }
            }.resume()
    }


}
