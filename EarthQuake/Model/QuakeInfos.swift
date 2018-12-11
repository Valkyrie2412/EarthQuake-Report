//
//  Features.swift
//  EarthQuake
//
//  Created by Hiếu Nguyễn on 11/20/18.
//  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
//

import UIKit

class QuakeInfos {
    
    
    // Master
    var mag: Double
    var distance: String
    var place: String
    var time: TimeInterval = Date().timeIntervalSince1970
    var dateString: String
    var timeString: String
    var url: String
    var detail: String
    
    
    //
    var felt: Int?
    var cdi: Double?
    var mmi: Double?
    var alert: String?
    
    var eventTime: String?
    var latitude: String?
    var longitude: String?
    var depth: String?
    
    
    init( mag: Double,  place: String, timeInterval: TimeInterval, url: String, detail: String) {
        self.mag = mag
        self.url = url
        self.detail = detail
        
        // Place, distance
        let splitString = place.components(separatedBy: "of")
        self.distance = (splitString.first ?? "") + "OF"
        self.place = splitString.last ?? ""
        
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .short
        self.timeString = dateFormater.string(from: Date(timeIntervalSince1970: timeInterval * 1/1000))
        dateFormater.timeStyle = .none
        dateFormater.dateStyle = .medium
        // dateFormater.locale = Locale(identifier: "vi")
        self.dateString = dateFormater.string(from: Date(timeIntervalSince1970: timeInterval * 1/1000))
    }
    
    
    convenience init?(dictionary: JSON) {
        guard let mag = dictionary["mag"] as? Double else {return nil}
        guard let place = dictionary["place"] as? String else {return nil}
        guard let timeInterval = dictionary["time"] as? TimeInterval else {return nil}
        guard let url = dictionary["url"] as? String else {return nil}
        guard let detail = dictionary["detail"] as? String else {return nil}
        self.init(mag: mag, place: place, timeInterval: timeInterval, url: url, detail: detail)
        
    }
    
    
    
    
    
    func loadDataDetail(completeHandler: @escaping (QuakeInfos) -> Void) {
        DataServices.sharedInstance.makeDataTaskRequest(urlString: detail) { (dictDetail) in
            guard let dictProperties = dictDetail["properties"] as? JSON else {return}
            let felt = dictProperties["felt"] as? Int
            
            let cdi = dictProperties["cdi"] as? Double
            let mmi = dictProperties["mmi"] as? Double
            let alert = dictProperties["alert"] as? String
            self.felt = felt
            self.cdi = cdi
            self.mmi = mmi
            self.alert = alert
            
            guard let dictProducts = dictProperties["products"] as? JSON else {return}
            guard let arrayOrigin = dictProducts["origin"] as? [JSON] else {return}
            guard let dictPropertiesOfOrigin = arrayOrigin[0]["properties"] as? JSON else {return}
            
            
            if let eventTime = dictPropertiesOfOrigin["eventtime"] as? String  {
                var convertEventTime = eventTime
                convertEventTime = convertEventTime.replacingOccurrences(of: "T", with: "  ")
                convertEventTime = convertEventTime.components(separatedBy: ".").first!
                self.eventTime = convertEventTime + " (UTC)"
            }
            
            if let depth = dictPropertiesOfOrigin["depth"] as? String  {
                self.depth = depth
            }
            
            // Latitude Longitude
            guard let latitude = dictPropertiesOfOrigin["latitude"] as? String else {return}
            guard let longitude = dictPropertiesOfOrigin["longitude"] as? String  else {return}
            
            func convertCoordinate(latitude: String, longitude: String) {
                if let latitudeDouble = Double(latitude) {
                    self.latitude = String(format:"%.3f°%@", abs(latitudeDouble), latitudeDouble >= 0 ? "N" : "S")
                }
                if let longitudeDouble = Double(longitude) {
                    self.longitude = String(format:"%.3f°%@", abs(longitudeDouble), longitudeDouble >= 0 ? "E" : "W")
                }
            }
            convertCoordinate(latitude: latitude, longitude: longitude)
            
            completeHandler(self)
        }
    }
    
}
