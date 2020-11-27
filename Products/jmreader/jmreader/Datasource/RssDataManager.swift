//
//  RssDataManager.swift
//  jmreader
//
//  Created by meiliangjun1_vendor on 2020/10/19.
//  Copyright © 2020 meiliangjun1_vendor. All rights reserved.
//

import Foundation

let kRssDataManagerUpdateNotify = "kRssDataManagerUpdateNotify_identify"

class RssDataManager {
    
    static let shareDM = RssDataManager()
    private init() {}
    
    private var rssDatasources:[RSSInfo] = []
    
    func getSystemRssList() -> [RSSInfo] {
        guard let sdPath = Bundle.main.path(forResource: "RssSystemData", ofType: "plist") else {
            return []
        }
        
        guard let dict = NSDictionary(contentsOfFile: sdPath) else {
            return []
        }
        
        var rssList:[RSSInfo] = []
        for key in dict.allKeys {
            if key is String {
                let list = dict[key] as! [[String: String]]
                for td in list {
                    rssList.append(RSSInfo(name: td["title"] ?? "", url: td["url"] ?? ""))
                }
            }
        }
        
        return rssList
    }
    
    func getRssList() -> [RSSInfo] {
        var subjects = UserDefaults.standard.value(forKey: "subject_list_key") as? [[String]]
        
        if subjects?.count ?? 1 <= 0 || ((subjects?.isEmpty) == nil) {
            subjects = [["国家统计局数据解读", "http://www.stats.gov.cn/tjsj/zxfb/rss.xml"], ["国家统计局最新发布", "http://www.stats.gov.cn/tjsj/sjjd/rss.xml"], ["知乎每日精选", "https://www.zhihu.com/rss"]]
            UserDefaults.standard.set(subjects, forKey: "subject_list_key")
            UserDefaults.standard.synchronize()
        }
        
        self.rssDatasources.removeAll()
        for items in subjects! {
            self.rssDatasources.append(RSSInfo(name: items.first!, url: items.last!))
        }
        
        return self.rssDatasources
    }
    
    func publishRss(title: String, link: String) {
        var subjects: [[String]] = UserDefaults.standard.mutableArrayValue(forKey: "subject_list_key") as! [[String]]
        
        subjects.append([title, link])
        UserDefaults.standard.set(subjects, forKey: "subject_list_key")
        UserDefaults.standard.synchronize()
        
        self.rssDatasources.append(RSSInfo(name: title, url: link))
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kRssDataManagerUpdateNotify), object: nil)
    }
    
    func removeRss(with rId: String) {
//        for rssInfo in self.rssDatasources {
//            // do something...
//        }
    }
    
    func removeRss(with index: Int) {
        guard index < self.rssDatasources.count else {
            return
        }
        
        self.rssDatasources.remove(at: index)
        
        var trss: [[String]] = []
        for rss in self.rssDatasources {
            trss.append([rss.name, rss.url])
        }
        
        UserDefaults.standard.set(trss, forKey: "subject_list_key")
    }
}
