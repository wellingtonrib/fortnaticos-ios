//
//  NewsViewController.swift
//  fortnaticos-ios
//
//  Created by Well on 02/11/20.
//  Copyright © 2020 JWAR. All rights reserved.
//

import UIKit

struct NewsItem {
    var imageURL: String!
    var title: String!
    var body: String!
}

class NewsViewController: UITableViewController {

    let newsViewModel: NewsViewModel = NewsViewModel()
    
    var newsItems = [NewsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.tableFooterView = UIView()
        
        self.registerObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.newsViewModel.getNews()
    }
    
    func registerObservers() {
        self.newsViewModel.news.observe { (news) in
            switch(news.status){
            case .LOADING:
                break
            case .SUCCESS:
                self.bindNews(news: news.data)
            case .ERROR:
                _ = self.alert(title: "Não foi possível recuperar as notíficas", message: "")
            }
        }
    }
    
    func bindNews(news: NewsDTO?) {
        self.newsItems.removeAll()
        news?.data.motds.forEach({ (newsMotd) in
            self.newsItems.append(NewsItem(imageURL: newsMotd.tileImage ?? newsMotd.image, title: newsMotd.title, body: newsMotd.body))
        })
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsItemTableViewCell", for: indexPath) as! NewsItemTableViewCell

        // Configure the cell...
        let news = self.newsItems[indexPath.row]
        _ = cell.newImageView.load(url: news.imageURL)
        cell.titleLabel.text = news.title
        cell.bodyLabel.text = news.body

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class NewsItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
}
