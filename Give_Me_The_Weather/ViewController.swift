//
//  ViewController.swift
//  Give_Me_The_Weather
//
//  Created by Jason Shultz on 10/6/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBAction func findWeather(sender: AnyObject) {
        
        print("i am here")
        
        let city = cityTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).stringByReplacingOccurrencesOfString(" ", withString: "-") // remove trailing spaces, replace other spaces with -
        
        var wasSuccessful = false
        
        let attemptedURL = NSURL(string: "http://www.weather-forecast.com/locations/" + city + "/forecasts/latest")
        
        if let url = attemptedURL {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                if let urlContent = data {
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    let websiteArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    if websiteArray!.count > 1 {
                        
                        let weatherArray = websiteArray![1].componentsSeparatedByString("</span>")
                        
                        if weatherArray.count > 0 {
                            
                            wasSuccessful = true
                            
                            let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.resultLabel.text = weatherSummary
                                self.cityTextField.text = ""
                                self.cityTextField.resignFirstResponder()
                                print(weatherSummary)
                            })
                        }
                        
                        
                        
                    } else {
                        self.resultLabel.text = "Could not find weather for that city, please try again."
                    }
                    
                } else {
                    self.resultLabel.text = "Could not find weather for that city, please try again."
                }
            }
            task.resume()
        }
        
        
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.cityTextField.delegate = self
        
        let url = NSURL(string: "http://www.weather-forecast.com/locations/Paris/forecasts/latest")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            if let urlContent = data {
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                let websiteArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                if websiteArray!.count > 0 {
                    
                    let weatherArray = websiteArray![1].componentsSeparatedByString("</span>")
                    
                    if weatherArray.count > 0 {
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.resultLabel.text = weatherSummary
                        })
                    }
                    
                    
                    
                }
                
            } else {
                print("something went wrong")
            }
        }
        
        task.resume()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

