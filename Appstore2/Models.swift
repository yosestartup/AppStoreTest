//
//  Models.swift
//  Appstore2
//
//  Created by Oleksandr Bambulyak on 02.06.2018.
//  Copyright © 2018 Oleksandr Bambulyak. All rights reserved.
//

import Foundation
import UIKit

class AppCategory: NSObject {
    
    var name: String?
    var apps: [App]?
    var type: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps" {
            
            apps = [App]()
            
            for dict in value as! [[String: AnyObject]] {
                let app = App()
                app.setValuesForKeys(dict)
                apps?.append(app)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
    }
    static func fetchFeaturedApps(completionHandler: @escaping ([AppCategory]) -> ()) {
        let urlString = "https://web.archive.org/web/20160728200642/www.statsallday.com/appstore/featured"
        
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) -> Void in
            
            if error != nil {
                print (error)
                return
            }
            
            do {
                
                let json = try (JSONSerialization.jsonObject(with: data!, options: .allowFragments)) as! [String: Any]
                
                 var appCategories = [AppCategory]()
                
                if let categories = json["categories"] as? [[String: Any]] {
                    for dict in categories{
                          let appCategory = AppCategory()
                          appCategory.name = dict["name"] as! String
                        
                        
                           if let apps = dict["apps"] {
                            
                            var appsArray = [App]()
                            
                            for app in apps as! [[String: AnyObject]] {
                                let appSingle = App()
                                
                                if let name = app["Name"] {
                                    appSingle.name = name as! String
                                }
                               
                                if let price = app["Price"] {
                                    appSingle.price = price as! NSNumber
                                }
                                
                                if let category = app["Category"]{
                                    appSingle.category = category as! String
                                }
                                
                                if let imageName = app["ImageName"] {
                                    appSingle.imageName = imageName as! String
                                }
                                
                                appsArray.append(appSingle)
                                
                            }
                            
                           appCategory.apps = appsArray
                            }
                            
                            appCategories.append(appCategory)
                    
                    }
                }
                
                DispatchQueue.main.async {
                     completionHandler(appCategories)
                }
               
                
                //print (json)
                
                
            } catch let errorT {
                print (errorT)
            }
            
        }.resume()
    }
    
//    static func sampleAppCategories() -> [AppCategory] {
//
//        let bestNewAppsCategory = AppCategory()
//        bestNewAppsCategory.name = "Best New Apps"
//
//        var bestNewApps = [App]()
//
//        let frozenApp = App()
//        frozenApp.name = "Disney Build It: Frozen"
//        frozenApp.category = "Entertainment"
//        frozenApp.imageName = "frozen"
//        frozenApp.price = NSNumber(floatLiteral: 3.99)
//        bestNewApps.append(frozenApp)
//
//        bestNewAppsCategory.apps = bestNewApps
//
//
//        let bestNewGamesCategory = AppCategory()
//        bestNewGamesCategory.name = "Best New Games"
//
//        var bestNewGamesApps = [App]()
//
//        let telepaintApp = App()
//        telepaintApp.name = "Telepaint"
//        telepaintApp.category = "Games"
//        telepaintApp.imageName = "telepaint"
//        telepaintApp.price = NSNumber(floatLiteral: 3.99)
//        bestNewGamesApps.append(telepaintApp)
//
//        bestNewGamesCategory.apps = bestNewGamesApps
//
//        return [bestNewAppsCategory, bestNewGamesCategory]
//    }
//
}

class App: NSObject {
    
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName: String?
    var price: NSNumber?
}
