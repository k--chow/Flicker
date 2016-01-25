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
        let lowRes = "https://image.tmdb.org/t/p/w45"
        let highRes = "https://image.tmdb.org/t/p/original"
        if let posterPath = movie["poster_path"] as? String {
            let smallImageRequest = NSURLRequest(URL: NSURL(string: lowRes + posterPath)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: highRes + posterPath)!)
            
            movieImage.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available
                    // in cache (might want to do something smarter in that case).
                    self.movieImage.alpha = 0.0
                    self.movieImage.image = smallImage;
                    
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        
                        self.movieImage.alpha = 1.0
                        
                        }, completion: { (sucess) -> Void in
                            
                            // only allows one request to be sent at a time
                           self.movieImage.setImageWithURLRequest(
                                largeImageRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    
                               self.movieImage.image = largeImage;
                                    
                                },
                                failure: { (request, response, error) -> Void in
                                    // do something for the failure condition of the large image request
                                    
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    // do something for the failure condition
                                })
            //movieImage.setImageWithURL(imageURL!)
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
