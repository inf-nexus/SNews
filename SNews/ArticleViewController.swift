//
//  ArticleViewController.swift
//  SNews
//
//  Created by Jacob Contreras on 4/25/17.
//  Copyright © 2017 Jacob Contreras. All rights reserved.
//

import UIKit
import CoreData

class ArticleViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    var article: ArticleData!
    
    @IBOutlet var articleTitle: UINavigationItem!
    
    @IBAction func saveArticle(_ sender: Any) {
        //context.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        savedNewsArticles.append(article)
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
        
            do {
                try context.save()
            }catch{
                print("context save error occured")
            }
        
    }
    
    
    var spinner = UIActivityIndicatorView()
    
    func configureView() {
        // Update the user interface for the detail item.
        
        articleTitle.title = article.title
        let myURL = NSURL(string: article.url)!
        
        
        webView.loadRequest(NSURLRequest(url: myURL as URL) as URLRequest)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async(execute: {
            self.spinner.center = self.view.center
            self.spinner.hidesWhenStopped = true
            self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            self.webView.addSubview(self.spinner)
            self.spinner.startAnimating()
            self.configureView()
            self.spinner.stopAnimating()
            
        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
