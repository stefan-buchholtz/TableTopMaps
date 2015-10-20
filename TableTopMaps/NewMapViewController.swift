//
//  NewMapViewController.swift
//  TableTopMaps
//
//  Created by Stefan Buchholtz on 20.10.15.
//  Copyright © 2015 Stefan Buchholtz. All rights reserved.
//

import UIKit

class NewMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel:")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ok", style: .Plain, target: self, action: "ok:")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ok(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)        
    }
    
    func cancel(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
