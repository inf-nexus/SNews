//
//  ViewController.swift
//  SNews
//
//  Created by Jacob Contreras on 4/24/17.
//  Copyright © 2017 Jacob Contreras. All rights reserved.
//

import UIKit
import CoreData

var articleClicked = 0
var loaded: Bool = false
var cache = NSCache<AnyObject, AnyObject>()
var globalNewsArticles: [ArticleData] = []
var savedNewsArticles: [ArticleData] = []
var appDelegate: AppDelegate!
class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    let newsSites = ["bbc-news","business-insider","espn"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        NewsDataClient.sharedClient.getMultipleStories(newsSites: ["bbc-news","business-insider","espn"]){[weak self](newsArticles) in
            
            DispatchQueue.main.async(execute: {
                loaded = true
                //print(globalNewsArticles.count)
                globalNewsArticles = newsArticles
                self?.tableView.reloadData()
            })
        }
        
    
        }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ArticleTableViewCell", owner: self, options: nil)?.first as! ArticleTableViewCell
        
        URLSession.shared.dataTask(with: NSURL(string: globalNewsArticles[indexPath.row].imgUrl)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                cell.configure(article: globalNewsArticles[indexPath.row], image: image!)
                
                
            })
            
        }).resume()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let topSpace: CGFloat = 17
        let topLabelHeight: CGFloat = 21
        let topLabelSpacing: CGFloat = 6
        let extraBuffer: CGFloat = 12
        
        let article = globalNewsArticles[indexPath.row]
        let font = UIFont(name: "Helvetica", size: 13.0)!
        
        let descRect = (article.description as NSString).boundingRect(with: CGSize(width: 261, height: 9999), options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: NSStringDrawingContext())
        
        let titleFont = UIFont(name: "Helvetica", size: 18.0)!
        let titleRect = (article.title as NSString).boundingRect(with: CGSize(width: 261, height: 9999), options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: titleFont], context: NSStringDrawingContext())
        
        let descHeight: CGFloat = descRect.height
        let titleHeight: CGFloat = titleRect.height
        
        return topSpace + topLabelSpacing + descHeight + titleHeight + extraBuffer + topLabelHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalNewsArticles.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            articleClicked = indexPath.row
            self.performSegue(withIdentifier: "toArticle", sender: nil)
        })
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toArticle" {
            
            let articleViewController = segue.destination as! ArticleViewController
            articleViewController.article = globalNewsArticles[articleClicked]
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var rect: CGRect = self.headerView.frame
        rect.origin.y = min(0, self.tableView.contentOffset.y)
        self.headerView.frame = rect
    }
    
}

