////
////  Detail.swift
////  EarthQuake
////
////  Created by Hiếu Nguyễn on 12/1/18.
////  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
////
//
//import Foundation
//
//class Detail {
//
//    // Master
//    var mag: Double
//    var distance: String
//    var place: String
//
//
//    // Detail
//    var felt: Int
//    var cdi: Double
//    var mmi: Double
//    var alert: String
//    var properties: [Property]
//
//    init(mag: Double, distance: String, place: String, felt: Int, cdi: Double, mmi: Double, alert: String, properties: [Property]) {
//
//
//        // Place, distance
//        let splitString = place.components(separatedBy: "of")
//        self.distance = (splitString.first ?? "") + "Of"
//        self.place = splitString.last ?? ""
//
//        self.mag = mag
//        self.felt = felt
//        self.cdi = cdi
//        self.mmi = mmi
//        self.alert = alert
//        self.properties = properties
//    }
//    convenience init(json: JSON) {
//        let properties = json["properties"] as? JSON ?? [:]
//        let mag = properties["mag"] as? Double ?? 999
//        let distance = properties["title"] as? String ?? ""
//        let place = properties["place"] as? String ?? ""
//        let felt = properties["felt"] as? Int ?? 0
//        let cdi = properties["cdi"] as? Double ?? 0
//        let mmi = properties["mmi"] as? Double ?? 0
//        let alert = properties["alert"] as? String ?? "null"
//        let products = properties["products"] as? JSON ?? [:]
//        let origin = products["origin"] as? [JSON] ?? []
//        var dataProperties: [Property] = []
//        let originProperties = origin[0]["properties"] as? JSON ?? [:]
//        dataProperties.append(Property(json: originProperties))
//
//        //        for dataOrigin in origin {
//        //            let properties = dataOrigin["properties"] as? JSON ?? [:]
//        //            dataProperties.append(Property(json: properties))
//        //        }
//
//        self.init(mag: mag, distance: distance, place: place, felt: felt, cdi: cdi, mmi: mmi, alert: alert, properties: dataProperties)
//    }
//}
//
//class Property {
//    var depth: String
//    var eventTime: String
//    var latitude: String
//    var longitude: String
//    init(depth: String, eventTime: String, latitude: String, longitude: String) {
//        self.depth = depth
//
//        // Event Time
//        var convertEventTime = eventTime
//        convertEventTime = convertEventTime.replacingOccurrences(of: "T", with: "  ")
//        convertEventTime = convertEventTime.components(separatedBy: ".").first!
//        self.eventTime = convertEventTime + " (UTC)"
//
//
//        // Latitude, Longitude
//        let roundLatDegrees = roundf(1000 * Float(latitude)!) / 1000
//        let latDegrees = roundLatDegrees
//        let roundLongDegrees = roundf(1000 * Float(longitude)!) / 1000
//        let longDegrees = roundLongDegrees
//
//        let latitude = String(format: "%.3f°%@",  abs(latDegrees), latDegrees >= 0 ? "N" : "S")
//        let longitude = String(format: "%.3f°%@", abs(longDegrees), longDegrees >= 0 ? "E" : "W" )
//        self.latitude = latitude
//        self.longitude = longitude
//
//    }
//    
//    convenience init(json: JSON) {
//        let depth = json["depth"] as? String ?? "999"
//        let eventTime = json["eventtime"] as? String ?? "999"
//        let latitude = json["latitude"] as? String ?? "999"
//        let longitude = json["longitude"] as? String ?? "999"
//        self.init(depth: depth, eventTime: eventTime, latitude: latitude, longitude: longitude)
//    }
//}
//
//
//
//
//
//
//
