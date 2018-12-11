//
//  DataService.swift
//  EarthQuake
//
//  Created by Hiếu Nguyễn on 11/23/18.
//  Copyright © 2018 Hiếu Nguyễn. All rights reserved.
//

import UIKit

typealias JSON = Dictionary<AnyHashable, Any>

class DataServices {
    static let sharedInstance: DataServices = DataServices()
    
    var urlString = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_week.geojson"
    var quakeInfos : [QuakeInfos] = []
    var selectedQuake : QuakeInfos?
    
    
    // Request API
    
    func makeDataTaskRequest(urlString: String, completedBlock: @escaping (JSON) -> Void ) {
        guard let url = URL(string: urlString) else {return}
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        //        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let jsonObject =  try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                else {return}
            guard let json = jsonObject as? JSON else {
                return
            }
            DispatchQueue.main.async {
                completedBlock(json)
            }
        }
        task.resume()
    }
    
    
    func getDataQuake(completeHandler: @escaping ([QuakeInfos]) -> Void) { // gia tri tra ve luu vao completeHandler
        
        quakeInfos = [] // reset gia tri cua mang sau moi lan load
        makeDataTaskRequest(urlString: urlString) { [unowned self] json in  // lay file json ra su dung sau khi da request api ve
            guard let dictionaryFeatures = json["features"] as? [JSON] else {return}
            for featureJSON in dictionaryFeatures {
                if let propertiesJSON = featureJSON["properties"] as? JSON {
                    if let quakeInfo = QuakeInfos(dictionary: propertiesJSON) {
                        self.quakeInfos.append(quakeInfo)
                    }
                }
            }
            completeHandler(self.quakeInfos) // luu mang quakeInfos vao completeHandler
        }
    }
    
    func checkInternet()  {
        if Reachability.isConnectedToNetwork() == true {
            showAlert(title: "Connected to the internet", message: "", okActionHandler: nil)
            
        } else {
            print("No internet connection")
            showAlert(title: "No internet connection", message: "", okActionHandler: nil)
        }
    }
}

func showAlert(title: String, message: String, okActionHandler: (() -> Void)?) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default){(result:UIAlertAction) -> Void in
        okActionHandler?()
        return
    }
    alertController.addAction(okAction)
    let rootVC = AppDelegate.shared.window?.rootViewController
    rootVC?.present(alertController, animated: true, completion: nil)
}


































