//
//  ViewController.swift
//  jmreader
//
//  Created by meiliangjun1_vendor on 2020/10/12.
//  Copyright © 2020 meiliangjun1_vendor. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    private var rssDatasources:[RSSInfo] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "RSS 列表"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.rssDatasources = RssDataManager.shareDM.getRssList()
        
        self.tableView.reloadData()
    }
    
    // MARK: tableview datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rssDatasources.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSInfoListCell", for: indexPath)
        
        cell.textLabel?.text = self.rssDatasources[indexPath.row].name
        cell.detailTextLabel?.text = self.rssDatasources[indexPath.row].url
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    // MARK: tableview delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.rssDatasources[indexPath.row];
        
        if let detailVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "RssSimpleDescViewControllerIdentifier") as? RssSimpleDescViewController {
            detailVC.rssItem = item
            self.navigationController?.show(detailVC, sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delAction = UIContextualAction(style: .destructive, title: "删除") { [weak self](action, view, finish) in
            RssDataManager.shareDM.removeRss(with: indexPath.row)
            finish(true)
            
            self?.rssDatasources = RssDataManager.shareDM.getRssList()
            self?.tableView.reloadData()
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [delAction])
        return swipeActions
    }

}

class RSSInfo {
    var name:String = ""
    var url:String = ""
    
    var isSelected: Bool = false
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

