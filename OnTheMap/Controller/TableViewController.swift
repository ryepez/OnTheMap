//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Ramon Yepez on 5/9/21.
//

import UIKit

class TableViewController: UITableViewController {
    // property to get the data source
    var dataSource = [StudentProperties]()
    
    //student posting status 
    var hasStudentPosted = Bool()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loading the data from DataModel
        dataSource = DataModel.studentLocations
        if let respuesta = NetworkRequests.Auth.checkIfStudentPostedAlready {
            hasStudentPosted = respuesta
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Top buttons
    
    @IBAction func logOut(_ sender: UIButton) {
        
        NetworkRequests.logDelete(completion: handleSessionDelete(success:error:))
    }
    
    func handleSessionDelete(success: Bool, error: Error?) {
        if success {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let LoginNavigationController = storyboard.instantiateViewController(identifier: "LoginNavigationController")
            
            //to cHAnge the root view controller calling the object created in scene delegete
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(LoginNavigationController)
        } else {
            print("Unable to logout!")
        }
    }
    
   
    @IBAction func loadData(_ sender: UIBarButtonItem) {
        
        dataSource.removeAll()
        
        NetworkRequests.getStudentLocation {
            (studentLocation, error) in
            
            //saving the data on data object
            DataModel.studentLocations = studentLocation
            //calling a helper method that formats the data in the way that map can use and adding the data to map
            self.dataSource = DataModel.studentLocations
            self.tableView.reloadData()
    }
        
    }
    
    func overrideLocation()  {
        let alert = UIAlertController(title: "You Have Already Posted a Student Location. Would You Like to Overwrite You Current Location?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Overwrite", style: .destructive, handler: {(action) in
                                      self.transferToOverWriteLocation()
                                  }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func transferToOverWriteLocation() {
                
        NetworkRequests.Auth.checkIfStudentPostedAlready = hasStudentPosted
        
        performSegue(withIdentifier: "AddNewPinViewSentTable", sender: self)
    }
    
    @IBAction func addLocation(_ sender: UIBarButtonItem) {
    
        //if hasStudentPosted is false it means that students has not posted
        // if the student has posted then an alert will appear
        if hasStudentPosted {
            overrideLocation()
        } else {
        //This is the option when the user has not posted anything before
            
            NetworkRequests.Auth.checkIfStudentPostedAlready = hasStudentPosted

            performSegue(withIdentifier: "AddNewPinViewSentTable", sender: self)
    }
    }
    

    
    // Marks: Table view setup
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        let firstName = dataSource[(indexPath as NSIndexPath).row].firstName
        let lastName = dataSource[(indexPath as NSIndexPath).row].lastName

        let webSite = dataSource[(indexPath as NSIndexPath).row].mediaURL
        cell?.textLabel?.text = firstName + " " + lastName
        cell?.detailTextLabel?.text = webSite
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let toOpen = dataSource[(indexPath as NSIndexPath).row].mediaURL
            guard let url = URL(string: toOpen) else {
              return
            }
        //open safari when select row
            UIApplication.shared.open(url, options: [:], completionHandler: nil)

    }
    
}
