//
//  RssListController.swift
//  jmreader
//
//  Created by meiliangjun1_vendor on 2020/10/19.
//  Copyright © 2020 meiliangjun1_vendor. All rights reserved.
//

import UIKit

class RssListController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 48.0
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RssDataManager.shareDM.getSystemRssList().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SystemRssListCell_identifier", for: indexPath) as! SystemRssListCell

        cell.configeRssInfo(rssInfo: RssDataManager.shareDM.getSystemRssList()[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = RssDataManager.shareDM.getSystemRssList()[indexPath.row];
        
        if let detailVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "RssSimpleDescViewControllerIdentifier") as? RssSimpleDescViewController {
            detailVC.rssItem = item
            self.navigationController?.show(detailVC, sender: self)
        }
    }

}
