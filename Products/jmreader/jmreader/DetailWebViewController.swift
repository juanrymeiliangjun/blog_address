//
//  DetailWebViewController.swift
//  jmreader
//
//  Created by meiliangjun1_vendor on 2020/10/13.
//  Copyright © 2020 meiliangjun1_vendor. All rights reserved.
//

import UIKit

import WebKit

class DetailWebViewController: UIViewController, UIScrollViewDelegate {
    
    var webView = WKWebView()
    
    var urlStr: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.scrollView.delegate = self
        
        self.navigationController?.hidesBarsOnTap = true
        self.navigationController?.hidesBarsOnSwipe = true
        
        
        self.view.addSubview(webView);
        webView.frame = self.view.bounds//CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        
        loadWebData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    private func loadWebData() {
        guard let str = self.urlStr, let url = URL(string: str) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    

}
