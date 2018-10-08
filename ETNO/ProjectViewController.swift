//
//  ProjectViewController.swift
//  ETNO
//
//  Created by Kevin Legarreta on 10/4/18.
//  Copyright © 2018 Los 5. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {
    
    var selected_project = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddParticipants"){
            let vc = segue.destination as! AddParticipantViewController
            vc.project_id = selected_project
        }
        else if (segue.identifier == "BackToDashboard"){
            let _ = segue.destination as! DashboardViewController
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
