//
//  SystemRssListCell.swift
//  jmreader
//
//  Created by meiliangjun1_vendor on 2020/10/19.
//  Copyright © 2020 meiliangjun1_vendor. All rights reserved.
//

import UIKit

class SystemRssListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scribeButton: UIButton!
    
    private var rssInfo: RSSInfo?
    
    func configeRssInfo(rssInfo: RSSInfo) {
        self.rssInfo = rssInfo
        
        self.titleLabel.text = rssInfo.name
        self.scribeButton.isSelected = rssInfo.isSelected
    }
    
    @IBAction func clickSystemAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            // insert data to datasources
        } else {
            // remove data from datasource
        }
    }
    
}
