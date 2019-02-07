//
//  MoviesViewController.swift
//  flixster
//
//  Created by Andrew Hoang on 2/4/19.
//  Copyright © 2019 andrewhoang7@gmail.com. All rights reserved.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //create a array of dictionaries. You indicate the type of the key and then
    //the type of the value
    //the () indicates that it's a creation of something
    
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                //look into the dictionary and spit out results
                self.movies = (dataDictionary["results"] as! [[String:Any]])

                //reload your data (this will call the two programs at the bottom
                //if you didn't have this, then your functions would not be able to work
                self.tableView.reloadData()

                //dataDictionary is the variable that will store ALL of your data

                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data

            }
        }
        task.resume()

        // Do any additional setup after loading the view.
    }
    
    //asks for a number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    //for a particular row, return a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //having a lot of cells takes up a lot of memory!
        //dqueueReusableCell allows device to recyle any available cells for current use
        //if there's no available cells, then create a new one
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        
        //get the current movie. indexPath.row will be movie 1, movie 2, movie 3, so forth
        let movie = movies[indexPath.row]
        
        //get the title of the movie
        //as! is part of something called casting. It's saying the title is a string and you want the "title" variable to be a string
        let title = movie["title"] as! String
        
        //the movie synopsis is classified as "overview" in the API's dictionary
        //
        let synopsis = movie["overview"] as! String
    
        //whatever the value of indexPath.row is, make it into a string?
        cell.titleLabel.text = title
        
        //configure out outlet label "synopsisLabel" to say the "overview" text
        cell.synopsisLabel.text = synopsis
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL (string: baseURL + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
