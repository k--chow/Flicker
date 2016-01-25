//
//  MovieViewController.swift
//  Flicker
//
//  Created by Kevin Chow on 1/14/16.
//  Copyright © 2016 Kevin Chow. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [NSDictionary]?
    
    var filterText: [String]!
    
    var filteredData: [NSDictionary]?
    
    var endPoint: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor(red: 0, green: 0.6667, blue: 0.1647, alpha: 1.0)
        navigationController!.navigationBar.setBackgroundImage(UIImage(named: "nav_background"), forBarMetrics: .Default)
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        loadDataFromNetwork()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredData = movies
        self.tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //let resultPredicate = NSPredicate(format: "name contains[c] %@", searchText)
        filteredData = searchText.isEmpty ? movies : movies!.filter {
            $0["title"]!.containsString(searchText)
        }
        tableView.reloadData()
    }
    
    func loadDataFromNetwork() {
        
        // Display HUD right before next request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        //API Call
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endPoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.filteredData = self.movies
                            self.tableView.reloadData()
                            
                            
                    }
                }
       
                
                // Hide HUD once network request comes back (must be done on main UI thread)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                // ...
                
        });
        task.resume()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if movies not nil
        if let movies = movies {
            return filteredData!.count;
        } else {
            return 0;
        }
        
    }
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }}*/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = filteredData![indexPath.row]
        let title = movie["title"] as! String
        //self.data.append(title)
        let overview = movie["overview"] as! String
        let basePath = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
        let imageURL = NSURL(string: basePath + posterPath)
        let imageRequest = NSURLRequest(URL: imageURL!);
        cell.movieImage.setImageWithURLRequest(
            imageRequest, placeholderImage: nil, success:
            { (imageRequest, imageResponse, image) -> Void in
                
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.movieImage.alpha = 0.0
                    cell.movieImage.image = image
                    UIView.animateWithDuration(2.3, animations: { () -> Void in
                        cell.movieImage.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.movieImage.image = image
                }
            },
            failure: { (imageRequest, imageResponse, error) -> Void in
                
        })
        //cell.movieImage.setImageWithURL(imageURL!)
            
        }
        cell.movieTitle.text = title
        cell.movieOverview.text = overview
        cell.selectionStyle = .None
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
    

}

}