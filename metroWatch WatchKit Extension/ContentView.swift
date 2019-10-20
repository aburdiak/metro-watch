//
//  ContentView.swift
//  metroWatch WatchKit Extension
//
//  Created by Andrew Burdiak on 10/13/19.
//  Copyright © 2019 Andrew Burdiak. All rights reserved.
//

import SwiftUI

    var response = String()
    func callApi() -> String {
        let session = URLSession.shared
        let apiUrl = URL(string: "https://li8uik1420.execute-api.us-east-1.amazonaws.com/dev/getStationInfo")!
              
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json = [
            "stationId": "K01",
            "lineId": "SV",
            "numberOfResults": "3"
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])

        var responseData = String()
        
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                // print(json)
                
                if let array = json as? [Any] {
                    if let firstObject = array.first {
                        // access individual object in array
                        print(firstObject)
                        if let dictionary = firstObject as? [String: Any] {
                            print(dictionary)
                                if let number = dictionary["minutesAway"] as? Double {
                                // access individual value in dictionary
                                    print(number)
                                    responseData = "train is some minutes away"
                                } else {
                                    responseData = "I don't know how far away it is:("
                            }
                            

                        } else {
                            responseData = "bad dictionary"
                        }
                    } else {
                        responseData = "bad first object"
                    }
                
               
                }
                
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
            

            
        }
        task.resume()
        return responseData
        


/*
        let task = session.dataTask(with: apiUrl) { (data, response, error) in
            print(data)
            print(response)
            print(error)
            if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                print(json)
            }
        }*/
       // return "hello there again"
    }


struct ContentView: View {
    var body: some View {
       Text(callApi())
    }
}
func greet(person: String) -> String {
    let greeting = "Hello, " + person + "!"
    return greeting
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


