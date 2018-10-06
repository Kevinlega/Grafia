//
//  AddParticipantViewController.swift
//  ETNO
//
//  Created by Kevin Legarreta on 10/2/18.
//  Copyright © 2018 Los 5. All rights reserved.
//

import UIKit

class AddParticipantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var id = [String()]
    var users = [String()]
    var FilteredUsers = [String()]
    var Searching = false
    
    

    // Create connection
    
    func GetUsers(){
        let apiLink = URL(string: "http://54.81.239.120/API.php?QueryType=GetUsers")
        
        let task = URLSession.shared.dataTask(with: apiLink!, completionHandler: {(data, response, error) -> Void in
            do
            {
                print("here")
                let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                print(jsonResponse)
                self.users = jsonResponse["name"] as! [String]
            
                self.id = jsonResponse["user_id"] as! [String]
                
                print("done")
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                
                }
                
            }
            catch{
                // nothing
                print("bad")
            }
            })
        task.resume()
        
    }

    // Work with the table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Searching{
            return FilteredUsers.count
        }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Row", for: indexPath)
        if Searching{
            cell.textLabel?.text = FilteredUsers[indexPath.row]
        }
        else{
           cell.textLabel?.text = users[indexPath.row]
        }
        
        return cell
    }
    
    // Work with the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            Searching = false
            view.endEditing(true)
            tableView.reloadData()
        }
        else{
            Searching = true
            FilteredUsers = users.filter({$0.localizedCaseInsensitiveContains(searchBar.text!)})
            
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetUsers()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddParticipants"){
            let _ = segue.destination as! ProjectViewController
        }
        else if (segue.identifier == "BackToProject"){
            let _ = segue.destination as! ProjectViewController
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
