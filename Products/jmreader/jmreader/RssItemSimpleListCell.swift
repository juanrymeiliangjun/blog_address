//
//  RssItemSimpleListCell.swift
//  jmreader
//
//  Created by meiliangjun1_vendor on 2020/10/13.
//  Copyright © 2020 meiliangjun1_vendor. All rights reserved.
//

import UIKit

protocol RssItemSimpleListCellDelegate: AnyObject {
    func onClickRssItem(cell: RssItemSimpleListCell, folder: Bool)
}

class RssItemSimpleListCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    var rssItem: NewsDetail? = nil
    
    weak var actionDelegate: RssItemSimpleListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configItem(rssItem: NewsDetail) {
        self.rssItem = rssItem
        
        if rssItem.isFolder {
            self.contentLabel.numberOfLines = 0
        } else {
            self.contentLabel.numberOfLines = 3
        }
        
        self.titleLabel.text = rssItem.title;
        self.timeLabel.text = rssItem.pubTime
        self.sourceLabel.text = rssItem.source
        self.contentLabel.text = rssItem.content
        self.moreButton.setTitle(rssItem.isFolder ? "收起" : "展开", for: .normal)
        
    }

    @IBAction func clickFolderAction(_ sender: UIButton) {
        actionDelegate?.onClickRssItem(cell: self, folder: !(self.rssItem?.isFolder ?? false))
    }
}
