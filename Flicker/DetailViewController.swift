//
//  DetailViewController.swift
//  Flicker
//
//  Created by Kevin Chow on 1/19/16.
//  Copyright © 2016 Kevin Chow. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieNavTitle: UINavigationItem!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.height)
        
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        let basePath = "http://image.tmdb.org/t/p/w500"
        if let posterPath = movie["poster_path"] as? String {
            print(movie["poster_path"])
            let imageURL = NSURL(string: basePath + posterPath)
            movieImage.setImageWithURL(imageURL!)
        }
        movieTitle.text = title
        movieOverview.text = overview
        movieNavTitle.title = title
        movieOverview.sizeToFit()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }*/
    

}
