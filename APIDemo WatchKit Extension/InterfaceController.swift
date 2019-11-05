//
//  InterfaceController.swift
//  APIDemo WatchKit Extension
//
//  Created by Navicky on 2019-11-02.
//  Copyright © 2019 Parrot. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class InterfaceController: WKInterfaceController {

    // MARK: Outlets
    @IBOutlet var sunriseLabel: WKInterfaceLabel!
    @IBOutlet var sunsetLabel: WKInterfaceLabel!
    @IBOutlet var cityLabel: WKInterfaceLabel!
    
    @IBOutlet var lblTime: WKInterfaceLabel!
    @IBOutlet var loadingSunriseImage: WKInterfaceImage!
    @IBOutlet var loadingSunsetImage: WKInterfaceImage!
    
    var max = Double()
    
    
    // MARK: variables
    var cityCoordinates:CLLocationCoordinate2D?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.n
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let preferences = UserDefaults.standard
        
        print("SHARED PREFERENCES OUTPUT")
        print(preferences.string(forKey: "savedLat"))
        print(preferences.string(forKey: "savedLng"))
        print(preferences.string(forKey: "savedCity"))
        
        
        var lat = preferences.string(forKey:"savedLat")
        var lng = preferences.string(forKey:"savedLng")
        var city = preferences.string(forKey:"savedCity")
        
        if (lat == nil || lng == nil || city == nil) {
            lat = "49.2827"
            lng = "-123.1207"
            city = "Vancouver"
           
        }
        
        // Update UI
         self.cityLabel.setText(city)
        
        // start animations
        self.showLoadingAnimations()
        
        // TODO: Put your API call here
        
       // let URL = "https://api.sunrise-sunset.org/json?lat=\(lat!)&lng=\(lng!)&date=today"
        //let URL = "https://samples.openweathermap.org/data/2.5/group?id=524901,703448,2643743&units=metric&appid=b6907d289e10d714a6e88b30761fae22"
        
        let URL = "https://api.darksky.net/forecast/252a5f0f6be2fab9856294c15e29987d/\(lat!),\(lng!)"
        
        //let URL = "https://samples.openweathermap.org/data/2.5/group?id=524901,703448,2643743&units=metric&appid=b6907d289e10d714a6e88b30761fae22"
        
       // print("Url: \(URL)")
        Alamofire.request(URL).responseJSON {
            // 1. store the data from the internet in the
            // response variable
            response in
            
            // 2. get the data out of the variable
            guard let apiData = response.result.value else {
                print("Error getting data from the URL")
                
                return
            }
            // GET sunrise/sunset time out of the JSON response
            let jsonResponse = JSON(apiData)
            
           // print(apiData)
            print(jsonResponse)
            
           // let sunriseTime = jsonResponse["list"][0]["main"]["temp_min"]
            let sunriseTime = jsonResponse["currently"]["dewPoint"]
            //let sunsetTime = jsonResponse["results"]["sunset"].string
            //let sunsetTime = jsonResponse["list"][0]["main"]["temp_max"]
            let sunsetTime = jsonResponse["currently"]["apparentTemperature"]
  
            // display in a UI
            print("************************************")
            print(sunriseTime)
            
            
            self.sunriseLabel.setText("\(sunriseTime)"+" F")
            self.sunsetLabel.setText("\(sunsetTime)"+" F")
            
            // stop the loading animation
            self.stopAnimations()
        }
    
    }
    
    
   
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    
    // MARK: Actions
    @IBAction func changeCityButtonPressed() {
        
    }
    
    func showLoadingAnimations() {
        // animate the sunrise label
        self.loadingSunriseImage.setImageNamed("Progress")
        self.loadingSunriseImage.startAnimatingWithImages(in: NSMakeRange(0, 10), duration: 1, repeatCount: 0)
        self.sunriseLabel.setText("Updating...")

        // animate the sunset label
        self.loadingSunsetImage.setImageNamed("Progress")
        self.loadingSunsetImage.startAnimatingWithImages(in: NSMakeRange(0, 10), duration: 1, repeatCount: 0)
        self.sunsetLabel.setText("Updating...")
    }
    
    func stopAnimations() {
        // sunrise loading image
        self.loadingSunriseImage.stopAnimating()
        self.loadingSunriseImage.setImage(nil)

        // sunset loading image
        self.loadingSunsetImage.stopAnimating()
        self.loadingSunsetImage.setImage(nil)
    }
    
}
