//
//  FilmTableViewController.swift
//  HTTPdemo
//
//  Created by Christopher Chung on 7/16/18.
//  Copyright © 2018 Christopher Chung. All rights reserved.
//

import UIKit
import CoreData

class FilmTableViewController: UITableViewController {
    var films: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(from: "https://swapi.co/api/films/")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return films.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = films[indexPath.row]["title"] as? String
        return cell
    }
    func getData(from url: String){
        let url = URL(string: url)
        // create a URLSession to handle the request tasks
        let session = URLSession.shared
        // create a "data task" to make the request and run the completion handler
        let task = session.dataTask(with: url!, completionHandler: {
            // see: Swift closure expression syntax
            data, response, error in
            print("in here")
            // see: Swift nil coalescing operator (double questionmark)
            print(data ?? "no data") // the "no data" is a default value to use if data is nil
            
            do {
                // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary {
                    print(jsonResult["results"])
                    var newFilms = jsonResult["results"] as! [NSDictionary]
                    self.films.append(contentsOf: newFilms)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    if let nextUrl = jsonResult["next"] as? String{
                        print(nextUrl)
                        self.getData(from: nextUrl)
                    }
                }
            } catch {
                print(error)
            }
        })
        // execute the task and wait for the response before
        // running the completion handler. This is async!
        task.resume()
    }


}
