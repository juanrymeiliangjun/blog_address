//
//  RssSimpleDescViewController.swift
//  jmreader
//
//  Created by meiliangjun1_vendor on 2020/10/12.
//  Copyright © 2020 meiliangjun1_vendor. All rights reserved.
//

import UIKit

struct NewsDetail: Convertible {
    // <title>
    var title:String? = nil
    // <source>
    var source: String? = nil
    // <pubTime>
    var pubTime: String? = nil
    // <pubDate>
    var pubDate: String? = nil
    // <hitCount>
    var hitCount: String? = nil
    // <channel>
    var channel: String? = nil
    // <description>
    var description: String? = nil
    // <content>
    var content: String? = nil
    // <docId>
    var docId: String? = nil
    // <link>
    var link: String? = nil
    
    // MARK: Tools
    var isFolder = false
}

class RssSimpleDescViewController: UITableViewController, JMBaseXMLParserCallback, RssItemSimpleListCellDelegate {
    
    var rssItem: RSSInfo?
    var itemList: [NewsDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.rssItem?.name
        self.navigationItem.backBarButtonItem?.title = ""
        
        requestRssData()
    }
    
    private func requestRssData() {
        
        let queue = DispatchQueue(label: "com.apple.request.detail", attributes: .concurrent)
        
        queue.async { [unowned self] in
            // get xml
            guard let link = self.rssItem?.url, let url = URL(string: link) else {
                return
            }
            var rssRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20)
            rssRequest.httpMethod = "GET"
            
            rssRequest.setValue("text/xml,text/html", forHTTPHeaderField: "Content-Type")
            let rssDataTask = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: rssRequest) {[weak self](data, respons, error) in
                guard data != nil else {
                    print("respons is nil or get error: " + error.debugDescription)
                    return
                }
                
                let parser = StatsGOVParser(xmlData: data!)
                parser.delegate = self
                parser.prepareForParser()
            }
            
            rssDataTask.resume()
        }
        
    }
    
    // MARK: JMBaseXMLParserCallback
    func parser(completed items: [Any]) {
        self.itemList = items as! [NewsDetail]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RSSItemDetailIdentifier", for: indexPath) as! RssItemSimpleListCell

        // Configure the cell...
        cell.configItem(rssItem: itemList[indexPath.row])
        cell.actionDelegate = self

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailWebViewController()
        detailVC.urlStr = itemList[indexPath.row].link
        self.navigationController?.show(detailVC, sender: self)
    }
    
    // MARK: RssItemSimpleListCellDelegate
    func onClickRssItem(cell: RssItemSimpleListCell, folder: Bool) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        itemList[indexPath.row].isFolder = folder
        
        self.tableView.reloadData()
    }

}
