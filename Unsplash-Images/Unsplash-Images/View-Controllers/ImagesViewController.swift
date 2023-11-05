//
//  ViewController.swift
//  Unsplash-Images
//
//  Created by Karthikeyan Muthu on 30/10/23.
//

import UIKit
import Reachability
class ImagesViewController: UIViewController {
    let reachability = try! Reachability()
    var total_pages = 3
    var currentPage = 1
    var results = [Result]()  // actual data
    var filteredData = [Result]()
    var selectedSort = false
    var latest:String?
    var oldest:String?
    var featured:String?
    private var viewmodel = ImagesViewModel()
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var searchbar: UISearchBar!
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        spinner.startAnimating()
        searchbar.barTintColor = UIColor.white
        searchbar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)

        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableview.addSubview(refreshControl)
        viewmodel.getImages(currentPage, self)
        
    }
    //MARK: - REFRESH
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        print("Refreshing")
        self.currentPage = 1
        self.latest = nil
        self.oldest = nil
        self.featured = nil
        self.results = []
        self.filteredData = []
        viewmodel.getImages(currentPage, self,true)
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           DispatchQueue.main.async {
               
               self.reachability.whenReachable = { reachability in
                   if reachability.connection == .wifi {
                       print("Reachable via WiFi")
                   } else {
                       print("Reachable via Cellular")
                   }
                   self.view.window?.rootViewController?.dismiss(animated: true)
               }
               self.reachability.whenUnreachable = { _ in
                   print("Not reachable")
                   if let networkVC = self.storyboard?.instantiateViewController(identifier: "NoInternetViewController") as? NoInternetViewController{
                       self.present(networkVC, animated: true)
                   }
               }
               
               do {
                   try self.reachability.startNotifier()
               } catch {
                   print("Unable to start notifier")
               }
           }
    }
    deinit {
            reachability.stopNotifier()
        }

}
//MARK: - TABLEVIEW AND SEARCHBAR
extension ImagesViewController: UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData.count == 0{
            tableview.isHidden = true
        }
        else if filteredData.count > 0 {
            tableview.isHidden = false
        }
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentPage<total_pages && indexPath.row == filteredData.count - 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell") as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
        let details = filteredData[indexPath.row]
        cell.thumbImage.image = UIImage(named: "no-image")
        cell.titlelabel.text = "No title found"
        cell.subTitleLabel.text = "No Subtitle is available for the picture"
        cell.descriptionLabel.text = "No Description available for this picture"
        if details.urls?.small != nil{
            cell.configure(with: (details.urls?.small)!)
        }
        if details.slug != nil{
            cell.subTitleLabel.text = details.slug!
        }
        if details.alt_description != nil{
            cell.titlelabel.text = details.alt_description!.capitalized
        }
        if details.description != nil{
            cell.descriptionLabel.text = details.description!
        }

        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if currentPage<total_pages && indexPath.row == filteredData.count - 1{
            currentPage = currentPage + 1
            if latest != nil{
                //APIHandler.shared.filterAPI(currentPage, self, "architecture-interior")
                viewmodel.getFilteredImages(currentPage, self, "architecture-interior")
            }
            else if oldest != nil{
                //APIHandler.shared.filterAPI(currentPage, self, "experimental")
                viewmodel.getFilteredImages(currentPage, self, "experimental")
            }
            else if featured != nil{
                //APIHandler.shared.filterAPI(currentPage, self, "3d-renders")
                viewmodel.getFilteredImages(currentPage, self, "3d-renders")
            }
            else{
                viewmodel.getImages(currentPage , self)
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ImageDetailsViewController") as! ImageDetailsViewController
        vc.displayDetails = filteredData[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            filteredData = results
            if tableview.isHidden{
                tableview.isHidden = false
            }
            tableview.reloadData()
        }
        else{
            if filteredData.count>0{
                if tableview.isHidden{
                    tableview.isHidden = false
                }
            }
           // filteredData = results.filter({($0.alt_description!.capitalized.contains(searchText.trimmingCharacters(in: .whitespaces)))})
            filteredData = results.filter { item in
                let altDescription = item.alt_description?.capitalized ?? "No title found"
                return altDescription.contains(searchText.trimmingCharacters(in: .whitespaces).capitalized)
            }
            if filteredData.count == 0{
                tableview.isHidden = true
            }
            tableview.reloadData()
        }
    }
    //MARK: - FILTER
   @IBAction func buttonClicked(_ sender: UIBarButtonItem) {
        let latest = UIAction(title: "Latest") { _ in
            print("Latest  is selected")
            self.currentPage = 1
            self.latest = "latest"
            self.oldest = nil
            self.featured = nil
            self.filteredData = []
            self.results = []
            //MARK: - ADD VIEWMODEL FUNC HERE
            //APIHandler.shared.filterAPI(self.currentPage, self, "architecture-interior")
            self.viewmodel.getFilteredImages(self.currentPage, self, "architecture-interior")
        }
        let oldest = UIAction(title: "Oldest") { _ in
            print("Oldest type is selected")
            self.currentPage = 1
            self.oldest = "oldest"
            self.featured = nil
            self.latest = nil
            self.filteredData = []
            self.results = []
           // APIHandler.shared.filterAPI(self.currentPage, self, "nature")
            self.viewmodel.getFilteredImages(self.currentPage, self, "nature")
        }
       let featured = UIAction(title: "Featured") { _ in
           print("Featured type is selected")
           self.currentPage = 1
           self.featured = "featured"
           self.latest = nil
           self.oldest = nil
           self.filteredData = []
           self.results = []
          // APIHandler.shared.filterAPI(self.currentPage, self, "3d-renders")
           self.viewmodel.getFilteredImages(self.currentPage, self, "3d-renders")
       }
        let menu = UIMenu(title: "Filter By",children: [latest,oldest,featured])
        
        sender.menu = menu
    }
    //MARK: - SORT
    @IBAction func sortButton(_ sender: UIBarButtonItem){
        if selectedSort == false{
            
            sender.image = UIImage(named: "desc")
            ascendingSort(filteredData)
            selectedSort = true
        }
        else{
            
            sender.image = UIImage(named: "ascen")
            descendingSort(filteredData)
            selectedSort = false
        }
    }
    
    func ascendingSort(_ unsorted:[Result]){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let sortedArray = unsorted.sorted { (first, second) in
            if let firstDate = dateFormatter.date(from: first.created_at ?? "2000-01-01T00:00:00Z"),
               let secondDate = dateFormatter.date(from: second.created_at ?? "2000-01-01T00:00:00Z") {
                return firstDate < secondDate
            } else {
                print("Something wrong at date")
                return false // Handle invalid dates here
            }
        }
        results = sortedArray
        filteredData = sortedArray
        tableview.reloadData()
        
    }
    func descendingSort(_ unsorted:[Result]){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let sortedArray = unsorted.sorted { (first, second) in
            if let firstDate = dateFormatter.date(from: first.created_at ?? "2000-01-01T00:00:00Z"),
               let secondDate = dateFormatter.date(from: second.created_at ?? "2000-01-01T00:00:00Z") {
                return firstDate > secondDate
            } else {
                print("Something wrong at date")
                return false // Handle invalid dates here
            }
        }
        results = sortedArray
        filteredData = sortedArray
        tableview.reloadData()
        
    }
    
}
