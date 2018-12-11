//
//  QuakeDetailViewController.swift
//  EarthQuake
//
//  Created by Hiếu Nguyễn on 11/24/18.
//  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
//

import UIKit
import WebKit

class QuakeDetailViewController: UIViewController, WKNavigationDelegate {
    
    var urlOfRow = ""
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(webView)
        if let url = URL(string: urlOfRow) {
            webView.load(URLRequest(url: url))
        }
    }
}
