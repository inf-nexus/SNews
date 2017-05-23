//
//  SavedArticlesViewController.swift
//  SNews
//
//  Created by Jacob Contreras on 4/25/17.
//  Copyright © 2017 Jacob Contreras. All rights reserved.
//

import UIKit
import CoreData


var context: NSManagedObjectContext!
var savedArticlesPopulated = false

class SavedArticlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        
    
        
    if(savedArticlesPopulated == false){
    
    DispatchQueue.main.async(execute: {
        let request = NSFetchRequest<Event>(entityName: "Event")
        

        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            print("results size: \(results.count)")
            if results.count > 0 {
                
                for result in results as [NSManagedObject]{
                    
                    let articleTitle = result.value(forKey: "title") as? String
                    let articleDescription = result.value(forKey: "desc") as? String
                    let urlString = result.value(forKey: "url") as? String
                    let imgUrlString = result.value(forKey: "imgUrl") as? String
                    let articleSource = result.value(forKey: "src") as? String
                    
                    let article = ArticleData(_title: articleTitle, _desc: articleDescription, _url: urlString, _imgUrl: imgUrlString, _src: articleSource, _img: #imageLiteral(resourceName: "ddogs"))
                    
                    if let article = article{
                        
                        savedNewsArticles.append(article)
                    
                    }
                    
                }
                
            }else{
                
                
            }
            savedArticlesPopulated = true
            
        } catch {
            print("result query failed")
        }
        
        
            self.tableView.reloadData()
        })
        
    }
    
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedNewsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ArticleTableViewCell", owner: self, options: nil)?.first as! ArticleTableViewCell
        
        URLSession.shared.dataTask(with: NSURL(string: savedNewsArticles[indexPath.row].imgUrl)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                cell.configure(article: savedNewsArticles[indexPath.row], image: image!)
            })
            
        }).resume()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let topSpace: CGFloat = 17
        let topLabelHeight: CGFloat = 21
        let topLabelSpacing: CGFloat = 6
        let extraBuffer: CGFloat = 12
        
        
        let article = savedNewsArticles[indexPath.row]
        let font = UIFont(name: "Helvetica", size: 13.0)!
        
        let descRect = (article.description as NSString).boundingRect(with: CGSize(width: 261, height: 9999), options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: NSStringDrawingContext())
        
        let titleFont = UIFont(name: "Helvetica", size: 18.0)!
        let titleRect = (article.title as NSString).boundingRect(with: CGSize(width: 261, height: 9999), options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: titleFont], context: NSStringDrawingContext())
        
        let descHeight: CGFloat = descRect.height
        let titleHeight: CGFloat = titleRect.height
        
        return topSpace + topLabelSpacing + descHeight + titleHeight + extraBuffer + topLabelHeight
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("im here in editing style!!!")
            savedNewsArticles.remove(at: indexPath.row)
            DispatchQueue.main.async(execute: {
                
                self.clearContextData()
                self.updateContextData()
                self.tableView.reloadData()
            })
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func updateContextData(){
        for article in savedNewsArticles{
            
            let title = article.title
            let desc = article.description
            let url = article.url
            let imgUrl = article.imgUrl
            let src = article.src
            let entity =  NSEntityDescription.entity(forEntityName: "Event", in: context)
            let transc = NSManagedObject(entity: entity!, insertInto: context)
            transc.setValue(title, forKey: "title")
            transc.setValue(desc, forKey: "desc")
            transc.setValue(url, forKey: "url")
            transc.setValue(imgUrl, forKey: "imgUrl")
            transc.setValue(src, forKey: "src")
            
            do{
                
                try context.save()
                
            }catch {
                
                print("save failed")
                
            }
            
        }
        
        
    }
    
    func clearContextData(){
        do {
            
            let request = NSFetchRequest<Event>(entityName: "Event")
            
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results {
                    
                    context.delete(result)
                    
                }
                
            }
            
            do{
                
                try context.save()
                
            }catch {
                
                print("save failed")
                
            }
            
        } catch {
            
            print("delete failed")
            
        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async(execute: {
            articleClicked = indexPath.row
            self.performSegue(withIdentifier: "toArticleFromSaved", sender: nil)
        })
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toArticleFromSaved" {
            
            let articleViewController = segue.destination as! ArticleViewController
            articleViewController.article = savedNewsArticles[articleClicked]
            
        }
    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
