//
//  MoreDetailTableViewController.swift
//  EarthQuake
//
//  Created by Hiếu Nguyễn on 11/26/18.
//  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
//

import UIKit

class MoreDetailTableViewController: UITableViewController {
    
    //    var urlDetail: String?
    //    var dataDetail: Detail?
    //    var dataPro: Property?
    
    var dataDetail: QuakeInfos?
    
    @IBOutlet weak var magLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var feltLabel: UILabel!
    @IBOutlet weak var cdiLabel: UILabel!
    @IBOutlet weak var mmiLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    enum CellType: Int {
        case mag
        case time
        case depth
        case latitude
        case longitude
        case felt
        case cdi
        case mmi
        case alert
        case place
        
        func needToShow(dataDetail: QuakeInfos?) -> Bool {
            switch self {
            case .mag:
                return dataDetail?.mag != nil
            case.place:
                return !checkStringisNullOrEmpty(string: dataDetail?.distance) && !checkStringisNullOrEmpty(string: dataDetail?.place)
            case .time:
                return !checkStringisNullOrEmpty(string: dataDetail?.eventTime)
            case .depth:
                return !checkStringisNullOrEmpty(string: dataDetail?.depth)
                
            case .latitude:
                return !checkStringisNullOrEmpty(string: dataDetail?.latitude)
                
            case .longitude:
                return !checkStringisNullOrEmpty(string: dataDetail?.longitude)
                
            case .felt:
                return dataDetail?.felt != nil
            case .cdi:
                return dataDetail?.cdi != nil
            case .mmi:
                return dataDetail?.mmi != nil
            case .alert:
                return !checkStringisNullOrEmpty(string: dataDetail?.alert)
                
            }
        }
        
        private func checkStringisNullOrEmpty(string: String?) -> Bool {
            guard let aString = string else {return true}
            if aString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return true
            }
            return false
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataServices.sharedInstance.selectedQuake?.loadDataDetail { [unowned self] (quakeInfo) in
            self.dataDetail = quakeInfo
            
            if  let mag = self.dataDetail?.mag {
                self.magLabel.text = "Mag:" + " " + String(mag)
            }
            if  let place = self.dataDetail?.place {
                self.placeLabel.text = "Place:" + " "  + place
            }
            
            if  let latitude = self.dataDetail?.latitude {
                self.latitudeLabel.text = "Latitude:" + " "  + latitude
            }
            if  let longitude = self.dataDetail?.longitude {
                self.longitudeLabel.text = "Longitude:" + " "  + longitude
            }
            if  let depth = self.dataDetail?.depth {
                self.depthLabel.text = "Depth:" + " "  + depth
            }
            if  let eventTime = self.dataDetail?.eventTime {
                self.timeLabel.text = "EventTime:" + " "  + eventTime
            }
            if let felt = self.dataDetail?.felt {
                self.feltLabel.text = "Felt:" + " "  + String(felt)
            }
            if let cdi = self.dataDetail?.cdi {
                self.cdiLabel.text = "Cdi:" + " "  + String(cdi)
            }
            if let mmi = self.dataDetail?.mmi {
                self.mmiLabel.text = "Mmi:" + " "  + String(mmi)
            }
            if  let alert = self.dataDetail?.alert {
                self.alertLabel.text = "Alert:  " + alert
            }
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellType = CellType(rawValue: indexPath.row) {
            return cellType.needToShow(dataDetail: dataDetail) ? UITableView.automaticDimension : 0
        } else {
            return 0
        }
    }
    
}

