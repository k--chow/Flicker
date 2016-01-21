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
    @IBOutlet weak var movieOverview: UILabel!
    
    var movie: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie)
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String

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
