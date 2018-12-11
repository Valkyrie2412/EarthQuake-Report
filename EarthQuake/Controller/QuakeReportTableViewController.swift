//
//  TableViewController.swift
//  EarthQuake
//
//  Created by Hiếu Nguyễn on 11/20/18.
//  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
//

import UIKit

class QuakeReportTableViewController: UITableViewController {
    
    
    var quakeInfos = [QuakeInfos]()
    var filteredQuakeInfos = [QuakeInfos]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataServices.sharedInstance.checkInternet()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "EarthQuake"
        
        //Bằng việc gán protocol searchResultsUpdater, chúng ta có thể xác định mỗi khi ô text trong search bar được thay đổi.
        searchController.searchResultsUpdater = self
        // set là false để trong quá trình search, tableView của chúng ta không bị che khuất
        searchController.dimsBackgroundDuringPresentation = false
        // Ẩn/ hiện Navigation khi nút search active
        searchController.hidesNavigationBarDuringPresentation = false
        // true để search bar của chúng ta không bị lỗi layout khi sử dụng
        definesPresentationContext = true
        //hien thi
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search AnyWhere"
        navigationItem.searchController = searchController
        
        
        DataServices.sharedInstance.getDataQuake { (quakeInfo) in
            self.quakeInfos = quakeInfo
            self.filteredQuakeInfos = self.quakeInfos
            // Setup the Search Controller
            self.tableView.reloadData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: . flagsChanged, object: Network.reachability)
        updateUserInterface()
    }
    
    
    
    
    func updateUserInterface() {
        guard let status = Network.reachability?.status else { return }
        switch status {
        case .unreachable:
            view.backgroundColor = .white
        case .wifi:
            view.backgroundColor = .green
        case .wwan:
            view.backgroundColor = .yellow
        }
        print("Reachability Summary")
        print("Status:", status)
        print("HostName:", Network.reachability?.hostname ?? "nil")
        print("Reachable:", Network.reachability?.isReachable ?? "nil")
        print("Wifi:", Network.reachability?.isReachableViaWiFi ?? "nil")
    }
    
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
        DataServices.sharedInstance.checkInternet()
    }
    
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredQuakeInfos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuakeReportTableViewCell
        
        // Configure the cell...
        
        cell.magLabel.text = String(describing: filteredQuakeInfos[indexPath.row].mag)
        cell.distanceLabel.text = filteredQuakeInfos[indexPath.row].distance
        cell.placeLabel.text = filteredQuakeInfos[indexPath.row].place
        cell.dateLabel.text = filteredQuakeInfos[indexPath.row].dateString
        cell.timeLabel.text = filteredQuakeInfos[indexPath.row].timeString
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let screenQuakeDetail = segue.destination as? QuakeDetailViewController {
            if let index = tableView.indexPathForSelectedRow {
                screenQuakeDetail.urlOfRow = filteredQuakeInfos[index.row].url
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DataServices.sharedInstance.selectedQuake = filteredQuakeInfos[indexPath.row]
    }
}

extension QuakeReportTableViewController: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredQuakeInfos = searchText.isEmpty ? (quakeInfos) : (quakeInfos.filter({ (data) -> Bool in
            return data.place.lowercased().contains(searchText.lowercased())
        }))
        tableView.reloadData()
    }
}

